//
//  MyTableViewCell.swift
//  Anabada Board
//
//  Created by YS P on 5/17/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    // 멤버가 변할때마다 자동으로 업데이트 되도록 구현 didSet(속성 감시자) ⭐️
    var item: Item? {
        didSet {
            guard var item = item else { return }
            //mainImageView.image = item.itemImage
            //첫 번째 이미지를 mainImageView에 할당
            mainImageView.image = item.itemImage?.first
            itemTextTitleLabel.text = item.itemTextTitle
            itemTextContentsLabel.text = item.itemTextContents
            itemPriceLabel.text = "\(item.itemPrice ?? 0)"
            
            // 하트 이미지 업데이트 로직
            updateHeartImage()
            
        }
    }
    
    // 하트 이미지를 업데이트하는 메서드
    func updateHeartImage() {
        let heartImageName = item?.itemHeart ?? false ? "heart.fill" : "heart"
        heartImageView.image = UIImage(systemName: heartImageName)
    }
    
    //MARK: - UI구현
    
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true // 사용자 입력 활성화
        return imageView
    }()
    
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let itemTextTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemTextContentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution  = .fill
        sv.alignment = .fill
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    //MARK: - 생성자 셋팅
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupStackView()
        
        // 셀 오토레이아웃 일반적으로 생성자에서 잡으면 됨 ⭐️⭐️⭐️
        setConstraints()
    }
    
    func setupStackView() {
        
        self.contentView.addSubview(mainImageView)
        self.contentView.addSubview(stackView)
        
        // heartImageView를 contentView에 추가
        self.contentView.addSubview(heartImageView)
        
        // 스택뷰 위에 뷰들 올리기
        stackView.addArrangedSubview(itemTextTitleLabel)
        stackView.addArrangedSubview(itemTextContentsLabel)
        stackView.addArrangedSubview(itemPriceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 오토레이아웃 셋팅
    // (오토레이아웃 변하지 않는 경우) 일반적으로 생성자에서 잡으면 됨 ⭐️⭐️⭐️
    //    override func updateConstraints() {
    //        setConstraints()
    //        super.updateConstraints()
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.mainImageView.clipsToBounds = true
        self.mainImageView.layer.cornerRadius = 10
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainImageView.heightAnchor.constraint(equalToConstant: 70),
            mainImageView.widthAnchor.constraint(equalToConstant: 70),
            
            // self.leadingAnchor로 잡는 것보다 self.contentView.leadingAnchor로 잡는게 더 정확함 ⭐️
            // (cell은 기본뷰로 contentView를 가지고 있기 때문)
            mainImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            mainImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemTextTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            itemTextContentsLabel.heightAnchor.constraint(equalToConstant: 20),
            itemPriceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            
            // self.trailingAnchor로 잡는 것보다 self.contentView.trailingAnchor로 잡는게 더 정확함 ⭐️
            // (cell은 기본뷰로 contentView를 가지고 있기 때문)
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.mainImageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.mainImageView.bottomAnchor)
        ])
        
        // heartImageView의 오토레이아웃 설정
        NSLayoutConstraint.activate([
            heartImageView.heightAnchor.constraint(equalToConstant: 20),
            heartImageView.widthAnchor.constraint(equalToConstant: 20),
            heartImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            heartImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}
