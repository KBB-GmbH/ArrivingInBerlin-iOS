//
//  CategoryCollectionViewCell.swift
//  Arriving
//
//  Created by anouk on 05/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func cleanCell() {
        self.titleLabel.text = ""
    }
}
