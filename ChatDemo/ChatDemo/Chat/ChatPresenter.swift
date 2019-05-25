//
//  ChatPresenter.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import Foundation
import AVKit
import Photos

class ChatPresenter {
    var messages:[MessageModel] = []
    var delegate: ChatDelegate?
    
    init(delegate: ChatDelegate) {
        self.delegate = delegate
    }
    
    func prepareMessage(_ data: MessageModel) {
        var newMessageStatus = MessageStatus.SENDING
        var newMessageType = MessageType.TEXT
        var isNewMessageSender = true
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
        
        if let lastMessageType = messages.last?.messageType {
            switch lastMessageType {
            case .TEXT:
                newMessageType = .IMAGE
            case .IMAGE:
                newMessageType = .TEXT // .AUDIO
            case .AUDIO:
                newMessageType = .VIDEO
            case .VIDEO:
                newMessageType = .TEXT
            }
            
            if let lastMessage = messages.filter({$0.messageType == newMessageType}).last {
                isNewMessageSender = !(lastMessage.isSender ?? false)
            }
        }
        
        data.messageStatus = newMessageStatus
        data.isSender = isNewMessageSender
        data.time = Date()
        messages.append(data)
    }
}

extension ChatPresenter {
    enum AttachmentType: String {
        case camera, photoLibrary
    }
    
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType) {
        if attachmentTypeEnum ==  .camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status{
            case .authorized:
                delegate?.openCamera()

            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.delegate?.openCamera()
                    }
                }
            case .denied, .restricted:
                delegate?.askForPermission(AccessPermission.cameraAccessAlertMessage)
                return
                
            default:
                break
            }
        }else if attachmentTypeEnum == AttachmentType.photoLibrary {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary {
                    delegate?.openPhotoLibrary()
                }
            case .denied, .restricted:
                delegate?.askForPermission(AccessPermission.photoLibraryAlertMessage)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized {
                        self.delegate?.openPhotoLibrary()
                    }
                })
            default:
                break
            }
        }
    }
}
