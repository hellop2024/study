//
//  TabBarController.swift
//  RecipeSearch
//
//  Created by YS P on 5/27/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        tabBar.backgroundColor = .lightGray
        // 선택된 탭의 색상을 초록색으로 설정
        tabBar.tintColor = .init(red: 0, green: 0.6, blue: 0, alpha: 1)
    }
    
    func setupViewControllers() {
        let viewController = ViewController()
        viewController.tabBarItem = UITabBarItem(
            title: "For you",
            image: UIImage(systemName: "heart.text.square.fill"),
            selectedImage: UIImage(systemName: "heart.text.square.fill")
        )

        let recipesController = RecipesController()
        recipesController.tabBarItem = UITabBarItem(
            title: "Recipes",
            image: UIImage(systemName: "book.closed.fill"),
            selectedImage: UIImage(systemName: "book.closed.fill")
        )

        viewControllers = [viewController, recipesController]
    }
}
