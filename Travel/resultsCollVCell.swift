//
//  resultsCollVCell.swift
//  Travel
//
//  Created by Marvin Marcio on 18/05/21.
//

import UIKit

class resultsCollVCell: UICollectionViewCell {
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var originCityAbr: UILabel!
    @IBOutlet weak var destCityAbr: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departureTime: UILabel!
   
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var vehicleIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
