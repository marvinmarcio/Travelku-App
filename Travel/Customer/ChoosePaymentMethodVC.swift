//
//  ChoosePaymentMethodVC.swift
//  Travel
//
//  Created by Marvin Marcio on 06/07/21.
//

import UIKit

class ChoosePaymentMethodVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    var check = true
    var tag = 0
    let names = [
    "Apple Pay",
        "Cash-on-Pickup"
    ]
    
    let paymentImage: [UIImage] = [
        UIImage(named: "Apple_Pay.png")!,
        UIImage(named: "Cash_On_Pickup.png")!
    ]

    @IBOutlet weak var ApplePayButton: UIButton!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBAction func nextStepButtonPressed(_ sender: Any) {
       if checkCOPImg.image == UIImage(named: "check_black")
       {
        presentPaymentCOPMethodScreen()
       }
       else if checkApplePayImg.image == UIImage(named: "check_black")
       {
    presentApplePayPaymentMethodScreen()
       
       }
        createAlert(message: "Please select a payment method")
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBAction func ApplePayButton(_ sender: Any) {
        check = !check
        if check == true {
            checkApplePayImg.image = UIImage(named: "check_black")
            checkCOPImg.image = UIImage(named: "check_white")
          
             } else {
                checkApplePayImg.image = UIImage(named: "check_white")
             }
    }
    @IBOutlet var checkApplePayImg: UIImageView!
    @IBOutlet var checkCOPImg: UIImageView!
    @IBOutlet weak var COPButton: UIButton!
    @IBAction func COPButton(_ sender: Any) {
        check = !check
        if check == true {
            checkCOPImg.image = UIImage(named: "check_black")
            checkApplePayImg.image = UIImage(named: "check_white")
          
             } else {
                checkCOPImg.image = UIImage(named: "check_white")
             }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 20
        nextStepButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passengersCell", for: indexPath) as! PaymentMethodCell
        cell.indexPath = indexPath
        cell.paymentMethodName.text = names[indexPath.row]
        cell.paymentMethodImage.image = paymentImage[indexPath.row]
        cell.paymentNameTemp.text =
            names[indexPath.row]
        cell.paymentNameTemp.alpha = 0

        return cell
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPaymentCOPMethodScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let COPpaymentMethodVC = storyboard.instantiateViewController(withIdentifier: "COPMethodScreen")
        COPpaymentMethodVC.modalPresentationStyle = .fullScreen
        self.present(COPpaymentMethodVC, animated: true, completion: nil)
    }
    
    func presentApplePayPaymentMethodScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ApplePaypaymentMethodVC = storyboard.instantiateViewController(withIdentifier: "ApplePayMethodScreen")
        ApplePaypaymentMethodVC.modalPresentationStyle = .fullScreen
        self.present(ApplePaypaymentMethodVC, animated: true, completion: nil)
    }
//    func presentPaymentApplePayMethodScreen(){
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let paymentMethodVC = storyboard.instantiateViewController(withIdentifier: "ApplePayMethodScreen")
//        paymentMethodVC.modalPresentationStyle = .fullScreen
//        self.present(paymentMethodVC, animated: true, completion: nil)
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
