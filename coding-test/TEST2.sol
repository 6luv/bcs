// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 < 0.9.0;

contract TEST2 {
    /*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    * 가장 점수가 낮은 사람의 정보를 보여주는 기능,
    * 총 점수 합계, 총 점수 평균을 보여주는 기능,
    * 특정 학생을 반환하는 기능, -> 학생 정보
    ---------------------------------------------------
    * 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    */

    struct Student {
        uint number;
        string name;
        uint score;
    }

    Student[] students;
    
    function getLowestScoreStudent() public view returns(Student memory) {
        uint minScore = students[0].score;
        uint number = students[0].number;
        
        for (uint i = 1; i < students.length; i ++) {
            if (students[i].score < minScore) {
                minScore = students[i].score;
                number = students[i].number;
            }
        }

        return students[number - 1];
    }

    function getScore() public view returns(uint, uint) {
        uint totalScore;

        for (uint i = 0; i < students.length; i ++) {
            totalScore += students[i].score;
        }

        return (totalScore, totalScore / students.length);
    }

    function getStudent(uint _number) public view returns(Student memory) {
        require(_number > 0 && _number <= students.length, "Invalid number");
        return students[_number - 1];
    }

    function getStudents() public view returns(Student[] memory) {
        return students;
    }
}