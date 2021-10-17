//
//  FillPassengerDataVC.swift
//  Travel
//
//  Created by Marvin Marcio on 05/07/21.
//

import UIKit

class FillPassengerDataVC: UIViewController, UITextFieldDelegate {

    var currentTextField: UITextField?
    
    @IBAction func pickUpAddressTapped(_ sender: Any) {
        presentMapScreen()
    }
    @IBAction func destinationAddressTapped(_ sender: Any) {
        presentDestinationMapScreen()
    }
  
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var passenger1Name: UITextField!
    @IBOutlet weak var passenger1IDNumber: UITextField!
    @IBOutlet weak var passenger2Name: UITextField!
    @IBOutlet weak var passenger2IDNumber: UITextField!
    @IBOutlet weak var pickUpAddress: UITextField!
    @IBOutlet weak var destinationAddress: UITextField!
    @IBAction func backButtonTapped(_ sender: Any) {
      
    }
    
    @IBAction func unwindFromPickUpMap (_ sender: UIStoryboardSegue) {
        guard let mapVC = sender.source as? MapScreen else { return }
        pickUpAddress.text = mapVC.addressLabel.text
        
//        custNameLabel.text = editProfileVC.fullNameTextField.text
//        custEmailLabel.text = editProfileVC.emailTextField.text
//        profileImage.image = editProfileVC.profileImage.image
    }
    
    @IBAction func unwindFromDestinationMap (_ sender: UIStoryboardSegue) {
        guard let mapVC = sender.source as? DestinationMapScreen else { return }
        destinationAddress.text = mapVC.addressLabel.text
        
//        custNameLabel.text = editProfileVC.fullNameTextField.text
//        custEmailLabel.text = editProfileVC.emailTextField.text
//        profileImage.image = editProfileVC.profileImage.image
    }
    
    @IBOutlet weak var submitPassengerDataBtn: UIButton!
  
    @IBAction func submitPassengerDataBtnPressed(_ sender: Any) {
        if (passenger1Name.text == "" || passenger1IDNumber.text == "" || passenger2Name.text == "" || passenger2IDNumber.text == "" || pickUpAddress.text == "" || destinationAddress.text == ""){
            //check if text field is empty
            print("please input data")
            createAlert(message: "Please input all required data")
        }
        else
        {
            showAlert(title: "Submit Passenger Data", message: "Are you sure you want all passenger data are correct?", handlerConfirm: { (action) in
              
                self.presentPaymentMethodScreen()
            }, handlerCancel: { (action) in
                return
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
//        let tapGestRec = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped))
//        address.addGestureRecognizer(tapGestRec)
        destinationAddress.delegate = self
        self.pickUpAddress.delegate = self
        backView.layer.cornerRadius = 20
        submitPassengerDataBtn.layer.cornerRadius = 10

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
    
    func showAlert(title: String, message: String, handlerConfirm: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionConfirm = UIAlertAction(title: "Submit", style: .destructive, handler: handlerConfirm)
        alert.addAction(action)
        alert.addAction(actionConfirm)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPaymentMethodScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let paymentMethodVC = storyboard.instantiateViewController(withIdentifier: "paymentMethodScreen")
        paymentMethodVC.modalPresentationStyle = .fullScreen
        self.present(paymentMethodVC, animated: true, completion: nil)
    }
    
    func presentMapScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: "mapVC")
        mapVC.modalPresentationStyle = .fullScreen
        self.present(mapVC, animated: true, completion: nil)
    }
    
    func presentDestinationMapScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destMapVC = storyboard.instantiateViewController(withIdentifier: "destMapVC")
        destMapVC.modalPresentationStyle = .fullScreen
        self.present(destMapVC, animated: true, completion: nil)
    }
    
   
//        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool   {
//            //Load your VC here
//            if (currentTextField == pickUpAddress)
//            {
//                presentMapScreen()
//            }
//
//            return false
//
//        }
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (currentTextField == pickUpAddress)
//        {
//            presentMapScreen()
//        }
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


