//
//  FlagCell.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/12/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import UIKit

class FlagCell: UITableViewCell {

    @IBOutlet var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
