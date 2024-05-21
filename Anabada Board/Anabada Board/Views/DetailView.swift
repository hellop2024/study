//
//  DetailView.swift
//  Anabada Board
//
//  Created by YS P on 5/18/24.
//

import UIKit

class DetailView: UIView {
    
    //선택된 이미지들을 저장할 배열
    var selectedImages: [UIImage] = []
    
    //스크롤 뷰를 추가하여 여러 이미지를 수평으로 스크롤할 수 있게 함
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true // 페이지처럼 스크롤
        scrollView.showsHorizontalScrollIndicator = true // 수평 스크롤 바 표시
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    //뷰의 서브뷰 레이아웃을 설정할 때 호출됩니다.
    override func layoutSubviews() {
        super.layoutSubviews()
        setupScrollView()
    }
    
    // 스크롤 뷰를 설정하고 이미지를 추가하는 private 메서드
    private func setupScrollView() {
        imageContainView.addSubview(imageScrollView)
        imageScrollView.frame = imageContainView.bounds
        setupImagesInScrollView(images: self.item?.itemImage)
    }
    
    //MARK: - 아이템 저장속성 구현
    // 아이템 데이터가 바뀌면 ===> didSet(속성감시자) 실행
    // 속성감시자도 (저장 속성을 관찰하는) 어쨌든 자체는 메서드임
    var item: Item? {
        didSet {
            guard var item = item else {
                // 아이템이 없으면 (즉, 새로운 아이템를 추가할때의 상황)
                return
            }
            // 아이템이 있으면
            // 아이템의 이미지들을 selectedImages 배열에 할당
            selectedImages = item.itemImage ?? []
            
            // 스크롤 뷰에 이미지를 추가하는 로직
            setupImagesInScrollView(images: item.itemImage)
            
            itemTextTitleField.text = item.itemTextTitle
            itemTextContentsField.text = item.itemTextContents
            itemPriceField.text = "\(item.itemPrice ?? 0)"
        }
    }
    
    // 스크롤 뷰에 이미지를 설정하는 메서드
    func setupImagesInScrollView(images: [UIImage]?) {
        guard let images = images else { return }
        
        imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(images.count)
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: imageScrollView.frame.width * CGFloat(index), y: 0, width: imageScrollView.frame.width, height: imageScrollView.frame.height)
            imageScrollView.addSubview(imageView)
        }
    }
    
    //MARK: - UI구현
    
    // 정렬을 깔끔하게 하기 위한 컨테이너뷰
    lazy var imageContainView: UIView = {
        let view = UIView()
        view.addSubview(imageScrollView)
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
        return tf
    }()
    
    let updateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemMint
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size.height = 40
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemRed
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame.size.height = 40
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [imageContainView, itemTextTitleField, itemTextContentsField, itemPriceField, updateButton, deleteButton])
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
        setupStackView()
        setupNotification()
        
        // 텍스트 필드 델리게이트 설정
        itemTextTitleField.delegate = self
        itemTextContentsField.delegate = self
        itemPriceField.delegate = self
    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 텍스트 필드 델리게이트 설정
        itemTextTitleField.delegate = self
        itemTextContentsField.delegate = self
        itemPriceField.delegate = self
    }
    
    
    func setupStackView() {
        self.addSubview(stackView)
        // 스크롤 뷰를 컨테이너 뷰에 추가
        imageContainView.addSubview(imageScrollView)
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
        
        // 스크롤 뷰의 제약 조건을 설정
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: imageContainView.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: imageContainView.bottomAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: imageContainView.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: imageContainView.trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: imageContainView.heightAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            imageContainView.heightAnchor.constraint(equalToConstant: 180)
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

extension DetailView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 나머지 텍스트필드는 관계없이 설정 가능
        textField.isEnabled = true
        return true
    }
}

