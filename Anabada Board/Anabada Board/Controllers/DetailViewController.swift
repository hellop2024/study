//
//  DetailViewController.swift
//  Anabada Board
//
//  Created by YS P on 5/18/24.
//

import UIKit
import PhotosUI

final class DetailViewController: UIViewController {
    
    // MVC패턴을 위한 따로만든 뷰
    private let detailView = DetailView()
    
    // 전화면에서 item데이터를 전달 받기 위한 변수
    var item: Item?
    
    // 대리자설정을 위한 변수(델리게이트)
    weak var delegate: ItemDelegate?
    
    // MVC패턴을 위해서, view교체
    override func loadView() {
        view = detailView
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupButtonAction()
        setupTapGestures()
    }
    
    // 아이템을 뷰에 전달⭐️ (뷰에서 알아서 화면 셋팅)
    private func setupData() {
        detailView.item = item
    }
    
    // 뷰에 있는 버튼의 타겟 설정
    func setupButtonAction() {
        detailView.updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        detailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - 이미지뷰가 눌렸을때의 동작 설정
    
    // 제스쳐 설정 (이미지뷰가 눌리면, 실행)
    func setupTapGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        detailView.imageScrollView.addGestureRecognizer(tapGesture)
        detailView.imageScrollView.isUserInteractionEnabled = true
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
    
    //MARK: - DELETE버튼이 눌렸을 때의 동작
    
    @objc func deleteButtonTapped() {
        print("삭제 버튼 눌림")
        
        // 아이템이 있다면 (아이템을 삭제하기 위한 설정)
        if let itemId = self.item?.itemId {
            // 1) 델리게이트 방식이 아닌 구현⭐️
            let index = navigationController!.viewControllers.count - 2
            // 전 화면에 접근하기 위함
            if let vc = navigationController?.viewControllers[index] as? ViewController {
                // 전 화면의 모델에 접근해서 아이템을 삭제
                vc.itemListManager.deleteItem(itemId: itemId)
            }
            
            // 2) 델리게이트 방식으로 구현⭐️
            //delegate?.deleteItem(itemId: itemId)
        }
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UPDATE버튼이 눌렸을때의 동작
    
    @objc func updateButtonTapped() {
        print("update 버튼 눌림")
        
        // [1] 아이템이 없다면 (새로운 아이템을 추가하는 화면)
        if item == nil {
            // 입력이 안되어 있다면.. (일반적으로) 빈문자열로 저장
            let itemTextTitle = detailView.itemTextTitleField.text ?? ""
            let itemTextContents = detailView.itemTextContentsField.text ?? ""
            let itemPrice = Int(detailView.itemPriceField.text ?? "") ?? 0
            
            // 새로운 아이템 (구조체) 생성
            
            var newItem = Item(itemTextTitle: itemTextTitle, itemTextContents: itemTextContents, itemPrice: itemPrice, itemHeart: false)
            
            
            //newItem.itemImage = detailView.mainImageView.image
            //이미지 배열을 새로운 아이템에 할당
            newItem.itemImage = detailView.selectedImages
            
            
            // 1) 델리게이트 방식이 아닌 구현⭐️
            let index = navigationController!.viewControllers.count - 2
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            // 전 화면의 모델에 접근해서 아이템을 추가
            vc.itemListManager.makeNewItem(newItem)
            
            
            // 2) 델리게이트 방식으로 구현⭐️
            //delegate?.addItemItem(newItem)
            
            
            // [2] 아이템이 있다면 (아이템의 내용을 업데이트 하기 위한 설정)
        } else {
            // 이미지뷰에 있는 것을 그대로 다시 아이템에 저장
            //  item!.itemImage = detailView.mainImageView.image
            // 이미지 배열을 기존 아이템에 할당
            item!.itemImage = detailView.selectedImages
            
            let itemId = self.item?.itemId
            item!.itemTextTitle = detailView.itemTextTitleField.text ?? ""
            item!.itemPrice = Int(detailView.itemPriceField.text ?? "") ?? 0
            item!.itemTextContents = detailView.itemTextContentsField.text ?? ""
            
            // 뷰에도 바뀐 아이템을 전달 (뷰컨트롤러 ==> 뷰)
            detailView.item = item
            
            // 1) 델리게이트 방식이 아닌 구현⭐️
            let index = navigationController!.viewControllers.count - 2
            // 전 화면에 접근하기 위함
            let vc = navigationController?.viewControllers[index] as! ViewController
            // 전 화면의 모델에 접근해서 아이템을 업데이트
            vc.itemListManager.updateItemInfo(index: itemId!, item!)
            
            
            // 델리게이트 방식으로 구현⭐️
            //delegate?.update(index: itemId, item!)
        }
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("디테일 뷰컨트롤러 해제")
    }
}

//MARK: - 피커뷰 델리게이트 설정

extension DetailViewController: PHPickerViewControllerDelegate {
    
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        // 선택된 모든 이미지들을 처리
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        // 이미지 배열에 추가
                        if let image = image as? UIImage {
                            self.detailView.selectedImages.append(image)
                           // 스크롤 뷰에 이미지를 추가하는 로직을 호출
                            self.detailView.setupImagesInScrollView(images: self.detailView.selectedImages)
                        }
                    }
                }
            }
        }
    }
}



