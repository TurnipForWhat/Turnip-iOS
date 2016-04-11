//
//  FriendTableViewCell.swift
//  Turnip
//
//  Created by Emily Sachs on 4/7/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var FriendIcon: UIImageView!
    @IBOutlet weak var FriendNameView: UIView!
    @IBOutlet weak var FriendStatusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions 

}
