# SecureKeyboard

SecureKeyboard is a swift static library for random keyboard keys.

## How Link the static library and resource bundle to the swift app

Let’s build project library first.

We need to build both SecureKeyboard and ResourceBundle.

- Select active scheme `SecureKeyboard` and taget device
- Cmd + b or click btn start to build 

- Select active scheme `ResourceBundle` and taget device
- Cmd + b or click btn start to build

Let's link static library to consumer app

- Create `lib` dir in root of `consumer app`

- In `SecureKeyboard` project select on `Products` dir -> right click on `libSecureKeyboard.a` -> `Show in Finder` and copy all files in that dir to comsumer app `lib` dir

- In consumer app right click on `lib` and click `Add File to "ConsumerApp"...` -> select all files in `lib` dir and click `add`

- In consumer app click on top of `project name` -> taget  `project name`  ->  `Build Setting``  and click on `All` and `Combined`
- Find  `Search Path` and copy value of `Library Search Path` to `Swift Compiler-Search Path` -> `Imports Path`

### Library Usage

- #### Example

        import UIKit
        import SecureKeyboard

        class ViewController: UIViewController, KeyboardDelegate {
            
            var keyboard: Keyboard?
            
            @IBOutlet weak var txtName: UITextField!
            @IBOutlet weak var txtPassword: UITextField!
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                keyboard = Keyboard()
                keyboard?.delegate = self
                txtPassword.inputView = keyboard
            }

            func keyWasTapped(action: KeyAction, character: String) {
                keyboard?.textFieldOperation(action: action, character: character, textFields: [txtPassword])
            }
        }









