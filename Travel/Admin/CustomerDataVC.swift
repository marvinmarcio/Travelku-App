//
//  CustomerDataVC.swift
//  Travel
//
//  Created by Marvin Marcio on 08/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage


class CustomerDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var usersArray = [ [String: Any] ]()
    let ref = Database.database().reference()
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let customercount = String(usersArray.count)
                                //SAVE USER DATA TO DATABASE
        let uid = Auth.auth().currentUser?.uid
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
        let travelCustomerRef = ref.child("customerCounter").child(uid!)
//                                let key = travelScheduleRef.key
                               

        let values = ["customercount": customercount] as [String : Any]
                                travelCustomerRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in

                                    if err != nil {
                                        print(err!)
                                        return
                                    }

                                    print("Saved to database")
                                })
                                print("User Created Success")
        
        
//        self.performSegue(withIdentifier: "unwindDriver", sender: self)
            self.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "unwindCustomer", sender: self)
    }
    let myData = ["first","second","third"]
    let mySecondData = ["Armin", "Mahmud", "Nixxou"]
    let imageData: [UIImage] = [#imageLiteral(resourceName: "Travel Armada"), #imageLiteral(resourceName: "Travel Schedule"), #imageLiteral(resourceName: "Customer")]
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let ref = Database.database().reference()
        let usersRef = self.ref.child("users")
        let query = usersRef.queryOrdered(byChild: "role").queryEqual(toValue: "Customer")
               query.observe(.value, with: { (snapshot) in
                   for child in snapshot.children {
                        let snap = child as! DataSnapshot
               let userDict = snap.value as! [String: Any]
              print(userDict)
               self.usersArray.append(userDict)
                   }
               self.tableView.reloadData()
               })
//            if let profileImageURL = dictionary["profileImgURL"] as? String {
//                let url = URL(string: profileImageURL)
//                URLSession.shared.dataTask(with: url!) { (data, response, error) in
//
//                    if error != nil {
//                        print("error")
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        self.profileButtonView.image = UIImage(data: data!)
//                    }
        let nib = UINib(nibName: "DemoTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DemoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
//TableView funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoTableViewCell", for: indexPath) as! DemoTableViewCell
      
        let userDict = self.usersArray[indexPath.row]
        cell.myLabel.text = userDict["fullname"] as! String
        let a = cell.myImageView.sd_setImage(with: URL(string: userDict["profileImgURL"] as! String))
//    
//        cell.myImageView.layer.cornerRadius = cell.myImageView.frame.height / 2
        cell.myImageView.layer.masksToBounds = true
        cell.mySecondLabel.text = userDict["mobilenumber"] as! String
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let userDict = self.usersArray[indexPath.row]
        let key = userDict["randuserid"] as! String

    if editingStyle == .delete {
    self.usersArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        Database.database().reference().child("users").child(key).removeValue()
    }
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
