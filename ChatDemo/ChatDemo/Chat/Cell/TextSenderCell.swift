//
//  TextReceiverViewCell.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import UIKit

class TextSenderCell: UITableViewCell {

    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        containterView.layer.cornerRadius = 8
        containterView.clipsToBounds = true
    }
    
    func configureCell(message: MessageModel) {
        timeLabel.text = message.time?.toTimeString()
        messageLabel.text = message.message ?? ""
        if let status = message.messageStatus {
            var statusImageName = "clock"
            switch status {
            case .SENT:
                statusImageName = "single-tick"
            case .RECEIVED:
                statusImageName = "double-tick"
            case .READ:
                statusImageName = "double-blue-tick"
            default:
                statusImageName = "clock"
            }
            
            statusImage.image = UIImage(named: statusImageName)
            statusImage.isHidden = false
        } else {
            statusImage.isHidden = true
        }
    }
}
