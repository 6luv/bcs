// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST11 {
    /*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

    참가 금액은 0.05이더이다.

    예시 1 : 8,2,4,7,D,A
    예시 2 : 9,1,4,2,F,B
    */

    mapping(uint => uint) public rewardAmounts;

    struct LottoItem {
        uint[4] number;
        string[2] str;
    }

    LottoItem winningLotto;

    constructor(uint[4] memory _number, string[2] memory _str) {
        winningLotto.number = _number;
        winningLotto.str = _str;

        rewardAmounts[6] = 1 ether;
        rewardAmounts[5] = 0.75 ether;
        rewardAmounts[4] = 0.25 ether;
        rewardAmounts[3] = 0.1 ether;
    }

    function buyLotto(uint[4] memory _number, string[2] memory _str) public payable {
        require(msg.value == 0.05 ether);
        uint count = countMatches(_number, _str);
        if (count > 2) {
            payable(msg.sender).transfer(rewardAmounts[count]);
        }
    }

    function countMatches(uint[4] memory _number, string[2] memory _str) internal view returns(uint) {
        uint count;
        for (uint i = 0; i < 4; i ++) {
            if (contains(_number[i])) {
                count++;
            }
        }

        for (uint i = 0; i < 2; i ++) {
            if (contains(_str[i])) {
                count++;
            }
        }
        return count;
    }

    function contains(uint _number) internal view returns(bool) {
        bool isContain;
        for (uint i = 0; i < winningLotto.number.length; i ++) {
            if (winningLotto.number[i] == _number) {
                isContain = true;
            }
        }
        return isContain;
    }

    function contains(string memory _str) internal view returns(bool) {
        bool isContain;
        for (uint i = 0; i < winningLotto.str.length; i ++) {
            if (keccak256(abi.encodePacked(winningLotto.str[i])) == keccak256(abi.encodePacked(_str))) {
                isContain = true;
            }
        }
        return isContain;
    }

    function deposit() public payable {}

    receive() external payable {}
}