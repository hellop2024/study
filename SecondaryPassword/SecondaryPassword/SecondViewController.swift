//
//  SecondViewController.swift
//  SecondaryPassword
//
//  Created by YS P on 4/30/24.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var pwMessage: UILabel!
    
    @IBOutlet weak var pwHint: UILabel!
    
    @IBOutlet weak var pwNumberTextFieldView: UITextField!
    
    @IBOutlet weak var pwStringTextFieldView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pwNumberTextFieldView.delegate = self
        pwStringTextFieldView.delegate = self
        
        pwNumberTextFieldView.becomeFirstResponder()
        pwStringTextFieldView.becomeFirstResponder()
        
        pwMessage.text = "비밀번호를 눌러주세요"
        pwHint.text = "숫자4자리 + 영문자1자리"
        
        pwNumberTextFieldView.isSecureTextEntry = true
        pwStringTextFieldView.isSecureTextEntry = true
    }
    
    
    @IBAction func SecondVCLoginButtonTapped(_ sender: UIButton) {
        if pwNumberTextFieldView.text == "1111" && pwStringTextFieldView.text == "a" {
            
            guard let secondVC = storyboard?.instantiateViewController(withIdentifier: "thirdVC") as? ThirdViewController else { return }
            present(secondVC, animated: true)
            
        } else if pwNumberTextFieldView.text != "1111" {
            
            // 비밀번호가 틀렸을 경우 햅틱 피드백 제공
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            pwMessage.text = "비밀번호가 맞지 않아요"
            pwHint.text = "숫자가 맞지 않아요"
            pwHint.textColor = .red
            
        } else if pwStringTextFieldView.text != "a" {
            
            // 비밀번호가 틀렸을 경우 햅틱 피드백 제공
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
            pwMessage.text = "비밀번호가 맞지 않아요"
            pwHint.text = "영문자가 일치하지 않습니다."
            pwHint.textColor = .red
        }
    }
}

extension SecondViewController:  UITextFieldDelegate {
    
}
