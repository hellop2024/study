//
//  NetworkManager.swift
//  RecipeSearch
//
//  Created by YS P on 5/24/24.
//

import Foundation

//MARK: - 네트워크에서 발생할 수 있는 에러 정의

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}


//MARK: - Networking (서버와 통신하는) 클래스 모델

final class NetworkManager {
    
    // 여러화면에서 통신을 한다면, 일반적으로 싱글톤으로 만듦
    //shared 변수는 데이터 영역에 존재, 실제로 싱글톤 NetworkManager은 힙영역에 존재
    static let shared = NetworkManager()
    
    // 싱글톤을 사용하므로 여러객체를 추가적으로 생성하지 못하도록 설정(생성자에 private을 붙여 다른 곳에서 이 생성자 접근 불가능으로 만듦)
    private init() {}
    
    //let recipeURL = "http://openapi.foodsafetykorea.go.kr/api/2702856d58254bc6affa/COOKRCP01/json/1/55"
    
    typealias NetworkCompletion = (Swift.Result<[Recipe], NetworkError>) -> Void
    
    // 네트워킹 요청하는 함수 (레시피데이터 가져오기)⭐️⭐️⭐️⭐️⭐️
    func fetchRecipe(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(RecipeApi.requestUrl)\(RecipeApi.nameParam)\(searchTerm)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 네트워킹 요청하는 함수
    func fetchRecipeButton(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "http://openapi.foodsafetykorea.go.kr/api/2702856d58254bc6affa/COOKRCP01/json/1/100/RCP_PAT2=\(searchTerm)"
        print(urlString)
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request하는 함수 (비동기적 실행 ===> 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        //print(#function)
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let recipes = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(recipes))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // 받아본 데이터 분석하는 함수 (동기적 실행)
        private func parseJSON(_ recipeData: Data) -> [Recipe]? {
            do {
                let decodedData = try JSONDecoder().decode(CookRecipeResponse.self, from: recipeData)
                return decodedData.COOKRCP01.row
            } catch DecodingError.dataCorrupted(let context) {
                print("Data corrupted: \(context)")
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found: \(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found: \(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch: \(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            } catch {
                print("Unknown error: \(error)")
            }
            return nil
        }
}

