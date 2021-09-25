pragma solidity ^0.4.19;

import "./zombiefactory.sol";

contract ZombieFeeding is ZombieFactory {

 contract KittyInterface {//크립토키티 인터페이스 //인터페이스를 정의하는 것이 컨트랙트를 정의하는 것과 유사하다는 걸 참고하게. 먼저, 다른 컨트랙트와 상호작용하고자 하는 함수만을 선언할 뿐(이 경우, getNum이 바로 그러한 함수이지) 다른 함수나 상태 변수를 언급하지 않네.다음으로, 함수 몸체를 정의하지 않지. 중괄호 {, }를 쓰지 않고 함수 선언을 세미콜론(;)으로 간단하게 끝내지.그러니 인터페이스는 컨트랙트 뼈대처럼 보인다고 할 수 있지. 컴파일러도 그렇게 인터페이스를 인식하지.우리의 dapp 코드에 이런 인터페이스를 포함하면 컨트랙트는 다른 컨트랙트에 정의된 함수의 특성, 호출 방법, 예상되는 응답 내용에 대해 알 수 있게 되지.
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
 }
  function feedAndMultiply(uint _zombieId, uint _targetDna,string _species) public {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;//크립토키티 컨트랙트 주소
    kittyContract kittyInterface = kittyContract(ckAddress);//크립토키티 스마트 컨트랙트에서 데이터를 읽어 오도록 우리 컨트랙트를 설정함
    
    require(msg.sender == zombieToOwner[_zombieId]);//호출자와 좀비주인이 같은지 확인하는코드
    Zombie storage myZombie = zombies[_zombieId];//마이좀비에 좀비 복사 좀비에게 먹이주기위해 복사하는것
    _targetDna = _targetDna % dnaModulus;//먹이 dna도 16자 제한 만듬
    uint newDna = (myZombie.dna + _targetDna) / 2; //먹이와 좀비 디엔에이를 섞어서 새로운 디엔에이 생성
    if (keccak256(_species) == keccak256("kitty")) {//종이 키티면 원래 좀비 dna와 구분하기위한 if문
      newDna = newDna - newDna % 100 + 99;//dna 마지막 두자리는 99로 지정
    }
    _createZombie("NoName", newDna);
  }
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);//키티 유전자만 리턴받는 코드
    feedAndMultiply(_zombieId, kittyDna,"kitty");//키티 유전자와 좀비아이디로 합침
  }

}

