//
//  CategoryTableCell.swift
//  Arriving
//
//  Created by anouk on 11/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit

class CategoryTableCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cleanCell() {
        self.titleLabel.text = ""
    }
    
}
