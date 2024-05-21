//
//  ItemListManager.swift
//  Anabada Board
//
//  Created by YS P on 5/16/24.
//

import Foundation
import UIKit

final class ItemListManager {
    
    var itemsList: [Item] = []
    
    func makeItemsListDatas() {
        itemsList = [
            // 각 아이템에 대한 이미지 배열을 생성하고 할당
            Item(itemTextTitle: "image01", itemTextContents: "1번째", itemPrice: 5000, itemHeart: false),
            Item(itemTextTitle: "image02", itemTextContents: "2번째", itemPrice: 6000, itemHeart: false),
            Item(itemTextTitle: "image03", itemTextContents: "3번째", itemPrice: 9000, itemHeart: false),
            Item(itemTextTitle: "image04", itemTextContents: "4번째", itemPrice: 2000, itemHeart: false),
            Item(itemTextTitle: "image05", itemTextContents: "5번째", itemPrice: 1000, itemHeart: false),
            Item(itemTextTitle: "image06", itemTextContents: "6번째", itemPrice: 4000, itemHeart: false),
            Item(itemTextTitle: "image07", itemTextContents: "7번째", itemPrice: 3000, itemHeart: false),
            Item(itemTextTitle: "image08", itemTextContents: "8번째", itemPrice: 8000, itemHeart: false),
            Item(itemTextTitle: "image09", itemTextContents: "9번째", itemPrice: 7000, itemHeart: false)
        ]
    }
    
    // 전체 아이템 리스트를 얻기
    func getItemsList() -> [Item] {
       return itemsList
    }
    
    
    // 새로운 아이템 만들기
    func makeNewItem(_ item: Item) {
        itemsList.append(item)
    }
    
    // 기존 아이템의 정보 업데이트
    func updateItemInfo(index: Int, _ item: Item) {
        itemsList[index] = item
    }
    
    // 기존 아이템 삭제
    func deleteItem(itemId: Int) {
        // itemsList에서 itemId와 일치하는 아이템의 인덱스를 찾습니다.
        if let index = itemsList.firstIndex(where: { $0.itemId == itemId }) {
            itemsList.remove(at: index)
        } else {
            print("삭제할 아이템이 리스트에 없습니다.")
        }
    }
    
//    // 특정 아이템 얻기 (굳이 필요 없지만, 서브스크립트 구현해보기)
//    subscript(index: Int) -> Item {
//        get {
//            return itemsList[index]
//        }
//    }
    
}


extension ItemListManager {
    // 하트 상태를 토글
    func toggleHeart(at index: Int) {
        guard index >= 0 && index < itemsList.count else { return }
        itemsList[index].itemHeart.toggle()
        }
    }


