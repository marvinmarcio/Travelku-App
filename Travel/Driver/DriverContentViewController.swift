//
//  DriverContentViewController.swift
//  Travel
//
//  Created by Marvin Marcio on 08/07/21.
//

import UIKit
import MessageUI
import CallKit

class DriverContentViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, PassengersCellDelegate {
    @IBOutlet weak var passengerPhoto: UIImageView!
    @IBOutlet weak var passengerName: UILabel!
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
    @IBAction func callBtnPressed(_ sender: Any) {
//        callNumber(phoneNumber: "08129085726")

    }
    @IBAction func adminCallBtnPressed(_ sender: Any) {
        callNumber(phoneNumber: "081216502785")
    }
    @IBAction func adminMessageBtnPressed(_ sender: Any) {
        messageNumber(phoneNumber: "081216502785")
//        sendSMS(with: "Hello World")
    }
    @IBAction func messageBtnPressed(_ sender: Any) {
    }
    let names = [
    "Marvin",
        "Marcus",
        "Kumar"
    ]
    
    let addresses =
    [
        "Jl. Buring No. 15",
        "Jl. Buring No. 15",
        "Jl. Buring No. 23"
    ]
    
    let numbers =
    [
        "08129085726",
        "0829535692",
        "0821682467"
    ]
    
 
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passengersCell", for: indexPath) as! PassengersCell
        cell.indexPath = indexPath
               cell.delegate = self
        cell.passengerName.text = names[indexPath.row]
        cell.passengerAddress.text = addresses[indexPath.row]
        cell.passengerNumber.alpha = 0
        cell.passengerNumber.text = numbers[indexPath.row]

        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath)
        let text = cell?.textLabel?.text
        if let text = text {
            NSLog("did select and the text is \(text)")
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myView: UIView!
    
//
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

    func sendSMS(with text: String) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.body = text
            present(messageComposeViewController, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
  
        // Do any additional setup after loading the view.
    }
    
    func didGetPhoneNumber(for cell: PassengersCell)
    {
        print("cell's indexPath=\(cell.indexPath!)")
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

//extension UIViewController: UITableViewDelegate
//{
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("you tapped me")
//    }
//}


