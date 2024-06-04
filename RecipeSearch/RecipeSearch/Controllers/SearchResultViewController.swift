//
//  SearchResultViewController.swift
//  RecipeSearch
//
//  Created by YS P on 5/27/24.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    // 버튼 타이틀 배열
        let buttonTitles = ["밥", "반찬", "국&찌개", "후식", "기타"]

    // 버튼들을 담을 스택 뷰
        var buttonsStackView: UIStackView!
    
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
        setupButtonsStackView()
        setupCollectionView()
        setupConstraints()

   
    }
    
    func setupButtonsStackView() {
           buttonsStackView = UIStackView()
           buttonsStackView.axis = .horizontal
           buttonsStackView.distribution = .fillEqually
           buttonsStackView.spacing = 8
           buttonsStackView.alignment = .center

           // 버튼 생성 및 스택 뷰에 추가
           for title in buttonTitles {
               let button = createButton(withTitle: title)
               buttonsStackView.addArrangedSubview(button)
           }

           view.addSubview(buttonsStackView)
       }

    func setupConstraints() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
               collectionView.translatesAutoresizingMaskIntoConstraints = false
               
               // 오토레이아웃 설정
               NSLayoutConstraint.activate([
                   buttonsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                   buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                   buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                   buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
                   
                   collectionView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
                   collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
               ])
    }

       func createButton(withTitle title: String) -> UIButton {
           let button = UIButton(type: .system)
           button.setTitle(title, for: .normal)
           button.backgroundColor = .white
           button.setTitleColor(.orange, for: .normal)
           button.layer.cornerRadius = 10
           button.layer.borderWidth = 1
           button.layer.borderColor = UIColor.orange.cgColor
           button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
           return button
       }
    
    @objc func buttonTapped(_ sender: UIButton) {
            guard let buttonTitle = sender.title(for: .normal) else { return }
            // (네트워킹 시작전에) 다시 빈배열로 만들기
            self.recipeArrays = []
            
            // 네트워킹 시작 (찾고자하는 단어를 가지고)
            networkManager.fetchRecipeButton(searchTerm: buttonTitle) { result in
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

    func setupCollectionView() {
        // 컬렉션뷰 초기화
                collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
                collectionView.dataSource = self
                collectionView.backgroundColor = .white
                collectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: Cell.recipeCollectionViewCellIdentifier)
                
                view.addSubview(collectionView)
                
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

