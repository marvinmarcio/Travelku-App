//
//  ScheduleDataTableViewCell.swift
//  Travel
//
//  Created by Marvin Marcio on 10/05/21.
//

import UIKit

class ScheduleDataTableViewCell: UITableViewCell {
    @IBOutlet var scheduleDateLabel: UILabel!
    @IBOutlet var scheduleCityLabel: UILabel!
    @IBOutlet var scheduleTimeLabel: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet var vehicleIdLabel: UILabel!
    @IBOutlet var assignedDriverLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
