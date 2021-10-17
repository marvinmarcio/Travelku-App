//
//  AdminContentView.swift
//  Travel
//
//  Created by Marvin Marcio on 09/07/21.
//

import UIKit

class AdminContentView: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var driverPhoto: UIImageView!
    
    @IBAction func callButtonPressed(_ sender: Any) {
        callNumber(phoneNumber: "08121312342")
    }
    @IBAction func messageButtonPressed(_ sender: Any) {
        messageNumber(phoneNumber: "08121312342")
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passengersCell", for: indexPath) as! PassengersCell
        cell.indexPath = indexPath
        cell.passengerName.text = names[indexPath.row]
        cell.passengerAddress.text = addresses[indexPath.row]
        cell.passengerNumber.alpha = 0
        cell.passengerNumber.text = numbers[indexPath.row]

        return cell
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
