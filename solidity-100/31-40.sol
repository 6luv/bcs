// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract Q31 {
    /*
    string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
    */

    function isAliceAndBob(string memory _input) public pure returns(bool) {
        bytes32 aliceHash = keccak256(abi.encodePacked("Alice"));
        bytes32 bobHash = keccak256(abi.encodePacked("Bob"));
        bytes32 inputHash = keccak256(abi.encodePacked(_input));
        
        return (inputHash == aliceHash || inputHash == bobHash);
    }
}

contract Q32 {
    /*
    3의 배수만 들어갈 수 있는 array를 구현하되, 
    3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    */

    uint[] array;

    function pushArray(uint _num) public {
        if (_num % 3 == 0 && _num % 10 != 0) {
            array.push(_num);
        }
    }
}

contract Q33 {
    /*
    이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 
    고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    */

    struct Customer {
        string name;
        uint number;
        address addr;
        uint birth;
    }

    mapping(string => Customer) customers;

    function pushCustomer(string memory _name, uint _number, address _addr, uint _birth) public {
        customers[_name] = Customer(_name, _number, _addr, _birth);
    }

    function getCustomer(string memory _name) public view returns(Customer memory) {
        return customers[_name];
    }
}

contract Q34 {
    /*
    이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 
    학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    */

    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[] students;

    function pushStudent(Student memory _student) public {
        students.push(_student);
    }

    function getAverage() public view returns(uint) {
        uint sum;

        for (uint i = 0; i < students.length; i ++) {
            sum += students[i].score;
        }

        return sum / students.length;
    }
}

contract Q35 {
    /*
    숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    */

    function getEven(uint[] memory _numbers) public pure returns(uint[] memory) {
        uint length = _numbers.length / 2;
        uint[] memory temp = new uint[](length);
        uint idx;

        for (uint i = 1; i < _numbers.length; i += 2) {
            temp[idx++] = _numbers[i];
        }

        return temp;
    }
}

contract Q36 {
    /*
    high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high,
    4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    */

    string state;

    function getState(uint _a) public {
        if (_a >= 7) {
            state = "high";
        } else if (_a >= 4) {
            state = "neutral";
        } else {
            state = "low";
        }
    }
}

contract Q37 {
    /*
    7. 1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 
    최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    
    (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    */

    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier check(uint _value) {
        require(msg.value == _value, "Nope");
        _;
    }

    function donate1Wei() public payable check(1 wei) {}
    function donate1Finney() public payable check(0.001 ether) {}
    function donate1Ether() public payable check(1 ether) {}

    function withdraw() public {
        require(msg.sender == owner, "Nope");
        owner.transfer(address(this).balance);
    }
}

contract Q38 {
    /*
    상태변수 a를 "A"로 설정하여 선언하세요. 
    이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 
    단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    
    (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
    */

    address owner;
    string a = "A";

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Nope");
        _;
    }

    function setB() public onlyOwner {
        a = "B";
    }

    function setC() public onlyOwner {
        a = "C";
    }
}

contract Q39 {
    /*
    특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) 
    // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    */

    function getMultiples(uint _num) public pure returns(uint, uint, uint, uint) {
        return (_num / 2, _num / 3, _num / 5, _num / 7);
    }
}

contract Q40 {
    /*
    숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 
    가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    */

    function sort(uint[] memory _numbers) internal pure returns(uint[] memory) {
        for (uint i = 0; i < _numbers.length; i ++) {
            for (uint j = i + 1; j < _numbers.length; j ++) {
                if (_numbers[i] > _numbers[j]) {
                    (_numbers[i], _numbers[j]) = (_numbers[j], _numbers[i]);
                }
            }
        }

        return _numbers;
    }

    function getMid(uint[] memory _numbers) public pure returns(uint[] memory mid) {
        uint[] memory sortedNumbers = sort(_numbers);
        mid = new uint[](2 - _numbers.length % 2);
        
        if (sortedNumbers.length % 2 == 0) {
            mid[0] = sortedNumbers[sortedNumbers.length / 2 - 1];
            mid[1] = sortedNumbers[sortedNumbers.length / 2];
        } else {
            mid[0] = sortedNumbers[sortedNumbers.length / 2];
        }
    }
}