pragma solidity >=0.8.0;

struct datosStaker {
  uint stakedBalance;
  uint timestamp;
  uint rewards;
}
struct IndexValue {
  uint keyIndex;
  datosStaker value;
}

struct KeyFlag {
  address key;
  bool deleted;
}

struct itmap {
  mapping(address => IndexValue) data;
  KeyFlag[] keys;
  uint size;
}

library IterableMapping {
  function insert(itmap storage mapa, address key, datosStaker memory value) internal returns (bool replaced) {
      uint keyIndex = mapa.data[key].keyIndex;
      mapa.data[key].value = value;
      if (keyIndex > 0){
        return true;
      }
      else{
        keyIndex = mapa.keys.length;
        mapa.keys.push();
        mapa.data[key].keyIndex = keyIndex+1;
        mapa.keys[keyIndex].key = key;
        mapa.size++;
        return false;

      }

  }

  function remove(itmap storage mapa, address key) internal returns (bool sucess) {
    uint keyIndex = mapa.data[key].keyIndex;
    if (keyIndex==0){
      return false;
    }
    delete mapa.data[key];
    mapa.keys[keyIndex-1].deleted = true;
    mapa.size--;

  }

  function contains(itmap storage mapa, address key) internal view returns (bool) {
    return mapa.data[key].keyIndex > 0;
  }

  function iterate_start(itmap storage mapa) internal view returns (uint keyIndex) {
    return iterate_next(mapa, 0);
  }

  function iterate_valid(itmap storage mapa, uint keyIndex) internal view returns (bool) {
    return keyIndex < mapa.keys.length;
  }

  function iterate_next(itmap storage mapa, uint keyIndex) internal view returns (uint) {

    while (keyIndex < mapa.keys.length && mapa.keys[keyIndex].deleted) {
        keyIndex++;
    }
    return keyIndex;
  }

  function iterate_get(itmap storage mapa, uint keyIndex) internal view returns (address key, datosStaker memory value) {
    key = mapa.keys[keyIndex].key;
    value = mapa.data[key].value;
  }
}
