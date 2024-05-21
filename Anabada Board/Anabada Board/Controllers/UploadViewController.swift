//
//  UploadViewController.swift
//  Anabada Board
//
//  Created by YS P on 5/18/24.
//

import UIKit
import PhotosUI

class UploadViewController: UIViewController {

    // MVC패턴을 위한 따로만든 뷰
    private let uploadView = UploadView()
    
    // 전화면에서 item데이터를 전달 받기 위한 변수
    var item: Item?
    
    // 대리자설정을 위한 변수(델리게이트)
    //weak var delegate: ItemDelegate?
    
    // MVC패턴을 위해서, view교체
    override func loadView() {
        view = uploadView
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar() // 네비게이션바 설정 함수 호출
        setupButtonAction()
        setupTapGestures()
    }
    
    func setupNaviBar() {
        title = "새로운 게시물"
        
        // 네비게이션바 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // 뷰에 있는 버튼의 타겟 설정
    func setupButtonAction() {
        uploadView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

    }
    
    //MARK: - 이미지뷰가 눌렸을때의 동작 설정
    
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        uploadView.mainImageView.addGestureRecognizer(tapGesture)
        uploadView.mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        print("이미지뷰 터치")
        setupImagePicker()
    }
    
    func setupImagePicker() {
        // 기본설정 셋팅
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 0
//        configuration.filter = .any(of: [.images, .videos])
        
        // 기본설정 셋팅
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 5 // 최대 5개의 이미지 선택 가능
        configuration.filter = .images // 오직 이미지만 선택 가능
            
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK: - SAVE버튼이 눌렸을때의 동작
    
    @objc func saveButtonTapped() {
        print("저장 버튼 눌림")
        
        // [1] 새로운 아이템을 추가하는 화면
            // 입력이 안되어 있다면.. (일반적으로) 빈문자열로 저장
            let itemTextTitle = uploadView.itemTextTitleField.text ?? ""
            let itemTextContents =  uploadView.itemTextContentsField.text ?? ""
            let itemPrice = Int(uploadView.itemPriceField.text ?? "") ?? 0
         
            // 새로운 아이템 (구조체) 생성
            
            var newItem = Item(itemTextTitle: itemTextTitle, itemTextContents: itemTextContents, itemPrice: itemPrice, itemHeart: false)
            
     
        // 새로운 아이템에 이미지 배열 추가
          newItem.itemImage = uploadView.selectedImages.compactMap { $0 }
            
            // 1) 델리게이트 방식이 아닌 구현⭐️
            let index = navigationController!.viewControllers.count - 2
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            // 전 화면의 모델에 접근해서 아이템을 추가
            vc.itemListManager.makeNewItem(newItem)
            
            
            // 2) 델리게이트 방식으로 구현⭐️
            //delegate?.addItemItem(newItem)
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("디테일 뷰컨트롤러 해제")
    }
}

//MARK: - 피커뷰 델리게이트 설정

extension UploadViewController: PHPickerViewControllerDelegate {
    
    // picker 함수에서 여러 이미지를 처리
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        // 선택된 이미지들을 순회하며 로드
        for (index, result) in results.enumerated() {
            if index >= 5 { break } // 최대 5개까지만 처리
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    // 각 이미지 뷰에 선택된 이미지 할당
                    self.uploadView.selectedImages[index] = image as? UIImage
                    self.uploadView.selectedImageCount += 1 // 선택된 이미지 카운트 증가
                }
            }
        }
    }

}
