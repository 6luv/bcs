// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST6 {
    /*
    숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
    예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   5,3,9 // 28712 -> 5,   2,8,7,1,2
    --------------------------------------------------------------------------------------------
    문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
    예) abde -> 4,   a,b,d,e // fkeadf -> 6,   f,k,e,a,d,f
    */

    function getDigit(uint _num) public pure returns(uint, uint[] memory) {
        uint digit;
        uint num = _num;
        while(_num > 0) {
            digit++;
            _num /= 10;
        }

        uint[] memory number = new uint[](digit);
        for (uint i = digit; i > 0; i --) {
            number[i - 1] = num % 10;
            num /= 10;
        }

        return (digit, number);
    }

    function getChar(string memory _str) public pure returns(uint, string[] memory) {
        bytes memory _bytesStr = bytes(_str);
        uint length = _bytesStr.length;
        string[] memory char = new string[](length);

        for (uint i = 0; i < length; i ++) {
            char[i] = string(abi.encodePacked(_bytesStr[i]));
        }

        return (length, char);
    }
}