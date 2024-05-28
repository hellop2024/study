//
//  SearchResultViewController.swift
//  RecipeSearch
//
//  Created by YS P on 5/27/24.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    // 컬렉션뷰 (테이블뷰와 유사)
    var collectionView: UICollectionView!
    
    // 컬렉션뷰의 레이아웃을 담당하는 객체
    let flowLayout = UICollectionViewFlowLayout()
    
    // 네트워크 매니저 (싱글톤)
    let networkManager = NetworkManager.shared
    
    // (음악 데이터를 다루기 위함) 빈배열로 시작
    var recipeArrays: [Recipe] = []
    
    // (서치바에서) 검색을 위한 단어를 담는 변수 (전화면에서 전달받음)
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    func setupCollectionView() {
        // 컬렉션뷰 초기화
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: Cell.recipeCollectionViewCellIdentifier)
        
        view.addSubview(collectionView) // 뷰에 컬렉션뷰 추가
        
        // 컬렉션뷰의 스크롤 방향 설정
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
    }
    
    // 데이터 셋업
    func setupDatas() {
        print(#function)
        // 옵셔널 바인딩
        guard let term = searchTerm else { return }
        print("네트워킹 시작 단어 \(term)")
        
        // (네트워킹 시작전에) 다시 빈배열로 만들기
        self.recipeArrays = []
        
        // 네트워킹 시작 (찾고자하는 단어를 가지고)
        networkManager.fetchRecipe(searchTerm: term) { result in
            switch result {
            case .success(let recipeDatas):
                // 결과를 배열에 담고
                self.recipeArrays = recipeDatas
                // 컬렉션뷰를 리로드 (메인쓰레드에서)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.recipeCollectionViewCellIdentifier, for: indexPath) as! RecipeCollectionViewCell
        cell.imageUrl = recipeArrays[indexPath.item].imageUrl
        
        return cell
    }
    
}

