//
//  KeyboardDelegate.swift
//  SecureKeyboard
//
//  Created by Yort Sros on 5/27/20.
//  Copyright © 2020 Kim & Lim Soft Co. ltd. All rights reserved.
//

import UIKit

@objc public protocol KeyboardDelegate: class {
    @objc func keyWasTapped(action: KeyAction, character: String)
}
