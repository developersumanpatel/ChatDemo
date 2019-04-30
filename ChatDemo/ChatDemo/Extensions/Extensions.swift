//
//  File.swift
//  ChatDemo
//
//  Created by Suman on 27/04/19.
//  Copyright © 2019 Suman. All rights reserved.
//

import UIKit
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Date {
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let time = dateFormatter.string(from: self)
        return time
    }
}
