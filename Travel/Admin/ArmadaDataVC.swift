//
//  ArmadaDataVC.swift
//  Travel
//
//  Created by Marvin Marcio on 08/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class ArmadaDataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var armadaLabel: UILabel!
    var armadaLblCounter: [Int] = [0]
    var armadasArray = [ [String: Any] ]()
    let ref = Database.database().reference()
//    let colors: [UIColor] = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    @IBOutlet var tableView: UITableView!
     
    
    @IBAction func backButtonTapped(_ sender: Any) {
        let armadacount = String(armadasArray.count)
                                //SAVE USER DATA TO DATABASE
        let uid = Auth.auth().currentUser?.uid
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
        let travelArmadaRef = ref.child("armadaCounter").child(uid!)
//                                let key = travelScheduleRef.key
                               

        let values = ["armadacount": armadacount] as [String : Any]
                                travelArmadaRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in

                                    if err != nil {
                                        print(err!)
                                        return
                                    }

                                    print("Saved to database")
                                })
                                print("User Created Success")
//        self.performSegue(withIdentifier: "unwindArmada", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    
//    Database.database().reference().child("posts").child("post_1").removeValue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        armadaLabel.isUserInteractionEnabled = false
        armadaLabel.alpha = 0
        let usersRef = self.ref.child("armada")
               usersRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    
                     let snap = child as! DataSnapshot
                     let userDict = snap.value as! [String: Any]
                    print(userDict)
                     self.armadasArray.append(userDict)
                    
                }
                self.tableView.reloadData()
          })
        let nib = UINib(nibName: "ArmadaTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ArmadaTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.armadasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArmadaTableViewCell", for: indexPath) as! ArmadaTableViewCell
      
        let userDict = self.armadasArray[indexPath.row]
        cell.vehicleTypeLabel.text = userDict["vehicletype"] as! String
        cell.vehicleIdLabel.text = userDict["vehicleid"] as! String
        cell.vehicleCapacityLabel.text = "\(userDict["vehiclecapacity"] as! String) passengers capacity"
        
//        "\(self.topicCounter[indexPath.row]) topik"
        cell.vehiclePlate
            .text = userDict["vehicleplatenumber"] as! String
        let a = cell.vehicleImage.sd_setImage(with: URL(string: userDict["profileImgURL"] as! String))
        
        var color = userDict["vehiclecolor"] as! String
     
//        ["black", "silver", "white","grey","blue","red","brown","green","yellow"]
        if color == "black"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "white"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "grey"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "blue"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "red"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "brown"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "silver"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "green"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
        else if color == "yellow"
        {
            cell.vehicleColorImage.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            cell.vehicleColorImage.layer.borderColor = #colorLiteral(red: 0.9992043376, green: 0.8751468062, blue: 0.4209253788, alpha: 1)
            cell.vehicleColorImage.layer.borderWidth = 2
        }
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let userDict = self.armadasArray[indexPath.row]
        let key = userDict["randvehicleid"] as! String

    if editingStyle == .delete {
    self.armadasArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        Database.database().reference().child("armada").child(key).removeValue()
    }
    }
    

 

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let photoDetailController = self.storyboard?.instantiateViewController(withIdentifier: "photoDetail") as! PhotoDetailController
//
//        photoDetailController.selectedPost = posts[indexPath.row]
//
//        present(photoDetailController, animated: true, completion: nil)
//    }
//    func deletePost() {
//      let uid = FIRAuth.auth()!.currentUser!.uid
//      let storage = FIRStorage.storage().reference(forURL: "gs://cloudcamerattt.appspot.com")
//
//      // Remove the post from the DB
//      ref.child("posts").child(selectedPost.postID).removeValue { error in
//        if error != nil {
//            print("error \(error)")
//        }
//      }
//      // Remove the image from storage
//      let imageRef = storage.child("posts").child(uid).child("\(selectedPost.postID).jpg")
//      imageRef.delete { error in
//        if let error = error {
//          // Uh-oh, an error occurred!
//        } else {
//         // File deleted successfully
//        }
//      }
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
