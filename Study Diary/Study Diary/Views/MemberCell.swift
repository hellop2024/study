//
//  MemberCell.swift
//  Study Diary
//
//  Created by YS P on 5/7/24.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    
    @IBOutlet weak var memberDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
