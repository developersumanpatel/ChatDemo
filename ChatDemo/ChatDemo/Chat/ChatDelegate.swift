//
//  ChatDelegate.swift
//  ChatDemo
//
//  Created by Suman on 25/05/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import Foundation
protocol ChatDelegate {
    func openCamera()
    func openPhotoLibrary()
    func askForPermission(_ permission: String)
}
