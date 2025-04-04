//
//  ReceivedMsg.swift
//  swift-study
//
//  Created by 大地瓜 on 3/20/25.
//

import Foundation

struct ReceivedMsg:Codable {
    var id:String
    var object:String
    var created:UInt32
    var model:String
    var system_fingerprint:String
    var choices:[Choice]
    
    
}

struct Choice:Codable {
    var index:UInt32
    var delta:Delta
    var logprobs:String?
    var finish_reason:String?
}

struct Delta:Codable {
    var role:String?
    var content:String?
}
