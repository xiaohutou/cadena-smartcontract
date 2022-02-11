//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Student{
    string name;
    uint score;
    uint fee;
}

contract Scores{
    address payable public teacher;
    string public teacherName;
    uint256 _withdrawDate ;
    uint256 _lockDate;

            
    mapping (address => Student) private students;
    Student [] students_list;

    event ScoreRelease(address _id, uint _score);
    
    constructor(){
        teacher = payable(msg.sender);
        _withdrawDate += 240;
        _lockDate += 100;
    }

    function getStudentNum() public view returns (uint){
        require(msg.sender == teacher);
        return students_list.length;
    }

    function listAllStudents() public view returns (Student [] memory){
        require(msg.sender == teacher);
        return students_list;
    }
    
    function setTeacheName(string memory _name) public {
        require(msg.sender == teacher);
        teacherName = _name;
    }
    
    function register(string memory _name) public payable{
        require(msg.value == 100000000000000000);
        require(msg.sender != teacher);
        require(block.timestamp < _lockDate);
        students[msg.sender].score = 0;
        students[msg.sender].name = _name;
        students[msg.sender].fee += msg.value ;
        students_list.push(students[msg.sender]);
    }

    function fetchInfo(address _sid) external view returns (Student memory){
        return students[_sid];
    }
    
    function ChargeFee(address _sid) internal{
        teacher.transfer(students[_sid].fee);
        students[_sid].fee = 0;
    }
    
    function score(address _sid, uint _score) public{
        require(msg.sender == teacher);
        require(block.timestamp < (_withdrawDate - 10));
        require(block.timestamp > _lockDate) ;
        require(students[_sid].fee > 0) ;
        students[_sid].score = _score;
        ChargeFee(_sid);
        emit ScoreRelease(_sid, _score);
    }

    function withdrawFee(address payable _sid) public payable{
        require(block.timestamp > _withdrawDate);
        require(students[_sid].fee > 0) ;
        require(students[_sid].score == 0) ;
        _sid.transfer(students[_sid].fee);
    }
}
