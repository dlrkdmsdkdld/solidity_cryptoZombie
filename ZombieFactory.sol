pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);//이벤트 선언 

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;//uint가 키고 address가 데이터임
    mapping (address => uint) ownerZombieCount;

    function _createZombie(string _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;//좀비의 아이디 처음엔 1로시작
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
