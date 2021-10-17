//
//  OrderHistoryDataVC.swift
//  Travel
//
//  Created by Marvin Marcio on 08/07/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class OrderHistoryDataVC: UIViewController {
    var ordersArray = [ [String: Any] ]()
    let ref = Database.database().reference()
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let orderscount = String(ordersArray.count)
                                //SAVE USER DATA TO DATABASE
        let uid = Auth.auth().currentUser?.uid
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
        let travelScheduleRef = ref.child("scheduleCounter").child(uid!)
//                                let key = travelScheduleRef.key
                               

        let values = ["schedulecount": orderscount] as [String : Any]
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

        // Do any additional setup after loading the view.
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
