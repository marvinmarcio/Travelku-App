//
//  ScheduleDataVC.swift
//  Travel
//
//  Created by Marvin Marcio on 08/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class ScheduleDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var scheduleArray = [ [String: Any] ]()
//    var armadasArray =  [ [String: Any] ]()
    let ref = Database.database().reference()
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let schedulecount = String(scheduleArray.count)
                                //SAVE USER DATA TO DATABASE
        let uid = Auth.auth().currentUser?.uid
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
        let travelScheduleRef = ref.child("scheduleCounter").child(uid!)
//                                let key = travelScheduleRef.key
                               

        let values = ["schedulecount": schedulecount] as [String : Any]
                                travelScheduleRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in

                                    if err != nil {
                                        print(err!)
                                        return
                                    }

                                    print("Saved to database")
                                })
                                print("User Created Success")
        
        
//        self.performSegue(withIdentifier: "unwindDriver", sender: self)
            self.dismiss(animated: true, completion: nil)
//            self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let scheduleRef = self.ref.child("schedule")
               scheduleRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    
                     let snap = child as! DataSnapshot
                     let scheduleDict = snap.value as! [String: Any]
                    print(scheduleDict)
                     self.scheduleArray.append(scheduleDict)
                    
                }
                self.tableView.reloadData()
          })
        
//
        
        let nib = UINib(nibName: "ScheduleDataTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ScheduleDataTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleDataTableViewCell", for: indexPath) as! ScheduleDataTableViewCell
      
     
        
        let userDict = self.scheduleArray[indexPath.row]
      
        
    
        cell.vehicleIdLabel.text = userDict["assignedvehicleid"] as! String
        cell.scheduleTimeLabel.text = userDict["departuretime"] as! String
        cell.scheduleDateLabel.text = userDict["departuredate"] as! String
        cell.scheduleCityLabel.text = "\(userDict["origincity"] as! String) to \(userDict["destcity"] as! String)"
        cell.assignedDriverLabel.text = userDict["assigneddriver"] as! String
        
    
        cell.priceLabel.text = userDict["travelprice"] as! String
//        "\(userDict["vehiclecapacity"] as! String) passengers capacity"
//   "\(userDict["origincity"] as! String) \(userDict["destcity"] as! String)"
//        "\(string1) \(string2)"
  let a = cell.vehicleImage.sd_setImage(with: URL(string: userDict["vehicleImgURL"] as! String))
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let scheduleDict = self.scheduleArray[indexPath.row]
        let key = scheduleDict["randscheduleid"] as! String

    if editingStyle == .delete {
    self.scheduleArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        Database.database().reference().child("schedule").child(key).removeValue()
    }
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        let userDict = self.usersArray[indexPath.row]
//        let key = userDict["randuserid"] as! String
//
//    if editingStyle == .delete {
//    self.usersArray.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .left)
//        Database.database().reference().child("users").child(key).removeValue()
//    }
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
