//
//  LocationTableViewCell.swift
//  dolochallenge
//
//  Created by Casey Wilcox on 2/18/18.
//  Copyright © 2018 Casey Wilcox. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
