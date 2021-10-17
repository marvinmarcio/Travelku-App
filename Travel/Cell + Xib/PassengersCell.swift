//
//  PassengersCell.swift
//  Travel
//
//  Created by Marvin Marcio on 09/07/21.
//

import UIKit

protocol PassengersCellDelegate: AnyObject {
    func didGetPhoneNumber(for cell: PassengersCell)
}

class PassengersCell: UITableViewCell {
    weak var delegate: PassengersCellDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet weak var passengerPhoto: UIImageView!
    @IBOutlet weak var passengerName: UILabel!
    @IBOutlet weak var passengerAddress: UILabel!
    @IBAction func passengerCallBtnPressed(_ sender: Any) {
        let currentCell = self
//        callNumber(phoneNumber: "08129085726")
        delegate?.didGetPhoneNumber(for: currentCell)
        callNumber(phoneNumber: currentCell.passengerNumber.text!)
    }
    
    @IBAction func passengerMessageBtnPressed(_ sender: Any) {
        let currentCell = self
        messageNumber(phoneNumber: currentCell.passengerNumber.text!)
    }
    
    
  
    
    @IBOutlet weak var passengerNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func messageNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(URL(string: "sms://\(phoneNumber)")!, options: [:], completionHandler: nil)
    }

}
