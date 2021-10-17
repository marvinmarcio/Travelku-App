//
//  SearchResultVC.swift
//  Travel
//
//  Created by Marvin Marcio on 17/05/21.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase

class SearchResultVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    let ref = Database.database().reference()
    
    var originCity: String?
    var destCity: String?
    var passengerCount: String?
    var departureDate: String?
    var keyObject: String?
    var selectedVehicleType: String?
    var selectedScheduleId: String?
    var seat = [Seat] ()
    var resultsArray = [ [String: Any]]()
//    var passedImg: UIImage?
    
    
    let tap = UITapGestureRecognizer()
    
    @IBOutlet var scheduleIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var noResultsImageView: UIImageView!
    @IBOutlet var noScheduleLabel: UILabel!
    @IBOutlet var noScheduleDescLabel: UILabel!
    @IBOutlet var resultsCollectionView: UICollectionView!
    @IBOutlet var originCityAbrLabel: UILabel!
    @IBOutlet var originCityLabel: UILabel!
    @IBOutlet var destinationCityAbrLabel: UILabel!
    @IBOutlet var destinationCityLabel: UILabel!
    @IBOutlet var passengerCountLabel: UILabel!
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleIdLabel.alpha = 0
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        scheduleIdLabel.text = "Label"
        getNoResults()
        originCityLabel.text = originCity!
        destinationCityLabel.text = destCity!
        dateLabel.text = departureDate!
        if (Int(passengerCount!) == 1)
        {
            passengerCountLabel.text = "\(passengerCount!) psg."
        }
        else if (Int(passengerCount!)! > 1)
        {
            passengerCountLabel.text = "\(passengerCount!) psgs."
        }
        getOriginAbr()
        getDestAbr()
      fetchResults()
//        fetchSchedules()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func getNoResults()
    {
        noResultsImageView.alpha = 0
        noResultsImageView.isUserInteractionEnabled = false
        noScheduleLabel.alpha = 0
        noScheduleLabel.isUserInteractionEnabled = false
        noScheduleDescLabel.alpha = 0
        noScheduleDescLabel.isUserInteractionEnabled = false
    }
    
    func fetchResults()
    {
        let resultskey = originCity!+destCity!+departureDate!
        let origin = String(originCityLabel.text!)
        let usersRef = self.ref.child("schedule")
        let query = usersRef.queryOrdered(byChild: "resultskey").queryEqual(toValue: resultskey)
               query.observe(.value, with: { (snapshot) in
//                print(snapshot.value as Any)
                var newSeats: [Seat] = []
                   for child in snapshot.children {
                        let snap = child as! DataSnapshot
               let resultsDict = snap.value as! [String: Any]
                    let dict = snap.value as? [String: Any]
//                    let schedulekey = dict["randscheduleid"] as? String
//                    let seatss = Seat(scheduleKey: schedulekey)
//                    newSeats.append(seatss)
      self.resultsArray.append(resultsDict)
//
                   }
                self.seat = newSeats
                print(self.seat)
               self.resultsCollectionView.reloadData()
                if self.resultsArray.count == 0
                                     {
                    self.noResultsImageView.alpha = 1
                    self.noScheduleLabel.alpha = 1
                    self.noScheduleDescLabel.alpha = 1
                                     }
             
                print(self.seat)
               })

        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
      
     
    }

    func fetchSchedules() {
        
        let resultskey = originCity!+destCity!+departureDate!
        let origin = String(originCityLabel.text!)
        let usersRef = self.ref.child("schedule")
        let query = usersRef.queryOrdered(byChild: "resultskey").queryEqual(toValue: resultskey)
               query.observe(.value, with: { (snapshot) in
//                print(snapshot.value as Any)
                var newSeats: [Seat] = []
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String:Any],
         
                        let schedulekey = dict["randscheduleid"] as? String
                    {

                     let seatz = Seat(scheduleKey: schedulekey)
                        newSeats.append(seatz)
                    
                    }
                    
                self.seat = newSeats
                self.resultsCollectionView.reloadData()
                }
                 
                self.seat = newSeats
                print(self.seat)
               self.resultsCollectionView.reloadData()
                if self.seat.count == 0
                                     {
                    self.noResultsImageView.alpha = 1
                    self.noScheduleLabel.alpha = 1
                    self.noScheduleDescLabel.alpha = 1
                                     }
             
                print(self.seat)
               })

        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
      
        
       
       }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return resultsArray.count
       
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
            let resultsCell = resultsCollectionView.dequeueReusableCell(withReuseIdentifier: "resultsCell", for: indexPath) as! resultsCollVCell

            let resultsDict = self.resultsArray[indexPath.row]
            resultsCell.vehicleIdLabel.text = resultsDict["assignedvehicleid"] as! String
            let a = resultsCell.vehicleImage.sd_setImage(with: URL(string: resultsDict["vehicleImgURL"] as! String))
        resultsCell.vehicleImage.layer.cornerRadius = 10
        if (resultsDict["destcity"] as! String == "Surabaya")
        {
            resultsCell.destCityAbr.text = "SUB"
            if (resultsDict["origincity"] as! String == "Batu")
             {
                 resultsCell.originCityAbr.text = "BAT"
             }
             else if (resultsDict["origincity"] as! String == "Malang")
             {
                 resultsCell.originCityAbr.text = "MLG"
             }
             else if (resultsDict["origincity"] as! String == "Surabaya")
             {
                 resultsCell.originCityAbr.text = "SUB"
             }
            else if (resultsDict["origincity"] as! String == "Jombang")
             {
                 resultsCell.originCityAbr.text = "JBG"
             }
        }
        else if (resultsDict["destcity"] as! String == "Malang")
        {
            resultsCell.destCityAbr.text = "MLG"
            if (resultsDict["origincity"] as! String == "Batu")
             {
                 resultsCell.originCityAbr.text = "BAT"
             }
             else if (resultsDict["origincity"] as! String == "Malang")
             {
                 resultsCell.originCityAbr.text = "MLG"
             }
             else if (resultsDict["origincity"] as! String == "Surabaya")
             {
                 resultsCell.originCityAbr.text = "SUB"
             }
            else if (resultsDict["origincity"] as! String == "Jombang")
             {
                 resultsCell.originCityAbr.text = "JBG"
             }
        } else if (resultsDict["destcity"] as! String == "Jombang")
        {
            resultsCell.destCityAbr.text = "JGB"
            if (resultsDict["origincity"] as! String == "Batu")
             {
                 resultsCell.originCityAbr.text = "BAT"
             }
             else if (resultsDict["origincity"] as! String == "Malang")
             {
                 resultsCell.originCityAbr.text = "MLG"
             }
             else if (resultsDict["origincity"] as! String == "Surabaya")
             {
                 resultsCell.originCityAbr.text = "SUB"
             }
            else if (resultsDict["origincity"] as! String == "Jombang")
             {
                 resultsCell.originCityAbr.text = "JBG"
             }
        } else if (resultsDict["destcity"] as! String == "Batu")
        {
            resultsCell.destCityAbr.text = "BAT"
            if (resultsDict["origincity"] as! String == "Batu")
             {
                 resultsCell.originCityAbr.text = "BAT"
             }
             else if (resultsDict["origincity"] as! String == "Malang")
             {
                 resultsCell.originCityAbr.text = "MLG"
             }
             else if (resultsDict["origincity"] as! String == "Surabaya")
             {
                 resultsCell.originCityAbr.text = "SUB"
             }
            else if (resultsDict["origincity"] as! String == "Jombang")
             {
                 resultsCell.originCityAbr.text = "JBG"
             }
        }
        resultsCell.departureTime.text = resultsDict["departuretime"] as! String
        resultsCell.priceLabel.text = resultsDict["travelprice"] as! String
        resultsCell.vehicleTypeLabel.text = resultsDict["assignedvehicletype"] as! String
        resultsCell.keyLabel.text = resultsDict["randscheduleid"] as! String
        resultsCell.keyLabel.alpha = 0
        return resultsCell
    }
    
    func getOriginAbr()
    {
        if originCityLabel.text == "Surabaya"
        {
            originCityAbrLabel.text = "SUB"
        }
        else if originCityLabel.text == "Malang"
        {
            originCityAbrLabel.text = "MLG"
        }
        else if originCityLabel.text == "Jombang"
        {
            originCityAbrLabel.text = "JBG"
        }
        else if originCityLabel.text == "Batu"
        {
            originCityAbrLabel.text = "BAT"
        }
    }
    
    func getDestAbr()
    {
        if destinationCityLabel.text == "Surabaya"
        {
           destinationCityAbrLabel.text = "SUB"
        }
        else if destinationCityLabel.text == "Malang"
        {
           destinationCityAbrLabel.text = "MLG"
        }
        else if destinationCityLabel.text == "Madiun"
        {
           destinationCityAbrLabel.text = "MAD"
        }
        else if destinationCityLabel.text == "Jombang"
        {
           destinationCityAbrLabel.text = "JBG"
        }
        else if destinationCityLabel.text == "Batu"
        {
           destinationCityAbrLabel.text = "BAT"
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let key = resultsArray[indexPath.row]
//        let dvc = self.storyboard?.instantiateViewController(identifier: "ResultDetail")
//
//          selectedScheduleId = key["randscheduleid"] as! String
//

//        let cell = resultsCollectionView.cellForItem(at: indexPath) as! resultsCollVCell
//        performSegue(withIdentifier: "toResultDetail", sender: seat[indexPath.item])
//        
        
//        let resultDict = self.resultsArray[indexPath.row]
//                   selectedScheduleId = resultDict["randscheduleid"] as! String
//                   scheduleIdLabel.text = selectedScheduleId
////        performSegue(withIdentifier: "toResultDetail", sender: indexPath.row)
//        performSegue(withIdentifier: "toResultDetail", sender: seat[indexPath.row])
//
        
//        let resultDict = self.resultsArray[indexPath.row]
//               selectedScheduleId = resultDict["randscheduleid"] as! String
//               scheduleIdLabel.text = selectedScheduleId
//        let cell = resultsCollectionView.cellForItem(at: indexPath) as! travelCollVCell
//        performSegue(withIdentifier: "toResultDetail", sender: resultsArray[indexPath.item])
        
        
        
//        if resultsCollectionView.isUserInteractionEnabled
//        {
//        let resultDict = self.resultsArray[indexPath.row]
//        selectedScheduleId = resultDict["randscheduleid"] as! String
//        scheduleIdLabel.text = selectedScheduleId
//        print(scheduleIdLabel.text)
//            tap.numberOfTapsRequired = 2
//            resultsCollectionView.isUserInteractionEnabled = true
//               resultsCollectionView.addGestureRecognizer(tap)
//
//            self.performSegue(withIdentifier: "toResultDetail", sender: self);
//        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: collectionView.indexPath(for: resultsCollVCell), animated: <#T##Bool#>)
//        collectionView.deselectItem(at: collectionView.indexPath(for:  selectedScheduleId)!, animated: false)
//       // Note: Should not be necessary but current iOS 8.0 bug requires it.
//       tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: false)
//   }
    
//    func goToDetails()
//    {
//        self.performSegue(withIdentifier: "toResultDetail", sender: self);
//    }
//
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Second2DetailEdit" {
//            if let detailVC = segue.destination as? DrinkDetailViewController {
//                detailVC.headerLabel.text = "Edit Drink"
//            }
    
//        if segue.identifier == "toResultDetail" {
//         let destination = segue.destination as! SearchResultDetailVC
//            destination.scheduleId = scheduleIdLabel.text
//     }
        
//        if (segue.identifier == "toResultDetail")
//            {
//            if let dvc = segue.destination as? SearchResultDetailVC
//            {
//                dvc.scheduleId = selectedScheduleId
//            }
        
//        if (segue.identifier == "toResultDetail"){
//               let destinationController = segue.destination as? SearchResultDetailVC
//               if let indexPath = self.resultsCollectionView?.indexPath(for: sender as! resultsCollVCell){
//                destinationController!.scheduleId = scheduleIdLabel.text
//               }
//           }
        
        if segue.identifier == "toResultDetail" {
               let destination = segue.destination as! SearchResultDetailVC
               destination.selectedSchedule = sender as! Seat
           }
//            // Even here you can check for segue.identifiers if you have something to differentiate
//
}
    
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "toShowSearchResults") {
//            let dest = segue.destination as! SearchResultVC
//            dest.originCity = OriginCityTextField.text
//            dest.destCity = DestinationCityTextField.text
////            dest.passedImg = driverImage.image
//            dest.passengerCount = PassengerNumberTextField.text
//            dest.departureDate = DepartureDateTextField.text
////            dest.driverMobileNumber = DepartureDateTextField.text
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
