//
//  ChatPresenter.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import Foundation

class ChatPresenter {
    var messages:[MessageModel] = []
    
    init() {
        
    }
    
    func prepareMessage(withText text: String) {
        var newMessageStatus = MessageStatus.SENDING
        
        if let lastMessageStatus = messages.last?.messageStatus {
            switch lastMessageStatus {
            case .SENDING:
                newMessageStatus = .SENT
            case .SENT:
                newMessageStatus = .DELIVERED
            case .DELIVERED:
                newMessageStatus = .READ
            case .READ:
                newMessageStatus = .SENT
            }
        }
        
        let newMessage = MessageModel(message: text, messageType: .TEXT, messageStatus: newMessageStatus, isSender: !(messages.last?.isSender ?? false), time: Date())
        messages.append(newMessage)
    }
}
