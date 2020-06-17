//
//  CountryCell.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/5/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet var flagView: UIImageView!
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
