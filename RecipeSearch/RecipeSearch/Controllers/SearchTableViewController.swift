//
//  RecipeSearchTableViewController.swift
//  RecipeSearch
//
//  Created by YS P on 5/26/24.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    weak var delegate: SearchResultsUpdating? // 델리게이트 프로퍼티 추가
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }

    

// SearchResultsUpdating 프로토콜 정의
protocol SearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController)
}
