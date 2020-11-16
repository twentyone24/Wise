//
//  RoomViewModal.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/13/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseFirestore


struct Rooms: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var createdAt: Date?
    var createdBy: String?
    var roomId: String?
    var roomName: String?
    var subject: String?
    var students: [String]?
    
    enum Keys: String, CodingKey {
        case createdBy = "createdBy"
        case createdAt = "createdAt"
        case roomId = "roomId"
        case roomName = "roomName"
        case subject = "subject"
        case students = "students"
    }
    
}


struct Msg: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var isTeacher: Bool
    var sentBy: String
    var sentAt: Date
    var text: String
    
    
    enum Keys: String, CodingKey {
        case isTeacher = "isTeacher"
        case sentBy = "sentBy"
        case sentAt = "sentAt"
        case text = "text"
        
    }
}

struct Attendence: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var isAccepted: Bool
    var name: String
    var joinedAt: Date?
    var phone: String
    
    enum Keys: String, CodingKey {
        case isAccepted = "isAccepted"
        case name = "name"
        case joinedAt = "joinedAt"
        case phone = "phone"
    }
    
}

struct Attachments: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var sentAt: Date?
    var desc: String?
    var docUrl: String?
    var sentBy: String?
    var title: String?
    
    enum Keys: String, CodingKey {
        case sentAt = "sentAt"
        case desc = "desc"
        case docUrl = "docUrl"
        case sentBy = "sentBy"
        case title = "title"
    }
    
}

struct Assessments: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var addedAt: Date
    var submTime: Date
    var desc: String?
    var addedBy: String?
    var docUrl: String?
    var title: String
    var maxMarks: Int?
    
    enum Keys: String, CodingKey {
        case addedAt = "addedAt"
        case submTime = "submTime"
        case addedBy = "addedBy"
        case docUrl = "docUrl"
        case sentBy = "sentBy"
        case title = "title"
        case maxMarks = "maxMarks"
    }
    
}

struct Submission: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var isGraded: Bool
    var name: String
    var submAt: Date?
    var docUrl: String?
    var marks: Int?
    
    enum Keys: String, CodingKey {
        case isGraded = "isGraded"
        case name = "name"
        case submAt = "submAt"
        case docUrl = "docUrl"
        case marks = "marks"
    }
    
}


struct User: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var dp: String?
    var isTeacher: Bool
    var name: String?
    var phone: String?
    
    enum Keys: String, CodingKey {
        case dp = "dp"
        case isTeacher = "isTeacher"
        case name = "name"
        case phone = "phone"
    }
}

