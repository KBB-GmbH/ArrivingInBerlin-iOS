//
//  LocationTableCell.swift
//  Arriving
//
//  Created by anouk on 11/09/17.
//  Copyright © 2017 anouk. All rights reserved.
//

import UIKit

class LocationTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func cleanCell() {
        self.titleLabel.text = ""
    }

}
