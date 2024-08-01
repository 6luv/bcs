// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Q71 {
    /*
    숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
    한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    */

    uint public a;
    uint lastBlockTime;

    constructor() {
        lastBlockTime = block.timestamp;
    }

    function setA(uint _a) public {
        require(block.timestamp >= lastBlockTime);
        a = _a;
        lastBlockTime += 10 minutes;
    }
}

contract Q72 {
    /*
    contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요. 
    해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요. owner는 배포와 동시에 배포자로 설정하십시오. 
    한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
    
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), 
    D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(D), E가 65 deposit(E가 owner)
    */

    address public owner;
    uint public maxAmount;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0 wei);
        if (msg.value > maxAmount) {
            maxAmount = msg.value;
            owner = msg.sender;
        }
    }

    function withdraw(uint _amount) public {
        require(owner == msg.sender);
        payable(owner).transfer(_amount);
    }
}

contract Q73 {
    /*
    위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), 
    D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 depoist(E가 owner, E 누적 65), E가 65 deposit(E)
    */

    address public owner;
    uint public maxAmount;
    mapping(address => uint) depositBalances;

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0 wei);
        depositBalances[msg.sender] += msg.value;
        if (depositBalances[msg.sender] > maxAmount) {
            maxAmount = depositBalances[msg.sender];
            owner = msg.sender;
        }
    }

    function withdraw(uint _amount) public {
        require(owner == msg.sender);
        require(address(this).balance >= _amount);
        payable(owner).transfer(_amount);
    }
}

contract Q74 {
    /*
    어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    
    예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 
    // 42 -> 46(42+4), 2 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) 
    // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
    */

    function getNumber(uint _n) public pure returns(uint, uint) {
        return (_n + _n / 10, _n % 10);
    }
}

contract Q75 {
    /*
    문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    
    예) abc,3 -> abcabcabc // ab,5 -> ababababab
    */

    function getString(string memory _str, uint _n) public pure returns(string memory res) {
        for (uint i = 0; i < _n; i ++) {
            res = string.concat(res, _str);
        }
    }
}

contract Q76 {
    /*
    숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
    (패키지없이)
    */

    function getDigits(uint _n) public pure returns(uint) {
        uint len;
        while (_n > 0) {
            len++;
            _n /= 10;
        }
        return len;
    }

    function uintToString(uint _n) public pure returns(string memory) {
        uint digits = getDigits(_n);
        bytes memory _b = new bytes(digits);

        while (_n != 0) {
            _b[--digits] = bytes1(uint8(48 + _n % 10));
            _n /= 10;
        }

        return string(_b);
    }
}

contract Q77 {
    /*
    위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    
    힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
    */

    function uintToString(uint _n) public pure returns(string memory) {
        return Strings.toString(_n);
    }
}

contract Q78 {
    /*
    숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    
    예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
    */

    function isInRange(uint[] memory _numbers) public pure returns(bool inRange) {
        for (uint i = 0; i < _numbers.length; i ++) {
            if (10 <= _numbers[i] && _numbers[i] <= 25) {
                inRange = true;
            }
        }
    }
}

contract Q79_A {
    /*
    3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요. 
    Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요. 
    학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요. 
    구현할 때는 Contract A를 import 하여 구현하세요.
    */

    function getMax(uint _a, uint _b, uint _c) public pure returns(uint) {
        return (_a > _b ? (_a > _c ? _a : _c) : (_b > _c ? _b : _c));
    }
}

contract Q79_B {
    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[3] students;
    Q79_A a = new Q79_A();

    constructor() {
        students[0] = Student("Alice", 1, 100);
        students[1] = Student("Bob", 2, 70);
        students[2] = Student("Zero", 3, 1);
    }

    function getTopScore() public view returns(uint) {
        return a.getMax(students[0].score, students[1].score, students[2].score);
    }

    function getStudent() public view returns(Student memory) {
        uint score = getTopScore();
        Student memory student;
        for (uint i = 0; i < 3; i ++) {
            if (score == students[i].score) {
                student = students[i];
            }
        }
        return student;
    }
}

contract Q80 {
    /*
    지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다. 
    1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다. 
    그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 
    가장 먼저 들어온 것이 가장 마지막에 나갑니다. 
    이런 것들을FILO(First In Last Out)이라고도 합니다. 
    가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다. 
    push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    */

    uint[] queue;
    uint front;
    uint rear;

    function initQueue() public {
        delete queue;
        front = 0;
        rear = 0;
    }

    function enqueue(uint _n) public {
        queue.push(_n);
        rear++;
    }

    function dequeue() public returns(uint) {
        require(!isEmpty());
        uint value = queue[front];
        front++;

        uint[] memory newQueue = new uint[](rear - front);
        for (uint i = 0; i < newQueue.length; i ++) {
            newQueue[i] = queue[front + i];
        }
        queue = newQueue;
        front = 0;
        rear = newQueue.length;

        return value;
    }

    function isEmpty() public view returns(bool) {
        return front == rear;
    }

    function getQueue() public view returns(uint[] memory) {
        return queue;
    }
}