pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId){
    require(zombies[_zombieId].level>=_level);//좀비 레벨이 필요레벨보다 높아야한다는 코드
    _;//함수의 다음 부분을 실행하게 해주는 코드
  }
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);//좀비 레벨이 2이상이면 이름을 바꿀수있게하는 함수
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);//좀비 레벨이 20이상이면 dna를 바꿀수있게하는 함수
    zombies[_zombieId].dna = _newDna;
  }
  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);//memory를 쓰면 함수가 끝날때까지만 존재
    // 여기서 시작하게
    return result;
  }

}
