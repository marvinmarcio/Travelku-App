//
//  ContentViewControllerExt.swift
//  Travel
//
//  Created by Marvin Marcio on 24/04/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ContentViewControllerExt: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var OriginCityTextField: UITextField!
    @IBOutlet weak var DestinationCityTextField: UITextField!
    @IBOutlet weak var DepartureDateTextField: UITextField!
    @IBOutlet weak var PassengerNumberTextField: UITextField!
   
    var alertView: UIAlertController?

  
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchButtonPressed(_ sender: Any) {
        if (OriginCityTextField.text == "" || DestinationCityTextField.text == "" || PassengerNumberTextField.text == "" || DepartureDateTextField.text == "" ){
            //error input register data
            print("please input data")
            let alertController = UIAlertController(title: "Test", message: "Please fill all the fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            alertController.presentInOwnWindow(animated: true, completion: {
                print("completed")
            })
//            createAlert(message: "Please fill in all the required fields")
        }
        else
        {
            performSegue(withIdentifier: "toShowSearchResults", sender: self)
        }
        OriginCityTextField.text = ""
        DestinationCityTextField.text = ""
        PassengerNumberTextField.text = ""
        DepartureDateTextField.text = ""
    }
    
    
    @IBOutlet var myTextField: UITextField!
    @IBOutlet var myView: UIView!
    var datePicker :UIDatePicker!
    var originCities = ["Surabaya", "Malang", "Blitar", "Batu", "Jombang"]
    var destCities = ["Surabaya", "Malang", "Blitar", "Batu", "Jombang", "Madiun"]
    var passengerNumber = ["1", "2", "3"]
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    var currentTxtFldTag : Int = 10
    var selectedDestCity: String?
    var selectedOriginCity: String?
    var selectedPassengerNumber: String?
    override func viewDidLoad() {
        
        let alert: UIAlertController = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
        OriginCityTextField.text = ""
        DestinationCityTextField.text = ""
        PassengerNumberTextField.text = ""
        DepartureDateTextField.text = ""
        self.hideKeyboardWhenTappedAround()
        createPickerView()
        dismissPickerView()
        pickerView1.dataSource = self
          pickerView1.delegate = self
          pickerView2.dataSource = self
          pickerView2.delegate = self
        pickerView3.dataSource = self
        pickerView3.delegate = self
        
        pickerView1.tag = 1
        pickerView2.tag = 2;

        OriginCityTextField.inputView = pickerView1
        DestinationCityTextField.inputView = pickerView2
        PassengerNumberTextField.inputView = pickerView3
//        datePicker.datePickerMode = UIDatePicker.Mode.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy"
//        let selectedDate = dateFormatter.string(from: datePicker.date)
   
       
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
              datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
              DepartureDateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
              let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
              let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
              DepartureDateTextField.inputAccessoryView = toolBar
//
        

        super.viewDidLoad()
        
    
        searchButton.layer.cornerRadius = 10
        self.hideKeyboardWhenTappedAround()
    textFieldExt()
        
       
        
//        myTextField.attributedPlaceholder = NSAttributedString(string: "placeholder text",
//                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//        self.hideKeyboardWhenTappedAround()
//        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        myTableView.delegate = self
//        myTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toShowSearchResults") {
            let dest = segue.destination as! SearchResultVC
            dest.originCity = OriginCityTextField.text
            dest.destCity = DestinationCityTextField.text
//            dest.passedImg = driverImage.image
            dest.passengerCount = PassengerNumberTextField.text
            dest.departureDate = DepartureDateTextField.text

//            dest.driverMobileNumber = DepartureDateTextField.text
        }
    }
   
    
    func textFieldExt()
    {
        var originImageView = UIImageView()
        var OriginCityImage = UIImage(named: "cityDest.png")
        originImageView.image = OriginCityImage
        OriginCityTextField.rightView = originImageView
        OriginCityTextField.rightViewMode = UITextField.ViewMode.always
        OriginCityTextField.rightViewMode = .always
        
        
        var destinationImageView = UIImageView()
        var  DestinationCityImage = UIImage(named: "cityDest.png")
        destinationImageView.image = DestinationCityImage
        DestinationCityTextField.rightView = destinationImageView
        DestinationCityTextField.rightViewMode = UITextField.ViewMode.always
        DestinationCityTextField.rightViewMode = .always
        
        var departureImageView = UIImageView()
        var  DepartureDateImage = UIImage(named: "date.png")
        departureImageView.image = DepartureDateImage
        DepartureDateTextField.rightView = departureImageView
        DepartureDateTextField.rightViewMode = UITextField.ViewMode.always
        DepartureDateTextField.rightViewMode = .always
        
        var passengerImageView = UIImageView()
        var  PassengerNumberImage = UIImage(named: "passengers.png")
        passengerImageView.image = PassengerNumberImage
        PassengerNumberTextField.rightView = passengerImageView
        PassengerNumberTextField.rightViewMode = UITextField.ViewMode.always
        PassengerNumberTextField.rightViewMode = .always
    }
    
    func createPickerView(){
        let pickerView1 = UIPickerView();
        let pickerView2 = UIPickerView();
        pickerView1.delegate = self;
        pickerView2.delegate = self;
        
        OriginCityTextField.inputView = pickerView1;
        DestinationCityTextField.inputView = pickerView2;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1
        {
            return originCities.count
        }
        else if pickerView == pickerView2
        {
            return destCities.count
        }
        else if pickerView == pickerView3
        {
            return passengerNumber.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerView1
        {
            return originCities[row];
        }
        else if pickerView == pickerView2
        {
            return destCities[row]
        }
        else if pickerView == pickerView3
        {
            return passengerNumber[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerView1
        {
            selectedOriginCity = originCities[row]
            OriginCityTextField.text = selectedOriginCity
        }
    else if pickerView == pickerView2
    {
        selectedDestCity = destCities[row]
        DestinationCityTextField.text = selectedDestCity
    }
        else if pickerView == pickerView3
        {
            selectedPassengerNumber = passengerNumber[row]
            PassengerNumberTextField.text = selectedPassengerNumber
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
        OriginCityTextField.inputAccessoryView = toolbar
        DestinationCityTextField.inputAccessoryView = toolbar
        PassengerNumberTextField.inputAccessoryView = toolbar
    }
    @objc func dissmissKeyboard(){
        OriginCityTextField.text = selectedOriginCity
        DestinationCityTextField.text = selectedDestCity
        PassengerNumberTextField.text = selectedPassengerNumber

        view.endEditing(true);
    }
    
    @objc func datePickerDone() {
          DepartureDateTextField.resignFirstResponder()
      }

      @objc func dateChanged() {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
          DepartureDateTextField.text = "\(selectedDate)"
      }

    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
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
    
    func showErrorMessage(_ message: String) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()

        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.cancel, handler: { _ in
            alertWindow.isHidden = true
        }))
        
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
//
//       override func didReceiveMemoryWarning() {
//           super.didReceiveMemoryWarning()
//           // Dispose of any resources that can be recreated.
//       }
       

}



extension UIAlertController {

    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
}
