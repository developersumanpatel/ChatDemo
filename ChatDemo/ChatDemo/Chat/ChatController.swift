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
    
    lazy var presenter = ChatPresenter(delegate: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableView.estimatedRowHeight = 75.0
        tableView.tableFooterView = UIView()
        tableView.register(cellType: TextReceiverCell.self)
        tableView.register(cellType: TextSenderCell.self)
        tableView.register(cellType: ImageReceiverCell.self)
        tableView.register(cellType: ImageSenderCell.self)
        tableView.keyboardDismissMode = .onDrag
        
        messageTextView.layer.cornerRadius = 18.0
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
        showAttachmentActionSheet()
    }
    
    @IBAction func sendClicked(_ sender: UIButton) {
        if let messageText = messageTextView.text, messageText.trim().count > 0 {
            let textMessage = MessageModel(message: messageText.trim(), messageType: .TEXT)
            presenter.prepareMessage(textMessage)
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
        if let messagwType = message.messageType {
            switch messagwType {
            case .TEXT:
                if let sender = message.isSender, sender == false {
                    let cell = tableView.dequeueReusableCell(with: TextReceiverCell.self, for: indexPath)
                    cell.configureCell(message: message)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(with: TextSenderCell.self, for: indexPath)
                    cell.configureCell(message: message)
                    return cell
                }
            case .IMAGE:
                if let sender = message.isSender, sender == false {
                    let cell = tableView.dequeueReusableCell(with: ImageReceiverCell.self, for: indexPath)
                    cell.configureCell(message: message)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(with: ImageSenderCell.self, for: indexPath)
                    cell.configureCell(message: message)
                    return cell
                }
            default:
                return UITableViewCell()
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

extension ChatController: ChatDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
//            myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func askForPermission(_ permission: String) {
        // show alert
    }
    
}

extension ChatController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // IMAGE
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageMessage = MessageModel(image: image, messageType: .IMAGE)
            presenter.prepareMessage(imageMessage)
            messageTextView.text = ""
            tableView.reloadData()
            scrollToLatestMessage()
            sendButtonEnable(enable: false)
        } else {
            debugPrint("Something went wrong in image")
        }
        // VIDEO
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? NSURL{
            debugPrint("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            debugPrint("File size before compression: \(Double(data.length / 1048576)) mb")
        }
        else{
            debugPrint("Something went wrong in  video")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatController {
    func showAttachmentActionSheet() {
        let actionSheet = UIAlertController(title: AccessPermission.heading, message: AccessPermission.description, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: AccessPermission.camera, style: .default, handler: { (action) -> Void in
            self.presenter.authorisationStatus(attachmentTypeEnum: .camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: AccessPermission.photoLibrary, style: .default, handler: { (action) -> Void in
            self.presenter.authorisationStatus(attachmentTypeEnum: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: General.cancel, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}

