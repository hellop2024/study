//
//  ThirdViewController.swift
//  SecondaryPassword
//
//  Created by YS P on 4/30/24.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var checkAlertText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func alertButtonTapped(_ sender: UIButton) {
        
        let alertCont = UIAlertController(title: "알림", message: "알림창입니다. 확인버튼을 눌러보세요.", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            //                print("확인버튼이 눌렀습니다.")
            self.checkAlertText.text = "확인 버튼이 눌림"
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
            print("취소버튼이 눌렸습니다.")
            
            
        }
        
        alertCont.addAction(success)
        alertCont.addAction(cancel)
        
        present(alertCont, animated: true, completion: nil)
    }
    
    
}
