//
//  Recipe.swift
//  RecipeSearch
//
//  Created by YS P on 5/24/24.
//

import Foundation

//MARK: - 데이터 모델
// 최상위 레벨의 JSON 응답을 나타내는 구조체
struct CookRecipeResponse: Codable {
    let COOKRCP01: RecipeData
}

// "RecipeData" 키에 해당하는 데이터를 나타내는 구조체
struct RecipeData: Codable {
    let totalCount: String?
    let row: [Recipe]
    let RESULT: Result
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case row
        case RESULT
    }
}

// "row" 배열 내 각 레시피 항목을 나타내는 구조체
struct Recipe: Codable {
    let RCP_PARTS_DTLS, RCP_WAY2, MANUAL_IMG20, MANUAL20: String?
    let RCP_SEQ, INFO_NA, INFO_WGT, INFO_PRO: String?
    let MANUAL_IMG13, MANUAL_IMG14, MANUAL_IMG15, MANUAL_IMG16: String?
    let MANUAL_IMG10, MANUAL_IMG11, MANUAL_IMG12, MANUAL_IMG17: String?
    let MANUAL_IMG18, MANUAL_IMG19, INFO_FAT, HASH_TAG: String?
    let MANUAL_IMG02, MANUAL_IMG03, RCP_PAT2, MANUAL_IMG04: String?
    let MANUAL_IMG05, MANUAL_IMG01, MANUAL01: String?
    let MANUAL_IMG06, MANUAL_IMG07, MANUAL_IMG08, MANUAL_IMG09: String?
    let MANUAL08, MANUAL09, MANUAL06, MANUAL07: String?
    let MANUAL04, MANUAL05, MANUAL02, MANUAL03: String?
    let ATT_FILE_NO_MK, MANUAL11, MANUAL12, MANUAL10: String?
    let INFO_CAR, MANUAL19, RCP_NA_TIP, INFO_ENG: String?
    let MANUAL17, MANUAL18, RCP_NM, MANUAL15: String?
    let MANUAL16, MANUAL13, MANUAL14: String?
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case RCP_PARTS_DTLS, RCP_WAY2, MANUAL_IMG20, MANUAL20
        case RCP_SEQ, INFO_NA, INFO_WGT, INFO_PRO
        case MANUAL_IMG13, MANUAL_IMG14, MANUAL_IMG15, MANUAL_IMG16
        case MANUAL_IMG10, MANUAL_IMG11, MANUAL_IMG12, MANUAL_IMG17
        case MANUAL_IMG18, MANUAL_IMG19, INFO_FAT, HASH_TAG
        case MANUAL_IMG02, MANUAL_IMG03, RCP_PAT2, MANUAL_IMG04
        case MANUAL_IMG05, MANUAL_IMG01, MANUAL01
        case MANUAL_IMG06, MANUAL_IMG07, MANUAL_IMG08, MANUAL_IMG09
        case MANUAL08, MANUAL09, MANUAL06, MANUAL07
        case MANUAL04, MANUAL05, MANUAL02, MANUAL03
        case ATT_FILE_NO_MK, MANUAL11, MANUAL12, MANUAL10
        case INFO_CAR, MANUAL19, RCP_NA_TIP, INFO_ENG
        case MANUAL17, MANUAL18, RCP_NM, MANUAL15
        case MANUAL16, MANUAL13, MANUAL14
        case imageUrl = "ATT_FILE_NO_MAIN"
    }

}

// "RESULT" 키에 해당하는 데이터를 나타내는 구조체
struct Result: Codable {
    let MSG, CODE: String
}

