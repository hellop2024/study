//
//  Constants.swift
//  RecipeSearch
//
//  Created by YS P on 5/24/24.
//

import UIKit

//MARK: - Name Space 만들기

// 데이터 영역에 저장 (열거형, 구조체 다 가능 / 전역 변수로도 선언 가능)
// 사용하게될 API 문자열 묶음
public enum RecipeApi {
    static let requestUrl = "http://openapi.foodsafetykorea.go.kr/api/2702856d58254bc6affa/COOKRCP01/json/1/100/"
    static let nameParam = "RCP_NM="
}


// 사용하게될 Cell 문자열 묶음
public struct Cell {
    static let recipeCellIdentifier = "RecipeCell"
    static let recipeCollectionViewCellIdentifier = "RecipeCollectionViewCell"
    private init() {}
}



// 컬렉션뷰 구성을 위한 설정
public struct CVCell {
    static let spacingWitdh: CGFloat = 1
    static let cellColumns: CGFloat = 3
    private init() {}
}


//let REQUEST_URL = "http://openapi.foodsafetykorea.go.kr/api/2702856d58254bc6affa/COOKRCP01/json/1/55"

