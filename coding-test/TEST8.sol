// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST8 {
    /*
    안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
    안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
    안건들을 모아놓은 자료구조도 구현하세요. 

    사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

    * 사용자 등록 기능 - 사용자를 등록하는 기능
    * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    -------------------------------------------------------------------------------------------------
    * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    */

    struct Agenda {
        uint number;
        string title;
        string content;
        address addr;
        uint upvotes;
        uint downvotes;
        uint startBlockNumber;
    }

    struct User {
        string name;
        address addr;
        string[] createdAgendas;
        mapping(string => bool) vote;
        mapping(string => bool) votedAgendas;
    }

    enum Status {
        approve,
        voting,
        reject
    }

    mapping(string => Agenda) agendas;
    mapping(address => User) users;

    uint agendaIndex;
    uint votingPeriod = 15;
    uint userCount;

    // * 사용자 등록 기능 - 사용자를 등록하는 기능
    function signUp(string memory _name) public {
        User storage user = users[msg.sender];
        require(bytes(user.name).length == 0, "Nope");
        user.name = _name;
        user.addr = msg.sender;
        userCount++;
    }

    // * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function vote(string memory _title, bool _vote) public {
        Agenda storage agenda = agendas[_title];
        require(bytes(agenda.title).length > 0, "Nope");
        require(!users[msg.sender].vote[_title], "Nope");
        require(agenda.addr != msg.sender, "Nope");

        users[msg.sender].vote[_title] = true;
        users[msg.sender].votedAgendas[_title] = _vote;

        if (_vote) {
            agenda.upvotes++;
        } else {
            agenda.downvotes++;
        }
    }

    // * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    function addAgenda(string memory _title, string memory _content) public {
        require(agendas[_title].number == 0 && bytes(users[msg.sender].name).length != 0, "Nope");
        agendas[_title] = Agenda(++agendaIndex, _title, _content, msg.sender, 0, 0, block.number);
        users[msg.sender].createdAgendas.push(_title);
    }

    // * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    function getAgendas() public view returns(Agenda[] memory, Status[] memory) {
        uint length = users[msg.sender].createdAgendas.length;
        Agenda[] memory myAgendas = new Agenda[](length);
        Status[] memory status = new Status[](length);
        string memory title;

        for (uint i = 0; i < length; i ++) {
            title = users[msg.sender].createdAgendas[i];
            myAgendas[i] = agendas[title];
            status[i] = setStatus(title);
        }
        return (myAgendas, status);
    }

    // * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    function getAgenda(string memory _title) public view returns(Agenda memory, Status) {
        return (agendas[_title], setStatus(_title));
    }

    function getUserAgendas() public view returns(string[] memory) {
        return users[msg.sender].createdAgendas;
    }

    // * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 
    // 둘 중 하나라도 만족못하면 기각
    function setStatus(string memory _title) public view returns(Status) {
        Agenda memory agenda = agendas[_title];
        require(bytes(agenda.title).length > 0, "Nope");
        uint totalVote = agenda.upvotes + agenda.downvotes;
        if (totalVote <= 0) {
            return Status.voting;
        }

        uint upvotes = agenda.upvotes * 100 / totalVote;
            
        if (block.number < agenda.startBlockNumber + votingPeriod) {
            return Status.voting;
        } else if (userCount * 70 / 100 >= totalVote || upvotes < 66) {
            return Status.reject;
        } else {
            return Status.approve;
        }
    }
}