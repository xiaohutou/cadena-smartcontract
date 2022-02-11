//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Scores{
    address payable public teacher;
    uint256 _withdrawDate ;
    struct Student{
        string name;
        uint score;
        uint fee;
    }
            
    mapping (address => Student) students;
    event ScoreRelease(address _id, uint _score);
    
    constructor(){
        teacher = payable(msg.sender);
        _withdrawDate += 240;
    }
    
    function register(string memory _name) public payable{
        require(msg.value == 100000000000000000);
        students[msg.sender].score = 0    ;
        students[msg.sender].name = _name;
        students[msg.sender].fee += msg.value ;
    }

    function fetchInfo(address _sid) external view returns (uint, uint){
        return (students[_sid].score, students[_sid].fee);
    }
    
    function ChargeFee(address _sid) internal{
        teacher.transfer(students[_sid].fee);
        students[_sid].fee = 0;
    }
    
    function score(address _sid, uint _score) public{
        require(msg.sender == teacher);
        require(block.timestamp < (_withdrawDate - 10)) ;
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
