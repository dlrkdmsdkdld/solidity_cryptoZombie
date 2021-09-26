pragma solidity ^0.4.19;
import "./ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint zombieId, string name, uint dna);//이벤트 선언 

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {//솔리디티에선 uint = uint256인이유가 uint의 크기에 상관하지 않고 256바이트를 잡아먹기 때문에 의미가 없지만 구조체에선 압축할수있으므로 의미가 있다 그래서 구조체안에는 uint32형을 씀
        string name;
        uint dna;
        uint32 level;//좀비레벨 나타내는 변수
        uint32 readyTime;//좀비 공격이 무제한적으로 되지않도록 쿨다운을 하는 변수
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;//uint가 키고 address가 데이터임
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) internal {//internal은 함수가 정의된 컨트랙트를 상속하는 컨트랙트에서도 접근이 가능하다 점을 제외하면 private과 동일하다 //external은 함수가 컨트랙트 바깥에서만 호출될 수 있고 컨트랙트 내의 다른 함수에 의해 호출될 수 없다는 점을 제외하면 public과 동일하다. 
        uint id = zombies.push(Zombie(_name, _dna,1, uint32(now + cooldownTime))) - 1;//좀비의 아이디 처음엔 1로시작
        zombieToOwner[id] = msg.sender;//zombieToOwner 매핑을 업데이트하여 id에 대하여 msg.sender가 저장되도록 함 좀비 아이디에따른 좀비주인이 누군지나타냄
        ownerZombieCount[msg.sender]++;//msg.sender을 고려하여 ownerZombieCount를 증가시킴 좀비 주인의 좀비개수를 나타내기 위하여
        NewZombie(id, _name, _dna);//이벤트 발생했다는 신호보내기
    }

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));//랜덤해시값 생성
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {//좀비생성
        require(ownerZombieCount[msg.sender] == 0);//플레이어당 하나의 좀비만 만들수있도록 0과 같으면 코드가 실행되고 좀비가 하나이상있으면 코드가 실행안된다
        uint randDna = _generateRandomDna(_name);//dna값 생성
        _createZombie(_name, randDna);//좀비만들기
    }

}
