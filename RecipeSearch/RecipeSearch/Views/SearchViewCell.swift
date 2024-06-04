//
//  RecipeSearchTableViewCell.swift
//  RecipeSearch
//
//  Created by YS P on 5/26/24.
//

import UIKit

class SearchViewCell: UICollectionViewCell {
    
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    // URL ===> 이미지를 셋팅하는 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else {
            self.imageView.image = UIImage(systemName: "photo") // URL이 없을 경우 기본 이미지 설정
            return }
        
        DispatchQueue.global().async {
        
            guard let data = try? Data(contentsOf: url) else {      DispatchQueue.main.async {
                self.imageView.image = UIImage(systemName: "photo") // 이미지 로딩 실패 시 기본 이미지 설정
            }
                return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data) ?? UIImage(systemName: "photo") // 이미지 데이터가 유효하지 않을 경우 기본 이미지 설정
            }
        }
    }

    //MARK: - UI구현
    // 이미지 뷰를 추가합니다.
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 20
            return imageView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}
