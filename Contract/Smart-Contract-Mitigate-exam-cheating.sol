// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ExamCheatingMitigation {

    address public admin;

    struct ExamRecord {
        string studentId;
        string examHash; // Hash of exam answers
        uint256 timestamp;
    }

    mapping(string => ExamRecord) public examRecords;

    event ExamSubmitted(string studentId, uint256 timestamp);
    event ExamVerified(string studentId, bool isValid);

    constructor() {
        admin = msg.sender;
    }

    // 1️⃣ Submit Exam (stores hashed answers)
    function submitExam(string memory _studentId, string memory _examHash) public {
        examRecords[_studentId] = ExamRecord(_studentId, _examHash, block.timestamp);
        emit ExamSubmitted(_studentId, block.timestamp);
    }

    // 2️⃣ Verify Exam Hash
    function verifyExam(string memory _studentId, string memory _providedHash) public view returns (bool) {
        return keccak256(abi.encodePacked(examRecords[_studentId].examHash)) ==
               keccak256(abi.encodePacked(_providedHash));
    }

    // 3️⃣ Change Admin (only current admin can change)
    function changeAdmin(address newAdmin) public {
        require(msg.sender == admin, "Only admin can change admin");
        admin = newAdmin;
    }
}

