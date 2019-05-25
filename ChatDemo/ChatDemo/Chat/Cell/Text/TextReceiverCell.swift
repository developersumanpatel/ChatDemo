//
//  TextMessageCell.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import UIKit

class TextReceiverCell: UITableViewCell {

    @IBOutlet weak var containterView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
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
    }
}
