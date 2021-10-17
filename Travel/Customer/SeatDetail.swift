//
//  SeatDetail.swift
//  Travel
//
//  Created by Marvin Marcio on 12/06/21.
//

import UIKit

//resultsCell.departureTime.text = resultsDict["departuretime"] as! String
//resultsCell.priceLabel.text = resultsDict["travelprice"] as! String
//resultsCell.vehicleTypeLabel.text = resultsDict["assignedvehicletype"] as! String
//resultsCell.keyLabel.text = resultsDict["randscheduleid"] as! String
//resultsCell.vehicleIdLabel.text = resultsDict["assignedvehicleid"] as! String
//let a = resultsCell.vehicleImage.sd_setImage(with: URL(string: resultsDict["vehicleImgURL"] as! String))
class Seat:NSObject {
    var scheduleKey: String
//    var seatNumber: String?
    
    init(scheduleKey: String) {
           self.scheduleKey = scheduleKey
//           self.seatNumber = seatNumber
     
       }
}

class SeatDetail: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
