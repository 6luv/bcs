// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST7 {
    /*    
    악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    --------------------------------------------------------
    충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감
    */

    enum State {
        Drive,
        Refuel,
        Break,
        Off,
        On
    }

    struct Car {
        uint speed;
        uint fuel;
        uint balance;
        State state;
    }

    mapping(address => Car) cars;

    constructor() {
        cars[msg.sender] = Car(0, 100, 0, State.Off);
    }

    function getCar() public view returns(Car memory) {
        return cars[msg.sender];
    }

    modifier engineNotOff {
        require(cars[msg.sender].state != State.Off, "Nope");
        _;
    }

    function drive() public engineNotOff {
        require(cars[msg.sender].fuel >= 30 && cars[msg.sender].speed <= 70, "Nope");
        cars[msg.sender].fuel -= 20;
        cars[msg.sender].speed += 10;
        cars[msg.sender].state = State.Drive;
    }

    function refuel() public payable engineNotOff {
        require(msg.value >= 1 ether || cars[msg.sender].balance >= 1 ether, "Nope");
        if (msg.value < 1 ether) {
            cars[msg.sender].balance -= 1 ether;
        }
        cars[msg.sender].fuel = 100;
        cars[msg.sender].state = State.Refuel;
    }

    function _break() public engineNotOff {
        require(cars[msg.sender].speed == 0 || cars[msg.sender].fuel >= 10, "Nope");
        cars[msg.sender].speed -= 10;
        cars[msg.sender].fuel -= 10;
        cars[msg.sender].state = State.Break;
    }

    function off() public engineNotOff {
        require(cars[msg.sender].speed == 0, "Nope");
        cars[msg.sender].state = State.Off;
    }

    function on() public {
        require(cars[msg.sender].state == State.Off, "Nope");
        cars[msg.sender].state = State.On;
    }

    function deposit() public payable {
        cars[msg.sender].balance += msg.value;
    }
}