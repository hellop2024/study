//
//  MemberDetailViewController.swift
//  Study Diary
//
//  Created by YS P on 5/7/24.
//

import UIKit

class MemberDetailViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var memberDescriptionLabel: UILabel!
    
    var memberData: Member?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    func setupUI() {
        mainImageView.image = memberData?.memberImage
        memberNameLabel.text = memberData?.memberName
        memberDescriptionLabel.text = memberData?.memberDescription
    }

    
}
