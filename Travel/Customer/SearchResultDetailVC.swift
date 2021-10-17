//
//  SearchResultDetailVC.swift
//  Travel
//
//  Created by Marvin Marcio on 21/05/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SearchResultDetailVC: UIViewController {
    var seats = [Seat]()
    var amount = 0
    var checkint = 0
    var selectedSeatCounter = 0
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
     var selectedSchedule: Seat?
    
    var indexPath: IndexPath?
    var originCity: String?
    var destCity: String?
    var passengerCount: String?
    var departureDate: String?
    var vehicleType: String?
    var vehicleCapacity: String?
    var scheduleId: String?
//    var selectedSchedule:
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if(seatA1Btn.currentImage == UIImage(named: "seat_available") || seatB1Btn.currentImage == UIImage(named: "seat_available") || seatB2Btn.currentImage == UIImage(named: "seat_available")){
            
            //check whether seat is selected
            createAlert(message: "Please choose seats")
        }
        else if(seatB1Btn.currentImage == UIImage(named: "seat_selected") || seatB2Btn.currentImage == UIImage(named: "seat_selected"))
        {
        
        showAlert(title: "Confirm selected seat", message: "B1, B2", handlerConfirm: { (action) in
          
            self.presentFillPassengerDataScreen()
        }, handlerCancel: { (action) in
            return
        })
        }
     
    }
    @IBOutlet var vehicleTypeLabel: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var selectedSeatLabel: UILabel!
    var check = true
    @IBOutlet weak var seatA1Btn: UIButton!
    @IBAction func seatA1Btn(_ sender: Any) {
        check = !check
        if check == true {
                 seatA1Btn.setImage(UIImage(named: "seat_selected"), for: .normal)
            checkint = 1
            selectedSeatLabel.text = "A1"
            selectedSeatCounter = selectedSeatCounter+1
             } else {
                 seatA1Btn.setImage(UIImage(named: "seat_available"), for: .normal)
                checkint = 0
                selectedSeatLabel.text = "Selected Seat"
                selectedSeatCounter = 0
             }
    }
    
    @IBOutlet weak var seatB1Btn: UIButton!
    @IBAction func seatB1Btn(_ sender: Any) {
        check = !check
        if check == true {
                 seatB1Btn.setImage(UIImage(named: "seat_selected"), for: .normal)
            checkint = 1
            selectedSeatCounter = selectedSeatCounter+1
            selectedSeatLabel.text = "B1"
             } else {
                 seatB1Btn.setImage(UIImage(named: "seat_available"), for: .normal)
                checkint = 0
                selectedSeatLabel.text = "Selected Seat"
             }
       
    }
    @IBOutlet weak var seatB2Btn: UIButton!
    @IBAction func seatB2Btn(_ sender: Any) {
        check = !check
        if check == true {
                 seatB2Btn.setImage(UIImage(named: "seat_selected"), for: .normal)
        
            selectedSeatLabel.text = "B1, B2"
             } else {
                 seatB2Btn.setImage(UIImage(named: "seat_available"), for: .normal)
            
                selectedSeatLabel.text = "B1"
             }
    }
    @IBOutlet weak var seatB3Btn: UIButton!
    @IBAction func seatB3Btn(_ sender: Any) {
    }
    @IBOutlet weak var seatDriverBtn: UIButton!
    @IBAction func seatDriverBtn(_ sender: Any) {
    }
    @IBAction func seatC1Btn(_ sender: Any) {
    }
    @IBAction func seatC2Btn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seatDriverBtn.isUserInteractionEnabled = false
        seatB3Btn.isUserInteractionEnabled = false
        confirmButton.layer.cornerRadius = 10
        confirmButton.layer.shadowColor = #colorLiteral(red: 0.186602354, green: 0.3931151032, blue: 0.8937475681, alpha: 1)
        confirmButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        confirmButton.layer.shadowRadius = 5
        confirmButton.layer.shadowOpacity = 0.5
//        if seatA1Btn.currentImage == UIImage(named: "seat_selected") {
//            selectedSeatLabel.text = "A1"
//
//           }
//        else if seatA1Btn.currentImage == UIImage(named: "seat_available")
//        {
//            selectedSeatLabel.text = "Selected Seat"
//        }
    
//        vehicleTypeLabel.text = "price"
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.vehicleTypeLabel.text = self.scheduleId!
//        }
//        if let detailPage = segue.destination as? DetailPage {
////            let cell = sender as! MyCollectionViewCell
////            let indexPath = self.MyCollectionView.indexPath(for: cell)
////            detailPage.indexPath = indexPath
////            detailPage.YourArray = self.YourDetailPageArray
//        }
//        print(seats)
//        vehicleTypeLabel.text = selectedSchedule?.scheduleKey
        
//        let string = "Rp150.000"
//  var passengers = 2
//
//        //** US,CAD,GBP formatted
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale(identifier: "id_ID")
//        let number = formatter.number(from: string)
//        let doubleValue = number?.doubleValue
//        var decimalValue = number?.decimalValue
////        var dec = decimalValue!*2
//        var num = number as! Int*passengers
//
//        print(getStringFromNumber(number: number as! Float))
////        vehicleTypeLabel.text = String(getStringFromNumber(number: Float(num)))
//        amount = num
//        vehicleTypeLabel.text = updateTextField()
       
      
        // console output: 7
        
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale(identifier: "id_ID")
//        let number = formatter.number(from: string)
//        var doubleValue = number?.doubleValue
//        print(doubleValue)
        
     
//        var value = Int(doubleValue!)
//        vehicleTypeLabel.text = value as? String
//            vehicleTypeLabel.text = String(amount)
        
//        vehicleTypeLabel.text = scheduleId!
//        vehicleTypeLabel.text = vehicleType!
        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showAlert(title: String, message: String, handlerConfirm: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionConfirm = UIAlertAction(title: "Confirm", style: .destructive, handler: handlerConfirm)
        alert.addAction(action)
        alert.addAction(actionConfirm)
        self.present(alert, animated: true, completion: nil)
    }
 
    func updateTextField() -> String?
    {
        let number = Double(amount/1) + Double(amount%100)/100
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    
    func getStringFromNumber(number: Float) -> String {
        if number - Float(Int(number)) == 0 {
            return String("\(Int(number))")
        } else {
            return String("\(number)")
        }
    }
    
    
    func toDecimalWithAutoLocale() -> Decimal? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        //** US,CAD,GBP formatted
        formatter.locale = Locale(identifier: "id_ID")
        let string = "IDR 150.000"
        if let number = formatter.number(from: string) {
            vehicleTypeLabel.text = "text"
            return number.decimalValue
        }
        
        //** EUR formatted

        return nil
    }
    
    func presentFillPassengerDataScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fillPassengerVC = storyboard.instantiateViewController(withIdentifier: "passengerDataScreen")
        fillPassengerVC.modalPresentationStyle = .fullScreen
        self.present(fillPassengerVC, animated: true, completion: nil)
    }
    
    func toDoubleWithAutoLocale() -> Double? {
        guard let decimal = self.toDecimalWithAutoLocale() else {
            return nil
        }
//print(NSDecimalNumber(decimal:decimal).doubleValue)
        return NSDecimalNumber(decimal:decimal).doubleValue
    }

}



