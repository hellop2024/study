//
//  RecipesController.swift
//  RecipeSearch
//
//  Created by YS P on 5/27/24.
//

import UIKit

class RecipeDetailController: UIViewController {
    // ViewController에서 전달받은 레시피 데이터를 저장할 변수
    var recipe: Recipe?
    
    var lastView: UIView?
    
    // UI 요소 선언
    private let recipeImageView = UIImageView()
    private let recipeNameLabel = UILabel()
    private let nutritionInfoStackView = UIStackView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    // '재료' 라벨과 '재료' 데이터를 표시할 UI 요소 선언
    private let ingredientsTitleLabel = UILabel()
    private let ingredientsDetailLabel = UILabel()
    // '만드는법' 타이틀 레이블과 상세 레이블을 선언
    private let methodTitleLabel = UILabel()
    private var methodDetailLabels = UILabel()
    private var methodImageViews = UIImageView()
    
    // 영양 정보 레이블 배열
    private let nutritionLabels = ["열량", "탄수화물", "단백질", "지방", "나트륨"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // 배경색을 하얀색으로 설정
        setupUI()
        setupMethodUI()
        updateUIWithRecipeData()
    }
    
    private func setupMethodUI() {
        // '만드는법' 타이틀 레이블 설정
        methodTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        methodTitleLabel.textAlignment = .left
        methodTitleLabel.font = UIFont.systemFont(ofSize: 20)
        methodTitleLabel.text = "만드는법"
        contentView.addSubview(methodTitleLabel)

        // '만드는법' 타이틀 레이블 제약 조건 설정
        NSLayoutConstraint.activate([
            methodTitleLabel.topAnchor.constraint(equalTo: ingredientsDetailLabel.bottomAnchor, constant: 20),
            methodTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }

    
    private func setupUI() {
        
        // 스크롤 뷰 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 스크롤 뷰 제약 조건 설정
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        // 레시피 이미지 뷰 설정
              recipeImageView.translatesAutoresizingMaskIntoConstraints = false
              recipeImageView.contentMode = .scaleAspectFill
              recipeImageView.clipsToBounds = true
              contentView.addSubview(recipeImageView)
              
              // 레시피 이미지 뷰 제약 조건 설정
              NSLayoutConstraint.activate([
                  recipeImageView.topAnchor.constraint(equalTo: view.topAnchor),
                  recipeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                  recipeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                  recipeImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5)
              ])

        
        // 레시피 이름 레이블 설정
        recipeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeNameLabel.textAlignment = .center
        recipeNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        contentView.addSubview(recipeNameLabel)
        
        // 레시피 이름 레이블 제약 조건 설정
        NSLayoutConstraint.activate([
            recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 60),
            recipeNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        // 영양 정보 스택 뷰 설정
        nutritionInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        nutritionInfoStackView.axis = .horizontal
        nutritionInfoStackView.distribution = .fillEqually
        nutritionInfoStackView.alignment = .top
        nutritionInfoStackView.spacing = 8
        contentView.addSubview(nutritionInfoStackView)
        
        // 영양 정보 스택 뷰 제약 조건 설정
        NSLayoutConstraint.activate([
            nutritionInfoStackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 20),
            nutritionInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            nutritionInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // '재료' 타이틀 레이블 설정
            ingredientsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            ingredientsTitleLabel.textAlignment = .left
        ingredientsTitleLabel.font = UIFont.systemFont(ofSize: 20)
        ingredientsTitleLabel.text = "재료"
            contentView.addSubview(ingredientsTitleLabel)
            
            // '재료' 타이틀 레이블 제약 조건 설정
            NSLayoutConstraint.activate([
                ingredientsTitleLabel.topAnchor.constraint(equalTo: nutritionInfoStackView.bottomAnchor, constant: 20),
                ingredientsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
            ])
            
            // '재료' 상세 레이블 설정
            ingredientsDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            ingredientsDetailLabel.textAlignment = .left
            ingredientsDetailLabel.font = UIFont.systemFont(ofSize: 16)
            ingredientsDetailLabel.numberOfLines = 0 // 여러 줄 표시 가능
            contentView.addSubview(ingredientsDetailLabel)
            
            // '재료' 상세 레이블 제약 조건 설정
            NSLayoutConstraint.activate([
                ingredientsDetailLabel.topAnchor.constraint(equalTo: ingredientsTitleLabel.bottomAnchor, constant: 8),
                ingredientsDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                ingredientsDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        // '만드는법' 섹션의 마지막 뷰인 lastView를 contentView의 bottomAnchor에 연결합니다.
                if let lastView = self.lastView {
                    NSLayoutConstraint.activate([
                        lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
                    ])
                }
    }
    
    private func updateUIWithRecipeData() {
        guard let recipeData = recipe else { return }

        // 이미지 URL을 확인하고 이미지를 로드합니다.
        if let imageUrlString = recipeData.imageUrl, let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageUrl) else {
                    DispatchQueue.main.async {
                        self.recipeImageView.image = UIImage(systemName: "photo") // 이미지 로딩 실패 시 기본 이미지 설정
                    }
                    return
                }
                // 이미지 데이터가 유효한지 확인하고 메인 스레드에서 이미지 뷰를 업데이트합니다.
                DispatchQueue.main.async {
                    self.recipeImageView.image = UIImage(data: imageData) ?? UIImage(systemName: "photo") // 이미지 데이터가 유효하지 않을 경우 기본 이미지 설정
                }
            }
        } else {
            self.recipeImageView.image = UIImage(systemName: "photo") // URL이 없을 경우 기본 이미지 설정
        }

        // 레시피 이름 설정
        self.recipeNameLabel.text = recipeData.RCP_NM

        // 영양 정보 업데이트
        nutritionInfoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 기존 레이블 제거
        let nutritionValues = [recipeData.INFO_ENG, recipeData.INFO_CAR, recipeData.INFO_PRO, recipeData.INFO_FAT, recipeData.INFO_NA]
        for (label, value) in zip(nutritionLabels, nutritionValues) {
            let labelStackView = UIStackView()
            labelStackView.axis = .vertical
            labelStackView.alignment = .center
            labelStackView.spacing = 4

            let textLabel = UILabel()
            textLabel.text = label
            textLabel.font = UIFont.systemFont(ofSize: 16)
            labelStackView.addArrangedSubview(textLabel)

            let valueLabel = UILabel()
            valueLabel.text = value ?? "-"
            valueLabel.font = UIFont.systemFont(ofSize: 16)
            labelStackView.addArrangedSubview(valueLabel)

            nutritionInfoStackView.addArrangedSubview(labelStackView)
        }

        // '재료' 데이터 설정
        self.ingredientsDetailLabel.text = recipeData.RCP_PARTS_DTLS

        // '만드는법' 섹션을 추가하는 코드 시작
        var lastView: UIView = self.methodTitleLabel // 마지막으로 추가된 뷰를 추적합니다.
        for index in 1...20 {
            // 각 단계의 설명과 이미지를 가져옵니다.
            let manualStep = recipeData.manualSteps.count > index - 1 ? recipeData.manualSteps[index - 1] : nil
            let manualImageString = recipeData.manualImages.count > index - 1 ? recipeData.manualImages[index - 1] : nil
            
            if let manualStep = manualStep, let manualImageString = manualImageString,
               let manualImageUrl = URL(string: manualImageString),
               let manualImageData = try? Data(contentsOf: manualImageUrl) {
                
                let methodDetailLabel = UILabel()
                methodDetailLabel.translatesAutoresizingMaskIntoConstraints = false
                methodDetailLabel.textAlignment = .left
                methodDetailLabel.font = UIFont.systemFont(ofSize: 16)
                methodDetailLabel.numberOfLines = 0
                methodDetailLabel.text = manualStep
                contentView.addSubview(methodDetailLabel)
                
                let methodImageView = UIImageView()
                methodImageView.translatesAutoresizingMaskIntoConstraints = false
                methodImageView.contentMode = .scaleAspectFill
                methodImageView.clipsToBounds = true
                methodImageView.image = UIImage(data: manualImageData) ?? UIImage(systemName: "photo")
                contentView.addSubview(methodImageView)
                
                // 레이블과 이미지 뷰의 제약 조건을 설정합니다.
                NSLayoutConstraint.activate([
                    methodDetailLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20),
                    methodDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    methodDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    methodImageView.topAnchor.constraint(equalTo: methodDetailLabel.bottomAnchor, constant: 8),
                    methodImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    methodImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    methodImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
                ])
                
                lastView = methodImageView // 마지막으로 추가된 뷰를 업데이트
            }
        }
    }

}
