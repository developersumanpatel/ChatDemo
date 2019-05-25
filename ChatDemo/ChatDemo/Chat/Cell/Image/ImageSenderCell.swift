//
//  ImageSenderCell.swift
//  ChatDemo
//
//  Created by Suman on 25/05/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import UIKit

class ImageSenderCell: UITableViewCell {
    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    
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
        messageImageView.image = message.image
        if let status = message.messageStatus {
            var statusImageName = "clock"
            switch status {
            case .SENT:
                statusImageName = "single-tick-white"
            case .DELIVERED:
                statusImageName = "double-tick-white"
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
