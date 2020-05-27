//
//  ViewController.swift
//  Consumer
//
//  Created by Yort Sros on 5/27/20.
//  Copyright © 2020 Kim & Lim Soft Co. ltd. All rights reserved.
//

import UIKit
import SecureKeyboard

class ViewController: UIViewController, KeyboardDelegate {

    var keyboard: Keyboard?
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboard = Keyboard()
        keyboard?.delegate = self
        txtName.inputView = keyboard
    }
    
    func keyWasTapped(action: KeyAction, character: String) {
        keyboard?.textFieldAction(action: action, textField: txtName, character: character)
    }
    
}

