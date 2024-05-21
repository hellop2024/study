//
//  ViewController.swift
//  Anabada Board
//
//  Created by YS P on 5/14/24.
//

import UIKit

// 정렬 옵션을 나타내는 열거형
enum SortOrder {
    case recent, highestPrice, lowestPrice
}

final class ViewController: UIViewController {
    
    // 테이블뷰
    private let tableView = UITableView()
    
    var itemListManager = ItemListManager()
    
    // 정렬
    var currentSortOrder: SortOrder = .recent
    
    // 하트 필터 상태를 추적하는 변수 추가
    private var isHeartFilterActive: Bool = false
    
    
    // 네비게이션바에 넣기 위한 버튼
    lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle"), style: .plain, target: self, action: #selector(showFilterOptions))
        return button
    }()
    
    
    lazy var heartButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(heartButtonTapped))
        return button //하트로 교체하기
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white //테이블 뷰에 있는 백그라운드가 하얗게 보이게
        navigationItem.leftBarButtonItem = filterButton
        setupDatas()//배열에 데이터생기도록 함수 호출
        setupTableView()
        setupNaviBar() // 네비게이션바 설정 함수 호출
        setupTableViewConstraints() // 테이블뷰의 오토레이아웃 설정 함수 호출
        // 플로팅 액션 버튼 추가
        setupFloatingActionButton()
    }
    
    func setupFloatingActionButton() {
        let fabButton = UIButton(type: .custom)
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        fabButton.backgroundColor = .systemBlue
        fabButton.setTitle("+", for: .normal)
        fabButton.setTitleColor(.white, for: .normal)
        fabButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        fabButton.layer.cornerRadius = 28 // 반지름을 버튼 높이의 절반으로 설정하여 원형으로 만듭니다.
        fabButton.clipsToBounds = true
        
        // 버튼 액션 연결
        fabButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        // 뷰에 버튼 추가
        self.view.addSubview(fabButton)
        
        // 오토레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            fabButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            fabButton.widthAnchor.constraint(equalToConstant: 56), // 버튼의 너비
            fabButton.heightAnchor.constraint(equalToConstant: 56) // 버튼의 높이
        ])
    }
    
    // 델리게이트가 아닌 방식으로 구현할때는 화면 리프레시⭐️
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 다시 나타날때, 테이블뷰를 리로드
        tableView.reloadData()
        
        //네비게이션 바 버튼을 설정합니다.
        navigationItem.rightBarButtonItem = heartButton
        navigationItem.leftBarButtonItem = filterButton
    }
    
    func setupNaviBar() {
        title = "당근"
        
        // 네비게이션바 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션 바 오른쪽 상단 버튼 설정
        updateHeartButtonImage()
    }
    
    // 하트 버튼의 이미지를 업데이트하는 메서드 추가
    func updateHeartButtonImage() {
        let heartImageName = isHeartFilterActive ? "heart.fill" : "heart"
        heartButton.image = UIImage(systemName: heartImageName)
    }
    
    func setupTableView() {
        // 델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        // 셀의 높이 설정
        tableView.rowHeight = 90
        
        // 셀의 등록⭐️ (타입인스턴스 - 메타타입)
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "ItemCell")
    }
    
    func setupDatas() {
        itemListManager.makeItemsListDatas() // 일반적으로는 서버에 요청
    }
    
    // 테이블뷰의 오토레이아웃 설정
    func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // 멤버를 추가하기 위한 다음 화면으로 이동
    @objc func plusButtonTapped() {
        // 다음화면으로 이동 (멤버는 전달하지 않음)
        let detailVC = UploadViewController()
        
        // 다음 화면의 대리자 설정 (다음 화면의 대리자는 지금 현재의 뷰컨트롤러)
        //detailVC.delegate = self
        
        // 화면이동
        navigationController?.pushViewController(detailVC, animated: true)
        //show(detailVC, sender: nil)
    }
    
    // 멤버를 추가하기 위한 다음 화면으로 이동
    @objc func heartButtonTapped() {
        
        // 하트 필터 상태를 토글합니다.
        isHeartFilterActive.toggle()
        
        // 하트 버튼의 이미지를 업데이트합니다.
        updateHeartButtonImage()
        
        // 테이블뷰를 다시 로드합니다.
        tableView.reloadData()
    }
    
    // 필터 옵션을 보여주는 메서드
    @objc func showFilterOptions() {
        let alert = UIAlertController(title: "정렬 옵션", message: "목록을 정렬하는 방법을 선택하세요.", preferredStyle: .actionSheet)
        
        // "최근순" 필터 액션
        alert.addAction(UIAlertAction(title: "최근 순", style: .default, handler: { _ in
            self.sortItems(by: .recent)
        }))
        
        // "최고가 순" 필터 액션
        alert.addAction(UIAlertAction(title: "최고가 순", style: .default, handler: { _ in
            self.sortItems(by: .highestPrice)
        }))
        
        // "최저가 순" 필터 액션
        alert.addAction(UIAlertAction(title: "최저가 순", style: .default, handler: { _ in
            self.sortItems(by: .lowestPrice)
        }))
        
        // 취소 액션
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        // 액션 시트 표시
        present(alert, animated: true, completion: nil)
    }
    
    // 아이템을 정렬하는 메서드
    func sortItems(by filter: SortOrder) {
        currentSortOrder = filter
        tableView.reloadData()
    }
    
}

//MARK: - 테이블뷰 데이터 소스 구현
extension ViewController: UITableViewDataSource {
    // 필터링된 아이템 목록을 반환하는 메서드
    func filteredItems() -> [Item] {
        if isHeartFilterActive {
            return itemListManager.getItemsList().filter { $0.itemHeart == true }
        } else {
            return itemListManager.getItemsList()
        }
    }
    
    // 1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 필터링된 아이템의 개수를 반환합니다.
        return filteredItems().count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //        // (힙에 올라간)재사용 가능한 셀을 꺼내서 사용하는 메서드 (애플이 미리 잘 만들어 놓음)
        //        // (사전에 셀을 등록하는 과정이 내부 메커니즘에 존재)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? MyTableViewCell else {
            fatalError("The dequeued cell is not an instance of MyTableViewCell.")
        }
        //
        //      let sortedItems = sortedFilteredItems()
        //        let item = sortedItems[indexPath.row]
        //        cell.item = item
        
        let item = sortedFilteredItems()[indexPath.row]
        cell.item = item
        cell.tag = item.itemId // tag를 itemId로 설정하여 셀을 식별
        
        //탭 제스처 설정 시 태그를 현재 indexPath.row로 설정합니다.
        cell.heartImageView.isUserInteractionEnabled = true//사용자 상호작용 활성화 확인
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleHeart(sender:)))
        cell.heartImageView.addGestureRecognizer(tapGesture)
        cell.heartImageView.tag = indexPath.row
        
        return cell
    }
    
    // 현재 정렬 상태에 따라 필터링된 아이템을 정렬하는 메서드
    func sortedFilteredItems() -> [Item] {
        let items = filteredItems()
        switch currentSortOrder {
        case .recent:
            return items.sorted(by: { $0.itemId > $1.itemId })
        case .highestPrice:
            return items.sorted(by: { $0.itemPrice ?? 0 > $1.itemPrice ?? 0 })
        case .lowestPrice:
            return items.sorted(by: { $0.itemPrice ?? 0 < $1.itemPrice ?? 0 })
        }
    }
}

//MARK: - 테이블뷰 델리게이트 구현 (셀이 선택되었을때)

extension ViewController: UITableViewDelegate {
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // 다음화면으로 이동
        let detailVC = DetailViewController()
        
        // 다음 화면의 대리자 설정 (다음 화면의 대리자는 지금 현재의 뷰컨트롤러)
        //detailVC.delegate = self
        
        // 다음 화면에 멤버를 전달
        // 현재 선택된 아이템의 필터링된 목록을 가져옵니다.
        let sortedItems = sortedFilteredItems()
        let item = sortedItems[indexPath.row]
        
        // 다음 화면에 아이템을 전달
        detailVC.item = item
        
        
        // 화면이동
        navigationController?.pushViewController(detailVC, animated: true)
        //show(detailVC, sender: nil)
    }
}

//MARK: - 멤버 추가하거나, 업데이트에 대한 델리게이트 구현

extension ViewController: ItemDelegate {
    // 멤버가 추가되면 실행할 메서드 구현
    func addNewItem(_ item: Item) {
        // 모델에 멤버 추가
        itemListManager.makeNewItem(item)
        // 테이블뷰를 다시 로드 (다시 그리기)
        tableView.reloadData()
    }
    
    // 멤버의 정보가 업데이트 되면 실행할 메서드 구현
    func update(index: Int, _ item: Item) {
        print("업데이트")
        // 모델에 멤버 정보 업데이트
        itemListManager.updateItemInfo(index: index, item)
        // 테이블뷰를 다시 로드 (다시 그리기)
        tableView.reloadData()
    }
}

//MARK: - 하트 토글 로직 구현
extension ViewController {
    @objc func toggleHeart(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        //메서드 호출 확인을 위한 디버깅
        print("Heart tapped for item at index: \(imageView.tag)")
        
        let sortedItems = sortedFilteredItems()
        let item = sortedItems[imageView.tag]
        
        guard let index = itemListManager.itemsList.firstIndex(where: { $0.itemId == item.itemId }) else { return }
        
        itemListManager.toggleHeart(at: index)
        //필터링된 아이템 목록을 다시 가져옵니다.
        let updatedItems = sortedFilteredItems()
        // 현재 선택된 아이템의 새로운 인덱스를 찾습니다.
        guard let newIndex = updatedItems.firstIndex(where: { $0.itemId == item.itemId }) else { return }
        //  새로운 인덱스로 태그를 업데이트합니다.
        imageView.tag = newIndex
        
        tableView.reloadData()
    }
    
}
