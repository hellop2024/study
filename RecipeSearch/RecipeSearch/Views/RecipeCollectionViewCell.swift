//
//  RecipeCollectionViewCell.swift
//  RecipeSearch
//
//  Created by YS P on 5/27/24.
//

import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    
    // mainImageView를 lazy var로 선언하여 초기화
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        
        // URLSession을 사용하여 이미지 데이터를 비동기적으로 로드
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // 에러 처리
                   if let error = error {
                       print("Error loading image: \(error.localizedDescription)")
                       return
                   }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // 현재 셀의 imageUrl이 로드된 이미지의 URL과 일치하는지 확인
                    if self?.imageUrl == urlString {
                        self?.mainImageView.image = image
                    }
                }
            }
        }
        task.resume()
    }

    override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func setupViews() {
           addSubview(mainImageView)
           mainImageView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               mainImageView.topAnchor.constraint(equalTo: self.topAnchor),
               mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
               mainImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
               mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
           ])
       }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행 ⭐️
        self.mainImageView.image = nil
    }
}

