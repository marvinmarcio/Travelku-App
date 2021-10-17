//
//  AssignmentHistoryDataVC.swift
//  Travel
//
//  Created by Marvin Marcio on 08/07/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class AssignmentHistoryDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var driverNameLabel: UILabel!
    var assignmentsArray = [ [String: Any] ]()
    let ref = Database.database().reference()
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let assignmentcount = String(assignmentsArray.count)
                                //SAVE USER DATA TO DATABASE
        let uid = Auth.auth().currentUser?.uid
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
        let travelScheduleRef = ref.child("scheduleCounter").child(uid!)
//                                let key = travelScheduleRef.key
                               

        let values = ["schedulecount": assignmentcount] as [String : Any]
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
        
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverNameLabel.alpha = 0
        loadProfile()
        
        let driverName = driverNameLabel.text
        let uid = Auth.auth().currentUser?.uid
        let assignmentRef = self.ref.child("schedule")
        let query = assignmentRef.queryOrdered(byChild: "driverid").queryEqual(toValue: uid)
               query.observe(.value, with: { (snapshot) in
                   for child in snapshot.children {
                        let snap = child as! DataSnapshot
               let assignmentDict = snap.value as! [String: Any]
//              print(userDict)
               self.assignmentsArray.append(assignmentDict)
                   }
               self.tableView.reloadData()
               })
//
        
        let nib = UINib(nibName: "AssignmentHistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AssignmentHistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func loadProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.driverNameLabel.text = dictionary["fullname"] as? String
        }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
//        cell.myLabel.text = userDict["fullname"] as! String
        return self.assignmentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentHistoryTableViewCell", for: indexPath) as! AssignmentHistoryTableViewCell
        
        
        let assignmentDict = self.assignmentsArray[indexPath.row]
        let a = cell.vehicleImg.sd_setImage(with: URL(string: assignmentDict["vehicleImgURL"] as! String))
        cell.scheduleDateLabel.text = assignmentDict["departuredate"] as! String
        cell.timeLabel.text = assignmentDict["departuretime"] as! String
        
        cell.cityLabel.text = "\(assignmentDict["origincity"] as! String) - \(assignmentDict["destcity"] as! String)"
      return cell
    }
    
//    func loadProfile() {
//        let uid = Auth.auth().currentUser?.uid
//        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                self.driverNameLabel.text = dictionary["fullname"] as? String
//            }
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

