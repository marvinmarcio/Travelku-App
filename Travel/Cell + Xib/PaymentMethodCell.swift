//
//  PaymentMethodCell.swift
//  Travel
//
//  Created by Marvin Marcio on 11/07/21.
//

import UIKit

protocol PaymentMethodCellDelegate: AnyObject {
    func didGetPhoneNumber(for cell: PaymentMethodCell)
}

class PaymentMethodCell: UITableViewCell {
    weak var delegate: PaymentMethodCellDelegate?
    var indexPath: IndexPath?
    
    
    @IBOutlet weak var paymentMethodImage: UIImageView!
    @IBOutlet weak var paymentMethodName: UILabel!
    @IBOutlet weak var paymentNameTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let currentCell = self
//        callNumber(phoneNumber: "08129085726")
        delegate?.didGetPhoneNumber(for: currentCell)
        getMethodName(methodName: currentCell.paymentNameTemp.text!)
        // Configure the view for the selected state
      
    }
    
    func getMethodName(methodName: String)
    {
      var tempName = methodName

    }
    
}
