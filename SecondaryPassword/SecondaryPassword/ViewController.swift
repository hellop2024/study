//
//  ViewController.swift
//  SecondaryPassword
//
//  Created by YS P on 4/30/24.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    
    @IBOutlet weak var checkIDandPW: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        pwTextField.delegate = self
        
        idTextField.becomeFirstResponder()
        pwTextField.becomeFirstResponder()
        
        checkIDandPW.text = ""
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if idTextField.text == "a" && pwTextField.text == "1" {
            guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? SecondViewController else { return }
            present(secondVC, animated: true, completion: nil)
        } else if idTextField.text != "a" {
            checkIDandPW.text = "존재하지 않은 ID입니다."
            checkIDandPW.textColor = .red
        } else if pwTextField.text != "1" {
            checkIDandPW.text = "패스워드가 일치하지 않습니다."
            checkIDandPW.textColor = .red
        } 
    }
}


extension ViewController: UITextFieldDelegate {
    
}
