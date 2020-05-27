//
//  Constants.swift
//  SecureKeybard
//
//  Created by Yort Sros on 5/25/20.
//  Copyright © 2020 Kim & Lim Soft Co. ltd. All rights reserved.
//

import UIKit

enum Constants{
    
    static let keyNormalColour: UIColor = .white
    static let keyPressedColour: UIColor = .lightText
    static let specialKeyNormalColour: UIColor = .lightGray

    static let letterKeys = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g","h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]
    
    static let numberKeys = [
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",],
        ["-", "/", ":", ";", "(", ")" ,",", "$", "&", "@", "\""],
        [".", ",", "?", "!", "\'"]
    ]
    
    static let symbolKeys = [
        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "·"],
        [".", ",", "?", "!", "\'"]
    ]
    
    static let controlKeys = [
        ["#+=", "⇧", "⌫"],
        ["123", "space", "⏎"],
        ["abc", "space", "⏎"]
    ]
}
