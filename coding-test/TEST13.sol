// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST13 {
    /*
    가능한 모든 것을 inline assembly로 진행하시면 됩니다.
    1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
    2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
    3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
    4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요. 
    5. number의 k번째 요소를 반환하는 함수를 구현하세요.
    6. number2의 k번째 요소를 반환하는 함수를 구현하세요.
    */

    uint[] public number;
    uint[4] public number2;

    function pushArray1(uint _n) public {
        assembly {
            let length := sload(number.slot)
            mstore(0x0, number.slot)

            let nslot := add(keccak256(0x0, 0x20), length)
            sstore(number.slot, add(length, _n))

            for { let i := 0 } lt(i, _n) { i := add(i, 1) } {
                sstore(add(nslot, i), add(i, 1))
            }
        }
    }

    function pushArray2(uint _a, uint _b, uint _c, uint _d) public {
        assembly {
            let slot := number2.slot
            
            sstore(slot, _a)
            sstore(add(slot, 1), _b)
            sstore(add(slot, 2), _c)
            sstore(add(slot, 3), _d)
        }
    }

    function getNumber1() public view returns(uint) {
        assembly {
            let sum := 0
            let length := sload(number.slot)
            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                sum := add(sum, sload(number.slot))
            }
            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    function getNumber2() public view returns(uint) {
        assembly {
            let sum := 0
            for { let i := 0 } lt(i, 4) { i := add(i, 1) } {
                sum := add(sum, add(sload(number2.slot), i))
            }
            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    function getK1(uint _k) public view returns(uint result) {
        assembly {
            mstore(0x0, number.slot)
            let slot := keccak256(0x0, 0x20)
            let kSlot := add(slot, _k)
            result := sload(kSlot)
        }
    }

    function getK2(uint _k) public view returns(uint result) {
        assembly {
            let slot := number2.slot
            let kSlot := add(slot, _k)
            result := sload(kSlot)
        }
    }
}