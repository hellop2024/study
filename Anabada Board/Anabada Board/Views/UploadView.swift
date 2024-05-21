//
//  UploadView.swift
//  Anabada Board
//
//  Created by YS P on 5/18/24.
//

import UIKit

class UploadView: UIView {
    // 이미지 뷰 배열과 선택된 이미지 카운트를 위한 변수 추가
    var selectedImages: [UIImage?] = Array(repeating: nil, count: 5){
        didSet {
            updateImageViews()
        }
    }
    
    // 이미지 뷰를 업데이트할 때마다 이 함수를 호출합니다.
    private func updateImageViews() {
        for (index, image) in selectedImages.enumerated() {
            let imageView = imageViews[index]
            imageView.image = image ?? UIImage.plusViewFinderSymbol // 선택된 이미지 또는 플레이스홀더를 표시합니다.
        }
    }
    
    var selectedImageCount: Int = 0 {
        didSet {
            // 선택된 이미지 카운트가 변경될 때마다 레이블 업데이트
            imageCountLabel.text = "\(selectedImageCount)/5"
        }
    }
    
    // 이미지 카운트를 표시할 레이블 추가
    let imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5" // 초기값 설정
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // **추가** - 이미지 뷰 배열을 위한 이미지 뷰 추가
    var imageViews: [UIImageView] = {
        var imageViews: [UIImageView] = []
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.backgroundColor = .clear
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage.plusViewFinderSymbol
            imageView.contentMode = .scaleAspectFill
            imageViews.append(imageView)
        }
        return imageViews
    }()
    
    //MARK: - UI구현
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage.cameraSymbol // 카메라 심볼 이미지 설정
        imageView.contentMode = .center // 이미지가 뷰의 중앙에 위치하도록 설정
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 정렬을 깔끔하게 하기 위한 컨테이너뷰
    lazy var imageContainView: UIView = {
        let view = UIView()
        view.addSubview(mainImageView)
        // 먼저 imageViews 배열의 각 UIImageView를 imageContainView에 추가합니다.
        imageViews.forEach { imageView in
            view.addSubview(imageView)
        }
        view.addSubview(imageCountLabel) //  이미지 카운트 레이블을 이미지 컨테이너 뷰에 추
        //view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemTextTitleField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: tf.font?.pointSize ?? 20)
        tf.placeholder = "타이틀을 입력하세요."
        return tf
    }()
    
    let itemTextContentsField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: tf.font?.pointSize ?? 20)
        tf.placeholder = "설명을 입력하세요."
        return tf
    }()
    
    let itemPriceField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.boldSystemFont(ofSize: tf.font?.pointSize ?? 20)
        tf.placeholder = "가격을 입력하세요."
        return tf
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemMint
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size.height = 40
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [imageContainView, itemTextTitleField, itemTextContentsField, itemPriceField, saveButton])
        stview.spacing = 10
        stview.axis = .vertical
        stview.distribution = .fill
        stview.alignment = .fill
        stview.translatesAutoresizingMaskIntoConstraints = false
        return stview
    }()
    
    // 애니메이션을 위한 속성 선언
    var stackViewTopConstraint: NSLayoutConstraint!
    
    //MARK: - 생성자 셋팅
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        updateImageViews() // 이미지 뷰를 초기에 업데이트하기 위해 이 줄을 추가합니다.
        setupStackView()
        setupNotification()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        self.addSubview(stackView)
    }
    
    //MARK: - 노티피케이션 셋팅
    
    func setupNotification() {
        // 노티피케이션의 등록 ⭐️
        // (OS차원에서 어떤 노티피케이션이 발생하는지 이미 정해져 있음)
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpAction), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - 오토레이아웃 셋팅
    
    // 오토레이아웃 업데이트
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
    
    func setConstraints() {
        
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: 50),
            mainImageView.widthAnchor.constraint(equalToConstant: 50),
            mainImageView.centerYAnchor.constraint(equalTo: imageContainView.centerYAnchor)
        ])
        
        //selectedImages 배열의 이미지를 이미지 뷰에 할당
        for (index, imageView) in imageViews.enumerated() {
            if let image = selectedImages[index] {
                imageView.image = image
            }
        }
        
        //mainImageView 오른쪽에 이미지 뷰 배열의 제약 조건 추가
        var previousImageView: UIImageView? = mainImageView
        for imageView in imageViews {
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: mainImageView.heightAnchor),
                imageView.widthAnchor.constraint(equalTo: mainImageView.widthAnchor),
                imageView.leadingAnchor.constraint(equalTo: previousImageView?.trailingAnchor ?? self.leadingAnchor, constant: 8),
                imageView.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor)
            ])
            previousImageView = imageView
        }
        
        // imageCountLabel의 오토레이아웃 설정
        NSLayoutConstraint.activate([
            imageCountLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -20),
            imageCountLabel.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor)
        ])
        
        // imageContainView의 높이 조정
        NSLayoutConstraint.activate([
            imageContainView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            stackViewTopConstraint,
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    //MARK: - 키보드가 나타날때와 내려갈때의 애니메이션 셋팅
    
    @objc func moveUpAction() {
        stackViewTopConstraint.constant = -20
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @objc func moveDownAction() {
        stackViewTopConstraint.constant = 10
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    //MARK: - 소멸자 구현
    
    deinit {
        // 노티피케이션의 등록 해제 (해제안하면 계속 등록될 수 있음) ⭐️
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - 텍스트필드 델리게이트 구현

extension UploadView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 나머지 텍스트필드는 관계없이 설정 가능
        return true
    }
}

// 심볼을 추가하기 위한 UIImage extension
extension UIImage {
    static let cameraSymbol = UIImage(systemName: "camera.fill")
    static let plusViewFinderSymbol = UIImage(systemName: "plus.viewfinder")
}
