//
//  CustomerContentView.swift
//  Travel
//
//  Created by Marvin Marcio on 09/07/21.
//

import UIKit

class CustomerContentView: UIViewController {
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var vehicleColor: UIImageView!
    @IBAction func callBtnPressed(_ sender: Any) {
        callNumber(phoneNumber: "08219908920")
    }
    
    @IBAction func messageBtnPressed(_ sender: Any) {
        messageNumber(phoneNumber: "08219908920")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vehicleColor.layer.borderWidth = 1
          vehicleColor.layer.masksToBounds = false
          vehicleColor.layer.borderColor = UIColor.black.cgColor
          vehicleColor.layer.cornerRadius = vehicleColor.frame.height/2
          vehicleColor.clipsToBounds = true
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
