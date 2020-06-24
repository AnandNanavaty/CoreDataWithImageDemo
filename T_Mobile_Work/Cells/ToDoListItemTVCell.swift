//
//  ToDoListItemTVCell.swift
//  T_Mobile_Work
//
//  Created by Anand Nanavaty on 24/06/20.
//  Copyright © 2020 Anand Nanavaty. All rights reserved.
//

import UIKit

class ToDoListItemTVCell: UITableViewCell {

    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var toDoSubTitleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
