//
//  DemoTableViewCell.swift
//  Travel
//
//  Created by Marvin Marcio on 08/05/21.
//

import UIKit

class DemoTableViewCell: UITableViewCell {

    @IBOutlet var myLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var mySecondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        myImageView.layer.masksToBounds = false
//        myImageView.layer.cornerRadius = myImageView.frame.height/2
//        myImageView.clipsToBounds = true
        // Configure the view for the selected state
    }
//    func set(userdata:UserData) {

        
//        var fullname: String
//        var email: String
//        var mobilenumber: String
//        var profileimageurl: String
        
//        formTextLabel.text = post.form
//        subjectTextLabel.text = "科目："+post.subject
//        regionTextLabel.text = "地區："+post.region
//        priceTextLabel.text = post.price
//        subtitleLabel.text = post.createdAt.calenderTimeSinceNow()
//}
}
