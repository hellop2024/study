//
//  ViewController.swift
//  RecipeSearch
//
//  Created by YS P on 5/24/24.
//

import UIKit

class ViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: SearchResultViewController())
    
    private var firstSectionCollectionView: UICollectionView!
    private var secondSectionCollectionView: UICollectionView!
    private var myPicksLabel: UILabel!
    private var recentlyRegisteredLabel: UILabel!
    
    // 네트워크 매니저 (싱글톤)
    var networkManager = NetworkManager.shared
    
    // (레시피 데이터를 다루기 위함) 빈배열로 시작
    var recipeArrays: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 배경색을 하얀색으로 설정
        setupFirstSectionCollectionView()
        setupSecondSectionCollectionView()
        setupDatas()
        setupMyPicksLabel()
        setupRecentlyRegisteredLabel()
        setupSearchBar()
    }
    
    // 서치바 셋팅
    func setupSearchBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Recipe Search"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30) // 볼드체 폰트 설정
        titleLabel.textAlignment = .left // 왼쪽 정렬
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        

        searchController.hidesNavigationBarDuringPresentation = false // 검색 중에 navigationBar 숨김 해제
        
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        navigationItem.searchController = searchController
        
        // 🍎 서치(결과)컨트롤러의 사용 (복잡한 구현 가능)
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
        //     ==> 글자마다 검색 기능 + 새로운 화면을 보여주는 것도 가능
        searchController.searchResultsUpdater = self
        
        
    }
    
    func setupFirstSectionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 250)
        
        firstSectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        firstSectionCollectionView.backgroundColor = .white
        firstSectionCollectionView.dataSource = self
        firstSectionCollectionView.delegate = self
        firstSectionCollectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: "SearchViewCell")
        
        view.addSubview(firstSectionCollectionView)
        firstSectionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstSectionCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            firstSectionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            firstSectionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstSectionCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupMyPicksLabel() {
        myPicksLabel = UILabel()
        myPicksLabel.text = "My Picks"
        myPicksLabel.textAlignment = .left
        myPicksLabel.textColor = .black
        myPicksLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        view.addSubview(myPicksLabel)
        myPicksLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myPicksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            myPicksLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPicksLabel.bottomAnchor.constraint(equalTo: firstSectionCollectionView.topAnchor, constant: -2),
            myPicksLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupSecondSectionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 368, height: 300)
        
        secondSectionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        secondSectionCollectionView.backgroundColor = .white
        secondSectionCollectionView.dataSource = self
        secondSectionCollectionView.delegate = self
        secondSectionCollectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: "SearchViewCell")
        //secondSectionCollectionView.layer.cornerRadius = 10 // 모서리 둥글게 설정
        
        view.addSubview(secondSectionCollectionView)
        secondSectionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondSectionCollectionView.topAnchor.constraint(equalTo: firstSectionCollectionView.bottomAnchor, constant: 40),
            secondSectionCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            secondSectionCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),
            secondSectionCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupRecentlyRegisteredLabel() {
        recentlyRegisteredLabel = UILabel()
        recentlyRegisteredLabel.text = "Recently Registered"
        recentlyRegisteredLabel.textAlignment = .left
        recentlyRegisteredLabel.textColor = .black
        recentlyRegisteredLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        view.addSubview(recentlyRegisteredLabel)
        recentlyRegisteredLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentlyRegisteredLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            recentlyRegisteredLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentlyRegisteredLabel.bottomAnchor.constraint(equalTo: secondSectionCollectionView.topAnchor, constant: -2),
            recentlyRegisteredLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // 데이터 셋업
    func setupDatas() {
        // 네트워킹의 시작
        networkManager.fetchRecipe(searchTerm: "호박") { result in
            print(#function)
            switch result {
            case .success(let recipeDatas):
                // 데이터(배열)을 받아오고 난 후
                self.recipeArrays = recipeDatas
                // 테이블뷰 리로드
                DispatchQueue.main.async {
                    self.firstSectionCollectionView.reloadData()
                    self.secondSectionCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == firstSectionCollectionView {
            return recipeArrays.count // 첫 번째 섹션의 아이템 수
        } else if collectionView == secondSectionCollectionView {
            return recipeArrays.count // 두 번째 섹션의 아이템 수
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == firstSectionCollectionView {
            // 첫 번째 섹션의 셀 구성
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchViewCell", for: indexPath) as! SearchViewCell
            let recipe = recipeArrays[indexPath.item]
            cell.imageUrl = recipe.imageUrl
            return cell
        } else if collectionView == secondSectionCollectionView {
            // 두 번째 섹션의 셀 구성
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchViewCell", for: indexPath) as! SearchViewCell
            let recipe = recipeArrays[indexPath.item]
            cell.imageUrl = recipe.imageUrl
            return cell
        }
        fatalError("Unexpected collection view.")
    }
}

// UICollectionViewDelegate 프로토콜 준수
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀이 선택되었을 때의 동작을 정의합니다.
        
    }
}

//MARK: -  🍎 검색하는 동안 (새로운 화면을 보여주는) 복잡한 내용 구현 가능

extension ViewController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
