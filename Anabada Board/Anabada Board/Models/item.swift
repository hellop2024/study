//
//  Item.swift
//  Anabada Board
//
//  Created by YS P on 5/16/24.
//

import UIKit 

// (커스텀) 델리게이트 패턴 구현을 위한 프로토콜 선언
protocol ItemDelegate: AnyObject {
    func addNewItem(_ item: Item)
    func update(index: Int, _ item: Item)
}

struct Item {
        
    lazy var itemImage: [UIImage]? = {
        
        var images: [UIImage] = []
        if let itemTextTitle = itemTextTitle {
                // Asset 카탈로그에서 itemTextTitle로 시작하는 모든 이미지 세트를 찾아 images 배열에 추가
                for i in 1...9 {
                    let imageName = "\(itemTextTitle)-\(i)"
                    if let image = UIImage(named: imageName) {
                        images.append(image)
                    }
                }
            }
            // images 배열이 비어있지 않으면 반환, 그렇지 않으면 기본 시스템 이미지 반환
            return images.isEmpty ? [UIImage(systemName: "photo.fill")].compactMap { $0 } : images
        }()

    
    // 아이템의 (절대적) 순서를 위한 타입 저장 속성
    static var itemNumbers: Int = 0
    
    let itemId: Int //최신순 정렬
    var itemTextTitle: String?
    var itemTextContents: String?
    var itemPrice: Int?
    var itemHeart: Bool
    
    //생성자 구현
    init(itemTextTitle: String?, itemTextContents: String?, itemPrice: Int?, itemHeart: Bool = false) {
        
        //0일때는 0, 0이 아닐때는 타입저장속성의 절대적값으로 셋팅(자동순번)
        self.itemId = Item.itemNumbers
        
        //나머지 저장속성은 외부에서 셋팅
        self.itemTextTitle = itemTextTitle
        self.itemTextContents = itemTextContents
        self.itemPrice = itemPrice
        self.itemHeart = itemHeart
        
        //아이템을 생성한다면, 항상 타입 저장속성의 정수값 + 1
        Item.itemNumbers += 1
    }
}
