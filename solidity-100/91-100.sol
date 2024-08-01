// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q91 {
    /*
    배열에서 특정 요소를 없애는 함수를 구현하세요. 
    예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    */
    uint[] public array;

    function pushNumbers(uint _n) public {
        array.push(_n);
    }

    function pop(uint _n) public {
        require(array.length > _n);
        for (uint i = _n - 1; i < array.length - 1; i ++) {
            array[i] = array[i + 1];
        }
        array.pop();
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}

contract Q92 {
    /*
    특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    */

    function isContract(address _addr) public view returns(bool) {
        return _addr.code.length > 0;
    }
}

contract Q93 {
    /*
    다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다. 
    input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    */

    address contractAddr;

    function setContract(address _addr) public {
        contractAddr = _addr;
    }

    function Call(bytes4 methodId, uint _n, address _addr) public {
        bytes memory data = abi.encodePacked(methodId, abi.encode(_n, _addr));
        (bool success, ) = contractAddr.call(data);
        require(success);
    }
}

contract Q94 {
    /*
    inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    */

    function add(uint _a, uint _b) public pure returns(uint) {
        assembly {
            mstore(0x80, add(_a, _b))
            return (0x80, 0x20)
        }
    } 

    function sub(uint _a, uint _b) public pure returns(uint) {
        assembly {
            mstore(0x80, sub(_a, _b))
            return (0x80, 0x20)
        }
    }

    function mul(uint _a, uint _b) public pure returns(uint) {
        assembly {
            mstore(0x80, mul(_a, _b))
            return (0x80, 0x20)
        }
    }

    function div(uint _a, uint _b) public pure returns(uint) {
        assembly {
            mstore(0x80, div(_a, _b))
            return (0x80, 0x20)
        }
    }
}

contract Q95 {
    /*
    inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
    */

    function add(uint _a, uint _b, uint _c) public pure returns(uint) {
        assembly {
            mstore(0x80, add(_a, add(_b, _c)))
            return (0x80, 0x20)
        }
    }

    function mul(uint _a, uint _b, uint _c) public pure returns(uint) {
        assembly {
            mstore(0x80, mul(_a, mul(_b, _c)))
            return (0x80, 0x20)
        }
    }
}

contract Q96 {
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */

    function compare(uint[4] memory _numbers) public pure returns(uint max, uint min) {
        assembly {
            let ptr := _numbers
            min := mload(ptr)
            max := mload(ptr)

            for { let i := 1 } lt(i, 4) { i := add(i, 1) } {
                let num := mload(add(ptr, mul(i, 0x20)))
                
                if gt(num, max) {
                    max := num
                }
                
                if lt(num, min) {
                    min := num
                }
            }
        }
    }
}

contract Q97 {
    /*
    inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
    */

    uint[] public numbers;

    function push(uint _n) public {
        assembly {
            let length := sload(numbers.slot)
            mstore(0x0, numbers.slot)
            let nslot := add(keccak256(0x0, 0x20), length)

            sstore(nslot, _n)
            sstore(numbers.slot, add(length, 1))
        }
    }

    function pop() public {
        assembly {
            let length := sload(numbers.slot)
            if iszero(length) {revert(0, 0)} 

            mstore(0x0, numbers.slot)
            let slot := add(keccak256(0x0, 0x20), sub(length, 1))
            sstore(slot, 0)
            sstore(numbers.slot, sub(length, 1))
        }
    }

    function getNumbers() public view returns(uint[] memory data) {
        assembly {
            let length := sload(numbers.slot)
            mstore(0x0, numbers.slot)
            data := mload(0x40)
            let baseSlot := keccak256(0x0, 0x20)

            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                let num := sload(add(baseSlot, i))
                mstore(add(data, mul(add(i, 1), 0x20)), num)
            }
        }
    }
}

contract Q98 {
    /*
    inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요.
    */

    string public letter;

    function setLetter(string memory _letter) public {
        assembly {
            let length := mload(_letter) 
            let data := add(_letter, 0x20)
            
            mstore(0x0, letter.slot)
            sstore(letter.slot, length)
            
            let slot := keccak256(0x0, 0x20)
            for { let i := 0 } lt(i, length) { i := add(i, 0x20) } {
                sstore(slot, mload(add(data, mul(i, 0x20))))
                slot := add(slot, 1)
            }
        }
    }
}

contract Q99 {
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */

    function compare(uint[4] memory _numbers) public pure returns(uint max, uint min) {
        assembly {
            let ptr := _numbers
            min := mload(ptr)
            max := mload(ptr)

            for { let i := 1 } lt(i, 4) { i := add(i, 1) } {
                let num := mload(add(ptr, mul(i, 0x20)))
                
                if gt(num, max) {
                    max := num
                }
                
                if lt(num, min) {
                    min := num
                }
            }
        }
    }
}

contract Q100 {
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */

    function compare(uint[4] memory _numbers) public pure returns(uint max, uint min) {
        assembly {
            let ptr := _numbers
            min := mload(ptr)
            max := mload(ptr)

            for { let i := 1 } lt(i, 4) { i := add(i, 1) } {
                let num := mload(add(ptr, mul(i, 0x20)))
                
                if gt(num, max) {
                    max := num
                }
                
                if lt(num, min) {
                    min := num
                }
            }
        }
    }
}