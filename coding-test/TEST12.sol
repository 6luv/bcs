// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST12 {
    /*
    주차정산 프로그램을 만드세요. 주차시간 첫 2시간은 무료, 그 이후는 1분마다 200원(wei)씩 부과합니다. 
    주차료는 차량번호인식을 기반으로 실행됩니다.
    주차료는 주차장 이용을 종료할 때 부과됩니다.
    ----------------------------------------------------------------------
    차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
    차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
    */

    struct Parking {
        uint startTime;
        uint endTime;
        uint totalFee;
        uint discount;
    }

    mapping(string => Parking) public records;

    function startParking(string memory _number) public {
        require(records[_number].startTime == 0);
        records[_number] = Parking(block.timestamp, block.timestamp + 1 minutes, 0, 0);
    }

    function endParking(string memory _number) public {
        uint currentTime = block.timestamp;
        if (currentTime > records[_number].endTime) {
            uint extraMinute = (currentTime - records[_number].endTime) / 1 minutes;
            records[_number].totalFee = extraMinute * 200;
            setDiscount(_number);
        }
        records[_number].totalFee -= records[_number].discount;
    }

    function pay(string memory _number) public payable {
        require(msg.value >= records[_number].totalFee);
        delete records[_number];
    }

    function getTotalFee(string memory _number) public view returns(uint) {
        return records[_number].totalFee;
    }

    function setDiscount(string memory _number) internal {
        bytes memory number = bytes(_number);
        bool digit = isNum(number);
        if (digit) {
            records[_number].discount = records[_number].totalFee * 80 / 100;
        }

        bool str = isStr(number);
        if (str) {
            records[_number].discount = records[_number].totalFee * 50 / 100;
        }
    }

    function isNum(bytes memory _number) internal pure returns(bool) {
        bool digit;
        for (uint i = 0; i < _number.length; i ++) {
            bytes1 char = _number[i];
            if (bytes1('0') <= char && char <= bytes1('9')) {
                digit = true;
            }
        }
        return digit;
    }

    function isStr(bytes memory _number) internal pure returns(bool) {
        bool str;
        for (uint i = 0; i < _number.length; i ++) {
            bytes1 char = _number[i];
            if (bytes1('a') <= char && char <= bytes1('z') || bytes1('A') <= char && char <= bytes1('Z')) {
                str = true;
            }
        }
        return str;
    }
}