//
//  AdminContactCell.swift
//  Travel
//
//  Created by Marvin Marcio on 11/07/21.
//

import UIKit

protocol AdminContactCellDelegate: AnyObject {
    func didGetPhoneNumber(for cell: AdminContactCell)
}

class AdminContactCell: UITableViewCell {
    weak var delegate: AdminContactCellDelegate?
    var indexPath: IndexPath?
    @IBOutlet weak var adminPhoto: UIImageView!
    @IBOutlet weak var adminName: UILabel!
    @IBOutlet weak var adminNumber: UILabel!
    
    @IBAction func callNumberBtnPressed(_ sender: Any) {
        let currentCell = self
        delegate?.didGetPhoneNumber(for: currentCell)
        callNumber(phoneNumber: currentCell.adminNumber.text!)
    }
    
    @IBAction func messageNumberBtnPressed(_ sender: Any) {
        let currentCell = self
        delegate?.didGetPhoneNumber(for: currentCell)
        messageNumber(phoneNumber: currentCell.adminNumber.text!)
    }
    
    
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
