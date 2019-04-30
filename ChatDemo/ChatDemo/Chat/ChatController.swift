//
//  ViewController.swift
//  ChatDemo
//
//  Created by Suman on 26/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import UIKit

class ChatController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var presenter = ChatPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = 75.0
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TextReceiverCell", bundle: nil), forCellReuseIdentifier: "TextReceiverCell")
        tableView.register(UINib(nibName: "TextSenderCell", bundle: nil), forCellReuseIdentifier: "TextSenderCell")
        tableView.keyboardDismissMode = .onDrag
        
        messageTextView.layer.cornerRadius = 17.0
        messageTextView.clipsToBounds = true
        
        sendButtonEnable(enable: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotification()
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomViewHeightConstraint.constant = keyboardSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomViewHeightConstraint.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollToLatestMessage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let indexPath = IndexPath(row: self.presenter.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        })
    }
    
    @IBAction func plusClicked(_ sender: UIButton) {
        // TODO: Capture photo
    }
    
    @IBAction func sendClicked(_ sender: UIButton) {
        if let messageText = messageTextView.text, messageText.trim().count > 0 {
            presenter.prepareMessage(withText: messageText.trim())
            messageTextView.text = ""
            tableView.reloadData()
            scrollToLatestMessage()
            sendButtonEnable(enable: false)
        }
    }
    
    func sendButtonEnable(enable: Bool) {
        sendButton.isEnabled = enable
    }
}

extension ChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = presenter.messages[indexPath.row]
        if message.messageType == .TEXT {
            if let sender = message.isSender, sender == false {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TextReceiverCell") as? TextReceiverCell {
                    cell.configureCell(message: message)
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "TextSenderCell") as? TextSenderCell {
                    cell.configureCell(message: message)
                    return cell
                }
            }
        }
    
        return UITableViewCell()
    }
}

extension ChatController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let length = textView.text.count + (text.count - range.length)
        sendButtonEnable(enable: length > 0)
        return true
    }
}
