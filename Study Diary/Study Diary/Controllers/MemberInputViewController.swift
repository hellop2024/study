//
//  MemberInputViewController.swift
//  Study Diary
//
//  Created by YS P on 5/7/24.
//

import UIKit
import PhotosUI

class MemberInputViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var memberNameTextField: UITextField!
    
    @IBOutlet weak var memberDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = ""
        
        setupTapGestures()
        
//        let member = Member(memberImage: UIImage(named: "spiderman2.png"), memberName: "스파이더맨2", memberDescription: "스파이더맨 시즌2")
//        memberDataManager.updateMemberData(member)

        
    }
    
    @IBAction func addMemberButtonTapped(_ sender: UIButton) {
        
        let newMember = Member(
            memberImage: UIImage(named: "\(mainImageView.image?.description)"), memberName: "\(memberNameTextField.text)", memberDescription: "\(memberDescriptionTextField.text)"
        )
        memberDataManager.updateMemberData(newMember)
        
        mainLabel.text = "추가되었습니다."
        
        
    }
    
    
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        mainImageView.addGestureRecognizer(tapGesture)
        mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        print("이미지뷰 터치")
        setupImagePicker()
    }
    
    func setupImagePicker() {
        // 기본설정 셋팅
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
    
    
}

extension MemberInputViewController: PHPickerViewControllerDelegate {
    
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else {
            print("이미지를 불러올 수 없습니다.")
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
            DispatchQueue.main.async {
                if let image = image as? UIImage {
                    // 이미지뷰에 표시
                    self.mainImageView.image = image
                } else {
                    print("이미지를 불러오는 데 실패했습니다: \(String(describing: error))")
                }
            }
        }
    }
}





