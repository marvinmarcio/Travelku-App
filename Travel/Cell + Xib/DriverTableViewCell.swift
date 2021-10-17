//
//  DriverTableViewCell.swift
//  Travel
//
//  Created by Marvin Marcio on 11/05/21.
//

import UIKit

class DriverTableViewCell: UITableViewCell {

    @IBOutlet var driverNameLabel: UILabel!
    @IBOutlet var driverMobileNumberLabel: UILabel!
    @IBOutlet weak var driverProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
