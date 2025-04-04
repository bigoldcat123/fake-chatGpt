//
//  Message.swift
//  ChatGPT
//
//  Created by 大地瓜 on 3/19/25.
//

import Foundation
import SwiftData

@Model
class MessageGroup:Identifiable {
    var id = UUID()
    var title:String
    var messages:[Message]
    init(messages: [Message],title:String) {
        self.messages = messages
        self.title = title
    }
}

struct Message:Identifiable,Codable {
    var id = UUID()
    var role:Role
    var content:String
}

enum Role:String,Codable{
    case user = "user"
    case system = "system"
    case assistant = "assistant"
    case processing = "e"
}

//struct Message: Codable {
//    let role: Role
//    let content: String
//}
//
//enum Role:String,Codable {
//    case system = "system"
//    case user = "user"
//}
