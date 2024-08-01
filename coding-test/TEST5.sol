// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TEST5 {
    /*
    숫자를 시분초로 변환하세요.
    예) 100 -> 1 min 40 sec
    600 -> 10min 
    1000 -> 16min 40sec
    5250 -> 1hour 27min 30sec
    */

    function getTime(uint _time) public pure returns(string memory) {
        (uint hour, uint remainingTime) = getHour(_time);
        (uint min, uint sec) = getMin(remainingTime);
        return getFormat(hour, min, sec);
    }

    function getFormat(uint hour, uint min, uint sec) internal pure returns(string memory) {
        string memory time;
        if (hour != 0) {
            time = string.concat(Strings.toString(hour), "hour ");
        } 
        
        if (min != 0) {
            time = string.concat(time, Strings.toString(min));
            time = string.concat(time, "min ");
        } 
        
        if (sec != 0) {
            time = string.concat(time, Strings.toString(sec));
            time = string.concat(time, "sec ");
        }

        return time;
    }

    function getHour(uint _time) internal pure returns(uint, uint) {
        uint hour = _time / 1 hours;
        uint time = _time % 1 hours;

        return(hour, time);
    }

    function getMin(uint _time) internal pure returns(uint, uint) {
        uint min = _time / 1 minutes;
        uint time = _time % 1 minutes;

        return(min, time);
    }
}