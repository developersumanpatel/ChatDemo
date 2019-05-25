//
//  MessageModel.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import UIKit
enum MessageType {
    case TEXT
    case IMAGE
    case AUDIO
    case VIDEO
}

enum MessageStatus {
    case SENDING
    case SENT
    case DELIVERED
    case READ
}

class MessageModel {
    var message: String?
    var image: UIImage?
    var messageType: MessageType?
    var messageStatus: MessageStatus?
    var isSender: Bool?
    var time: Date?
    
    init(message: String? = nil, image: UIImage? = nil, messageType: MessageType) {
        self.message = message
        self.messageType = messageType
        self.image = image
    }
}
