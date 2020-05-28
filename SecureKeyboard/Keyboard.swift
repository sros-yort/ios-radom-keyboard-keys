//
//  Keyboard.swift
//  SecureKeybard
//
//  Created by Yort Sros on 5/25/20.
//  Copyright © 2020 Kim & Lim Soft Co. ltd. All rights reserved.
//

import UIKit

@objc public class Keyboard: UIView {
    public weak var delegate: KeyboardDelegate?
    var keyboardView: UIView!
    var keys: [UIButton] = []
    var paddingViews: [UIButton] = []
    var textField: UITextField?
    var backspaceTimer: Timer?
    
    enum KeyboardState{
        case letters
        case numbers
        case symbols
    }
    
    enum ShiftButtonState {
        case normal
        case shift
        case caps
    }
    
    var keyboardState: KeyboardState = .letters
    var shiftButtonState:ShiftButtonState = .normal
    
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 350, height: 225))
        initializeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    // orientation handling
    public override func layoutSubviews() {
        super.layoutSubviews()
        loadKeys()
    }
    
    func initializeSubviews() {
        let bundlePath = Bundle.main.path(forResource: "ResourceBundle", ofType: "bundle")!
        let bundle = Bundle(path: bundlePath)!
        let keyboardNib = UINib(nibName: "Keyboard", bundle: bundle)
        keyboardView = keyboardNib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.addSubview(keyboardView)
        loadKeys()
    }
    
    func loadKeys(){
        keys.forEach{$0.removeFromSuperview()}
        paddingViews.forEach{$0.removeFromSuperview()}
        let buttonWidth = (UIScreen.main.bounds.width - 6) / CGFloat(Constants.letterKeys[0].count)
        var keyboard: [[String]]
        
        switch keyboardState {
        case .letters:
            keyboard = shuffleKeys(Constants.letterKeys)
            keyboard[2].insert(Constants.controlKeys[0][1], at: 0) // add shift key
            keyboard[2].insert(Constants.controlKeys[0][2], at: keyboard[2].count) // add delete key
            keyboard.insert(Constants.controlKeys[1], at: 3) // add control keys of 123
            addPadding(to: stackView2, width: buttonWidth/2, key: "a")
        case .numbers:
            var noKeys = Constants.numberKeys
            noKeys.remove(at: 0)
            noKeys = shuffleKeys(noKeys)
            noKeys.insert(Constants.numberKeys[0].shuffled(), at: 0)
            keyboard = noKeys
            keyboard[2].insert(Constants.controlKeys[0][0], at: 0) // add #+= key
            keyboard[2].insert(Constants.controlKeys[0][2], at: keyboard[2].count) // add delete key
            keyboard.insert(Constants.controlKeys[2], at: 3) // add control keys of abc
        case .symbols:
            keyboard = shuffleKeys(Constants.symbolKeys)
            keyboard[2].insert(Constants.controlKeys[1][0], at: 0) // add 123 key
            keyboard[2].insert(Constants.controlKeys[0][2], at: keyboard[2].count) // add delete key
            keyboard.insert(Constants.controlKeys[2], at: 3) // add control keys of abc
        }
        
        let numRows = keyboard.count
        for row in 0...numRows - 1{
            for col in 0...keyboard[row].count - 1{
                let key = keyboard[row][col]
                let capsKey = key.capitalized
                let keyToDisplay = shiftButtonState == .normal ? key : capsKey
                let button = UIButton(type: .custom)
                button.backgroundColor = Constants.keyNormalColour
                button.setTitle(keyToDisplay, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.layer.setValue(key, forKey: "original")
                button.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
                button.layer.setValue(false, forKey: "isSpecial")
                button.layer.borderColor = keyboardView.backgroundColor?.cgColor
                button.layer.borderWidth = 4
                button.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
                button.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
                button.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
                button.addTarget(self, action: #selector(keyMultiPress(_:event:)), for: .touchDownRepeat)
                button.layer.cornerRadius = 10;
                
                if key == "⌫" {
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(keyLongPressed(_:)))
                    button.addGestureRecognizer(longPressRecognizer)
                }
                
                keys.append(button)
                
                switch row {
                case 0: stackView1.addArrangedSubview(button)
                case 1: stackView2.addArrangedSubview(button)
                case 2: stackView3.addArrangedSubview(button)
                case 3: stackView4.addArrangedSubview(button)
                default:
                    break
                }
                
                if key == "⌫" || key == "⏎" || key == "#+=" || key == "abc" || key == "123" || key == "⇧" {
                    button.widthAnchor.constraint(equalToConstant: buttonWidth + buttonWidth/2).isActive = true
                    button.layer.setValue(true, forKey: "isSpecial")
                    button.backgroundColor = Constants.specialKeyNormalColour
                    if key == "⇧" {
                        if shiftButtonState != .normal{
                            button.backgroundColor = Constants.keyPressedColour
                        }
                    }
                } else if (keyboardState == .numbers || keyboardState == .symbols) && row == 2 {
                    button.widthAnchor.constraint(equalToConstant: buttonWidth * 1.4).isActive = true
                } else if key != "space" {
                    button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
                } else {
                    button.layer.setValue(key, forKey: "original")
                    button.setTitle(key, for: .normal)
                }
            }
        }
        
        switch keyboardState {
        case .letters:
            addPadding(to: stackView2, width: buttonWidth/2, key: "l")
        case .numbers:
            break
        case .symbols:
            break
        }
    }
    
    func addPadding(to stackView: UIStackView, width: CGFloat, key: String){
        let padding = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        padding.setTitleColor(.clear, for: .normal)
        padding.alpha = 0.02
        padding.widthAnchor.constraint(equalToConstant: width).isActive = true
        padding.layer.setValue(key, forKey: "original")
        let keyToDisplay = shiftButtonState == .normal ? key : key.capitalized
        padding.layer.setValue(keyToDisplay, forKey: "keyToDisplay")
        padding.layer.setValue(false, forKey: "isSpecial")
        padding.addTarget(self, action: #selector(keyPressedTouchUp), for: .touchUpInside)
        padding.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
        padding.addTarget(self, action: #selector(keyUntouched), for: .touchDragExit)
        
        paddingViews.append(padding)
        stackView.addArrangedSubview(padding)
    }
    
    func shuffleKeys<T>(_ arr: [[T]]) -> [[T]] {
        var iter = arr.joined().shuffled().makeIterator()
        return arr.map { $0.compactMap { _ in iter.next() }}
    }
    
    func changeKeyboardToNumberKeys(){
        keyboardState = .numbers
        shiftButtonState = .normal
        loadKeys()
    }
    
    func changeKeyboardToLetterKeys() {
        keyboardState = .letters
        loadKeys()
    }
    
    func changeKeyboardToSymbolKeys() {
        keyboardState = .symbols
        loadKeys()
    }
    
    @IBAction func keyPressedTouchUp(_ sender: UIButton) {
        guard let originalKey = sender.layer.value(forKey: "original") as? String, let keyToDisplay = sender.layer.value(forKey: "keyToDisplay") as? String else {return}
        
        guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
        sender.backgroundColor = isSpecial ? Constants.specialKeyNormalColour : Constants.keyNormalColour
        
        switch originalKey {
        case "⌫":
            if shiftButtonState == .shift {
                shiftButtonState = .normal
                loadKeys()
            }
            self.delegate?.keyWasTapped(action: KeyAction.delete, character: "⌫")
        case "space":
            self.delegate?.keyWasTapped(action: KeyAction.insert, character: " ")
        case "⏎":
            self.delegate?.keyWasTapped(action: KeyAction.return, character: "⏎")
        case "123":
            changeKeyboardToNumberKeys()
        case "abc":
            changeKeyboardToLetterKeys()
        case "#+=":
            changeKeyboardToSymbolKeys()
        case "⇧":
            shiftButtonState = shiftButtonState == .normal ? .shift : .normal
            loadKeys()
        default:
            if shiftButtonState == .shift {
                shiftButtonState = .normal
                loadKeys()
            }
            self.delegate?.keyWasTapped(action: KeyAction.insert, character: keyToDisplay)
        }
    }
    
    @objc func keyMultiPress(_ sender: UIButton, event: UIEvent){
        guard let originalKey = sender.layer.value(forKey: "original") as? String else {return}
        
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount == 2 && originalKey == "⇧") {
            shiftButtonState = .caps
            loadKeys()
        }
    }
    
    @objc func keyLongPressed(_ gesture: UIGestureRecognizer){
        if gesture.state == .began {
            backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                self.delegate?.keyWasTapped(action: KeyAction.delete, character: "⌫")
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            backspaceTimer?.invalidate()
            backspaceTimer = nil
            (gesture.view as! UIButton).backgroundColor = Constants.specialKeyNormalColour
        }
    }
    
    @objc func keyUntouched(_ sender: UIButton){
        guard let isSpecial = sender.layer.value(forKey: "isSpecial") as? Bool else {return}
        sender.backgroundColor = isSpecial ? Constants.specialKeyNormalColour : Constants.keyNormalColour
    }
    
    @objc func keyTouchDown(_ sender: UIButton){
        sender.backgroundColor = Constants.keyPressedColour
    }
    
    @objc public func textFieldOperation(action: KeyAction, character: String, textFields: [UITextField]) {
        for textField in textFields {
            if textField.isFirstResponder {
                if action == KeyAction.delete {
                    deleteText(textField: textField)
                }else if action == KeyAction.return {
                    textField.resignFirstResponder()
                } else {
                    textField.insertText(character)
                }
            }
        }
    }
    
    func deleteText(textField: UITextField){
        if var textRange = textField.selectedTextRange {
            if textRange.isEmpty && textRange.start != textField.beginningOfDocument {
                textRange = textField.textRange(from: textField.position(from: textRange.start, offset: -1)!, to: textRange.start)!
            }
            textField.replace(textRange, withText: "")
        }
    }
}
