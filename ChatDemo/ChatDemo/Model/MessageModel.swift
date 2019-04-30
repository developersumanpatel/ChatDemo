//
//  MessageModel.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import Foundation
enum MessageType {
    case TEXT
    case IMAGE
    case AUDIO
    case VIDEO
}

enum MessageStatus {
    case SENDING
    case SENT
    case RECEIVED
    case READ
}

class MessageModel {
    var message: String?
    var messageType: MessageType?
    var messageStatus: MessageStatus?
    var isSender: Bool?
    var time: Date?
    
    init(message: String, messageType: MessageType, messageStatus: MessageStatus? = nil, isSender: Bool, time: Date) {
        self.message = message
        self.messageType = messageType
        self.messageStatus = messageStatus
        self.isSender = isSender
        self.time = time
    }
}
