//
//  ArmadaTableViewCell.swift
//  Travel
//
//  Created by Marvin Marcio on 10/05/21.
//

import UIKit

class ArmadaTableViewCell: UITableViewCell {
    @IBOutlet var vehicleTypeLabel: UILabel!
    @IBOutlet var vehicleCapacityLabel: UILabel!
    @IBOutlet var vehicleIdLabel: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleColorImage: UIImageView!
    @IBOutlet var vehiclePlate: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
