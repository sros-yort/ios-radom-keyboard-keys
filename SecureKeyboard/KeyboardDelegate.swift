//
//  KeyboardDelegate.swift
//  SecureKeyboard
//
//  Created by Yort Sros on 5/27/20.
//  Copyright © 2020 Kim & Lim Soft Co. ltd. All rights reserved.
//

public protocol KeyboardDelegate: class {
    func keyWasTapped(action: KeyAction, character: String)
}
