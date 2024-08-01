// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST4 {
    /*
    간단한 게임이 있습니다.
    유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
    참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
    4명까지만 들어올 수 있는 방이 있습니다. (array)
    선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

    예) 
    방 안 : "empty" 
    -- A 입장 --
    방 안 : A 
    -- B, D 입장 --
    방 안 : A , B , D 
    -- F 입장 --
    방 안 : A , B , D , F 
    A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
    방 안 : "empty" 

    유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
    예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

    * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    ---------------------------------------------------------------------------------------------------
    * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    */

    struct User {
        uint number;
        string name;
        address addr;
        uint balance;
        uint score;
    }

    User[] users;
    User[] room;

    constructor() {
        User memory admin = User(0, "admin", msg.sender, msg.sender.balance, 0);
        users.push(admin);
    }

    modifier CheckRoom {
        _;
        if (room.length % 4 == 0) { 
            setScore();
        }
    }

    // * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function setUser(string memory _name) internal CheckRoom {
        User memory user;
        if (checkUser()) {
            users[getUserNumber()].name = _name;
            user = users[getUserNumber()];
        } else {
            user = User(users.length, _name, msg.sender, msg.sender.balance, 0);
            users.push(user);   
        }
        
        joinRoom(user);
    }

    function checkUser() internal view returns(bool) {
        for (uint i = 0; i < users.length; i ++) {
            if (msg.sender == users[i].addr) {
                return true;
            }
        }

        return false;
    }

    function joinRoom(User memory _user) internal {
        for (uint i = 0; i < room.length; i ++) {
            if (room[i].addr == _user.addr) {
                revert("Already join room");
            }
        }
        room.push(_user);
    }

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function getUser() public view returns(User memory) {
        return users[getUserNumber()];
    }

    function getUserNumber() internal view returns(uint) {
        for (uint i = 0; i < users.length; i ++) {
            if (msg.sender == users[i].addr) {
                return users[i].number;
            }
        }
        revert("Not found.");
    }

    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function joinGame(string memory _name) public payable {
        require(msg.sender.balance >= 0.01 ether, "Must be more than 0.01 ETH.");
        setUser(_name);
    }

    function setScore() public {
        uint score = 4;
        for (uint i = 0; i < room.length; i ++) {
            users[room[i].number].score += score - i;
        }

        delete room;
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function withdraw() public {
        uint userNumber = getUserNumber();
        require(users[userNumber].score >= 10, "Insufficient score.");

        uint amount = users[userNumber].score / 10 * 0.1 ether;
        payable(users[userNumber].addr).transfer(amount);
        users[userNumber].score %= 10;
    }

    modifier CheckAdmin {
        require(getUserNumber() == 0, "You are not an admin.");
        _;
    }

    // * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    function withdrawFullAmount() public CheckAdmin {
        payable(users[0].addr).transfer(address(this).balance);
    }

    function withdrawPartialAmount(uint _balance) public CheckAdmin {
        require(address(this).balance >= _balance, "Insufficient balance");
        payable(users[0].addr).transfer(_balance);
    }

    function deposit() public payable {
        uint userNumber = getUserNumber();
        users[userNumber].balance += msg.value;
    }
}