//
//  PostTableViewCell.swift
//  FakeInstagram
//
//  Created by ChenMo on 2/20/19.
//  Copyright © 2019 ChenMo. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    // This username label is for the captions part
    @IBOutlet weak var usernameLabel2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
