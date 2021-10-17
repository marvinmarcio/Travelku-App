//
//  AdminAddNewScheduleVC.swift
//  Travel
//
//  Created by Marvin Marcio on 02/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class AdminAddNewScheduleVC: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var amount = 0
    
    lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID")
        return formatter
    }()
    var travelArray = [ [String: Any] ]()
    var driverArray = [ [String: Any] ]()
    let ref = Database.database().reference()
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    let pickerView4 = UIPickerView()
//    var type = [String]()
//    var types = ["Innova", "Avanza", "Hi-Ace"]
    var selectedVehicle: String?
    var selectedType: String?
    var selectedCapacity: String?
    var selectedDestCity: String?
    var selectedOriginCity: String?
    var selectedDriver: String?
    
    @IBOutlet weak var scheduleCounterLabel: UILabel!
    
    var originCity = ["Surabaya ", "Malang", "Blitar", "Batu", "Jombang", "Madiun"]
    var destCity = ["Malang", "Surabaya", "Blitar", "Malang", "Madiun", "Jombang", "Jember"]
    
    var datePicker :UIDatePicker!
    var datePicker2: UIDatePicker!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleId: UITextField!
    @IBOutlet weak var vehicleType: UITextField!
    @IBOutlet weak var vehicleCapacity: UITextField!
    @IBOutlet weak var departureDate: UITextField!
    @IBOutlet weak var departureTime: UITextField!
    @IBOutlet weak var cityOfOrigin: UITextField!
    @IBOutlet weak var cityOfDestination: UITextField!
    @IBOutlet weak var driverAssigned: UITextField!
    @IBOutlet weak var priceOfTravel: UITextField!
    @IBOutlet weak var imageUrlField: UITextField!
    @IBOutlet weak var driverImageUrlField: UITextField!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var driverId: UILabel!
    
    @IBAction func backButtonTapped(_ sender: Any) {

            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if (vehicleId.text == "" || vehicleType.text == "" || vehicleCapacity.text == "" || departureDate.text == "" || departureTime.text == "" || cityOfOrigin.text == "" || cityOfDestination.text == "" || driverAssigned.text == "" || priceOfTravel.text == ""){
            //error input register data
            print("please input data")
            createAlert(message: "Please fill in all the required fields")
        }
      
        else {
            let assignedvehicleid = vehicleId.text
            let assignedvehicletype = vehicleType.text
            let assignedvehiclecapacity = vehicleCapacity.text
            let departuredate = departureDate.text
            let departuretime = departureTime.text
            let origincity = cityOfOrigin.text
            let destcity = cityOfDestination.text
            let assigneddriver = driverAssigned.text
            let travelprice = priceOfTravel.text
            let url = imageUrlField.text
            let driverUrl = driverImageUrlField.text
            let driverRandId = driverId.text
//seatassignedcount = vehicleCapacity - seatremaining
                
//            let armadact = Int(armadaCounterLabel.text!) ?? 0
//            var vc = armadact + 1
//            var vd = String(vc)
//            let armadacount = vd
//            ["armadacount": armadacount]
           
                self.showSpinner()
              
                                //SAVE USER DATA TO DATABASE
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
                                let travelScheduleRef = ref.child("schedule").childByAutoId()
                                let key = travelScheduleRef.key
                               

            let values = ["assignedvehicleid": assignedvehicleid!, "assignedvehicletype": assignedvehicletype!, "assignedvehiclecapacity": assignedvehiclecapacity!, "departuredate": departuredate!, "departuretime": departuretime!, "origincity": origincity!, "destcity": destcity!, "assigneddriver": assigneddriver!, "travelprice": travelprice!, "seatremaining": assignedvehiclecapacity!, "seatassignedcount": 0, "vehicleImgURL": url!, "driverImgURL": driverUrl!, "randscheduleid": key, "driverid": driverRandId!, "resultskey": origincity!+destcity!+departuredate!] as [String : Any]
                                travelScheduleRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in

                                    if err != nil {
                                        print(err!)
                                        return
                                    }

                                    print("Saved to database")
                                })

                                self.removeSpinner()
            createAlert(message: "A new schedule has been added")
                                print("User Created Success")
        
            let schedulect = Int(scheduleCounterLabel.text!) ?? 0
            var vc = schedulect + 1
            var vd = String(vc)
            let schedulecount = vd
            
            
                                    //SAVE USER DATA TO DATABASE
            let uid = Auth.auth().currentUser?.uid
                                
            let travelArmadaRefs = ref.child("scheduleCounter").child(uid!)
    //                                let key = travelScheduleRef.key
                                   

            let valuess = ["schedulecount": schedulecount] as [String : Any]
                                    travelArmadaRefs.updateChildValues(valuess as [AnyHashable : Any], withCompletionBlock: { (err, ref) in

                                        if err != nil {
                                            print(err!)
                                            return
                                        }

                                        print("Saved to database")
                                    })
                                    print("User Created Success")
            
            
                               
        }
        getTextFieldsDefault()
    }
     
    
    override func viewDidLoad() {
        priceOfTravel.delegate = self
//        priceOfTravel.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        priceOfTravel.placeholder
        self.hideKeyboardWhenTappedAround()
        driverId.isUserInteractionEnabled = false
        driverId.alpha = 0
        scheduleCounterLabel.isUserInteractionEnabled = false
        scheduleCounterLabel.alpha = 0
        let uid = Auth.auth().currentUser?.uid
//        let usersRef = self.ref.child("armadaCounter")
        Database.database().reference().child("scheduleCounter").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String]{
                var schedulecounter = dictionary["schedulecount"]! as String
                self.scheduleCounterLabel.text = schedulecounter
            }
        }
        
        
        
     getDatePicker()
    getDatePicker2()

        
        vehicleType.isUserInteractionEnabled = false
        vehicleCapacity.isUserInteractionEnabled = false

        let usersRef = self.ref.child("armada")
        let query = usersRef.queryOrdered(byChild: "vehicleid")
               query.observe(.value, with: { (snapshot) in
                   for child in snapshot.children {
                        let snap = child as! DataSnapshot
               let userDict = snap.value as! [String: Any]
                   
              print(userDict)
               self.travelArray.append(userDict)
                   }
                self.pickerView1.reloadAllComponents()
//                print(self.travelArray.count)
                self.createPickerView()
               })
 
        pickerView1.delegate = self
        pickerView1.dataSource = self
        
        
        let driversRef = self.ref.child("users")
        let driverQuery = driversRef.queryOrdered(byChild: "role").queryEqual(toValue: "Driver")
               driverQuery.observe(.value, with: { (snapshot) in
                   for child in snapshot.children {
                        let snap = child as! DataSnapshot
               let driverDict = snap.value as! [String: Any]
              print(driverDict)
               self.driverArray.append(driverDict)
                   }
                self.pickerView2.reloadAllComponents()
                self.createPickerView()
               })
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
    
        pickerView3.delegate = self
        pickerView3.dataSource = self

        pickerView4.delegate = self
        pickerView4.dataSource = self
        
      vehicleId.inputView = pickerView1
    driverAssigned.inputView = pickerView2
        cityOfOrigin.inputView = pickerView3
        cityOfDestination.inputView = pickerView4
        submitButton.layer.cornerRadius = 10
    
        dismissPickerView()
//        createPickerViews()
//        dismissPickerViews()
        imageUrlField.alpha = 0
        vehicleImage.alpha = 0
        driverImage.alpha = 0
        driverImageUrlField.alpha = 0
        imageUrlField.isUserInteractionEnabled = false
        vehicleImage.isUserInteractionEnabled = false
        driverImageUrlField.isUserInteractionEnabled = false
        driverImage.isUserInteractionEnabled = false
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    func updateTextField() -> String?
    {
        let number = Double(amount/1) + Double(amount%100)/100
        return numberFormatter.string(from: NSNumber(value: number))
    }
    
    func getTextFieldsDefault()
    {
        vehicleId.text = ""
        vehicleType.text = ""
        vehicleImage.image = #imageLiteral(resourceName: "profilePictureTemp")
        vehicleCapacity.text = ""
        departureDate.text = ""
        departureTime.text = ""
        cityOfOrigin.text = ""
        cityOfDestination.text = ""
        driverAssigned.text = ""
        priceOfTravel.text = ""
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Data Added", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDatePicker()
    {
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
              datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
              departureDate.inputView = datePicker
        datePicker.datePickerMode = .date
              let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
              let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
              departureDate.inputAccessoryView = toolBar
    }
    
    func getDatePicker2()
    {
        datePicker2 = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
              datePicker2.addTarget(self, action: #selector(self.dateChanged2), for: .allEvents)
              departureTime.inputView = datePicker2
        datePicker2.datePickerMode = .time
              let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone2))
              let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
              departureTime.inputAccessoryView = toolBar
    }
    
    
    func createPickerView(){
        let pickerView1 = UIPickerView();
        let pickerView2 = UIPickerView();
        let pickerView3 = UIPickerView();
        let pickerView4 = UIPickerView();
        
        
        pickerView1.delegate = self;
        pickerView2.delegate = self;
        pickerView3.delegate = self;
        pickerView4.delegate = self;
        
        vehicleId.inputView = pickerView1;
        driverAssigned.inputView = pickerView2;
        cityOfOrigin.inputView = pickerView3;
        cityOfDestination.inputView = pickerView4;
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        if vehicleId.isEditing
        {
            
        return travelArray.count
        }//return 5??
        
        else if driverAssigned.isEditing
        {
            return driverArray.count
        }// return 2??
        else if cityOfOrigin.isEditing
        {
            return originCity.count
        }// return 2??
        else
        {
            return destCity.count
        }
       
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        vehicleId.inputView = pickerView1;
        driverAssigned.inputView = pickerView2;
      
 
        if vehicleId.isEditing
        {
            let userDict = self.travelArray[row]
            return userDict["vehicleid"] as! String;
        }
        else if driverAssigned.isEditing
        {
            let driverDict = self.driverArray[row]
            return driverDict["fullname"] as! String;
        }
        else if cityOfOrigin.isEditing
        {
            return originCity[row]
        }
        else
        {
            return destCity[row]
        }
      
//        let userDicts = self.travelArray[row]
//        let key = userDicts["randuserid"] as! String
//        cell.myLabel.text = userDict["fullname"] as! String

     
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vehicleId.inputView = pickerView1;
        driverAssigned.inputView = pickerView2
        if vehicleId.isEditing
        {
        let userDict = self.travelArray[row]
        selectedVehicle = userDict["vehicleid"] as! String;
        vehicleId.text = selectedVehicle;
     
        selectedType = userDict["vehicletype"] as! String;
        vehicleType.text = selectedType
        selectedCapacity = userDict["vehiclecapacity"] as! String;
            vehicleCapacity.text = "\(selectedCapacity!) passengers capacity"
        let a = vehicleImage.sd_setImage(with: URL(string: userDict["profileImgURL"] as! String))
        imageUrlField.text = userDict["profileImgURL"] as! String
          
            
            
        }
        else if driverAssigned.isEditing
     {
   
        let driverDict = self.driverArray[row]
        selectedDriver = driverDict["fullname"] as! String;
        let b = driverImage.sd_setImage(with: URL(string: driverDict["profileImgURL"] as! String))
        driverImageUrlField.text = driverDict["profileImgURL"] as! String
            driverId.text = driverDict["randuserid"] as! String
     }
        
        else if cityOfOrigin.isEditing
        {
            selectedOriginCity = originCity[row]
            cityOfOrigin.text = selectedOriginCity
        }
        else if cityOfDestination.isEditing
        {
            selectedDestCity = destCity[row]
            cityOfDestination.text = selectedDestCity
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
//ADD DONE BUTTON TO PICKERVIEW
    func dismissPickerView(){
        let toolbar = UIToolbar();
        toolbar.sizeToFit();
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolbar.setItems([flexibleSpace, doneBtn], animated: false);
        toolbar.isUserInteractionEnabled = true;
        
        vehicleId.inputAccessoryView = toolbar;
        driverAssigned.inputAccessoryView = toolbar;
        cityOfOrigin.inputAccessoryView = toolbar;
        cityOfDestination.inputAccessoryView = toolbar;
    }

    @objc func datePickerDone() {
          departureDate.resignFirstResponder()
      }

      @objc func dateChanged() {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
          departureDate.text = "\(selectedDate)"
      }
    
    func datePickerValueChanged(_ sender: UIDatePicker){

           // Create date formatter
           let dateFormatter: DateFormatter = DateFormatter()

           // Set date format
           dateFormatter.dateFormat = "dd/MM/yyyy "

           // Apply date format
           let selectedDate: String = dateFormatter.string(from: sender.date)

           print("Selected value \(selectedDate)")
       }
    
    @objc func datePickerDone2() {
          departureTime.resignFirstResponder()
      }

      @objc func dateChanged2() {
        datePicker2.datePickerMode = UIDatePicker.Mode.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let selectedTime = dateFormatter.string(from: datePicker2.date)
          departureTime.text = "\(selectedTime)"
      }
    
    @objc func dissmissKeyboard(){
        vehicleId.text = selectedVehicle
        vehicleType.text = selectedType
        vehicleCapacity.text = "\(selectedCapacity!)"
        driverAssigned.text = selectedDriver
        cityOfOrigin.text = selectedOriginCity
        cityOfDestination.text = selectedDestCity
        view.endEditing(true);
    }
    
//    override func didMoveToSuperview() {
//          textAlignment = .right
//          keyboardType = .numberPad
//          text = Formatter.decimal.string(for: amount)
//          addTarget(self, action: #selector(editingChanged), for: .editingChanged)
//      }
    
//    @objc func dissmissKeyboards(){
//        driverAssigned.text = selectedDriver
//        view.endEditing(true);
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        let cur = priceOfTravel.text!.currencyInputFormatting()
//        priceOfTravel.text = cur
//    }
//
//}
//extension String {
//
//    // formatting text for currency textField
//    func currencyInputFormatting() -> String {
//
//        var number: NSNumber!
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currencyAccounting
//        formatter.currencySymbol = "Rp"
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
//
//        var amountWithPrefix = self
//
//        // remove from String: "$", ".", ","
//        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
//        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.utf8CString.count), withTemplate: "")
//
//        let double = (amountWithPrefix as NSString).doubleValue
//        number = NSNumber(value: (double / 100))
//
//        // if first number is 0 or all numbers were deleted
//        guard number != 0 as NSNumber else {
//            return ""
//        }
//
//        return formatter.string(from: number)!
//    }
//}
  
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let digit = Int(string)
        {
            amount = amount*10+digit
            if amount > 1_000_000
            {
                let alert = UIAlertController(title: "Please enter value less than 1 million", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {(action) in
                    self.amount = 0
                    self.priceOfTravel.text = ""
                }))
            }
            priceOfTravel.text = updateTextField()
        }
        if string == ""
        {
            amount = amount/10
            priceOfTravel.text = amount == 0 ? "" : updateTextField()
        }
        return false
    }
}

