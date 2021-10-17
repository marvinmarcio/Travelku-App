//
//  AssignmentHistoryTableViewCell.swift
//  Travel
//
//  Created by Marvin Marcio on 08/07/21.
//

import UIKit

class AssignmentHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var vehicleImg: UIImageView!
    @IBOutlet weak var scheduleDateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
