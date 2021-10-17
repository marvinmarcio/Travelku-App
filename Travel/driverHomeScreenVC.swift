//
//  driverHomeScreenVC.swift
//  Travel
//
//  Created by Marvin Marcio on 15/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import CallKit

class driverHomeScreenVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, AdminContactCellDelegate{
    func didGetPhoneNumber(for cell: AdminContactCell)
    {
        print("cell's indexPath=\(cell.indexPath!)")
    }
    
    
    var photos: [UIImage] = [
        UIImage(named: "profilePictureTemp.png")!,
        UIImage(named: "profilePictureTemp.png")!,
        UIImage(named: "profilePictureTemp.png")!
    ]
    
    let names = [
    "Admin1",
        "Admin2",
        "Admin3"
    ]
    
    let number =
    ["08121312342",
     "08123213213",
     "08123129321"
    ]
    
    @IBOutlet weak var tableView: UITableView!

    
    @IBOutlet weak var viewButton: UIButton!
    @IBAction func viewButtonPressed(_ sender: Any) {
        presentAssignmentDetailScreen()
    }
    
    
    @IBAction func unwindFromDriverProfile (_ sender: UIStoryboardSegue) {
        guard let driverProfileVC = sender.source as? DriverProfileVC else { return }
        driverNameLabel.text = driverProfileVC.driverNameLabel.text
        driverImage.image = driverProfileVC.driverImage.image
    }
    
    
    @IBOutlet weak var driverImage: UIImageView!
    
    @IBAction func signOutPressed(_ sender: Any) {
        showAlert(title: "Sign Out", message: "Are you sure want to sign out?", handlerLogout: { (action) in
            do{
                try Auth.auth().signOut()
            } catch{
                print("Error Signing Out")
            }
            self.presentSignUpChooseScreen()
        }, handlerCancel: { (action) in
            return
        })
    }
    @IBOutlet weak var assignmentView: UIView!
    @IBAction func viewButtonTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var driverNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        assignmentView.layer.cornerRadius = 10
        viewButton.layer.cornerRadius = 10
     
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        driverImage.isUserInteractionEnabled = true
        driverImage.addGestureRecognizer(tapGestureRecognizer)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        driverImageProperties()
        loadProfile()
       
          transparentNavbar()
        // Do any additional setup after loading the view.
    }
    
    func transparentNavbar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func loadProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.driverNameLabel.text = dictionary["fullname"] as? String
                if let profileImageURL = dictionary["profileImgURL"] as? String {
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        
                        if error != nil {
                            print("error")
                            return
                        }
                        DispatchQueue.main.async {
                            self.driverImage.image = UIImage(data: data!)
                        }
                    }.resume()
                }
            }
        }
    }
    
    func driverImageProperties()
    {
        driverImage.layer.masksToBounds = false
        driverImage.layer.cornerRadius = driverImage.frame.height/2
        driverImage.clipsToBounds = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage == driverImage {
            profileBtnTap()
        }
    }
    
    @objc func profileBtnTap(){
 
   performSegue(withIdentifier: "toDriverProfile", sender: self)
//        self.performSegue(withIdentifier: "unwindHomeScreen", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminContactCell", for: indexPath) as! AdminContactCell
        cell.indexPath = indexPath
        cell.delegate = self
        cell.adminName.text = names[indexPath.row]
        cell.adminNumber.text = number[indexPath.row]
        cell.adminPhoto.image = photos[indexPath.row]
       

        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath as IndexPath)
        let text = cell?.textLabel?.text
        if let text = text {
            NSLog("did select and the text is \(text)")
        }
    }
        
    func presentSignUpChooseScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpChooseVC = storyboard.instantiateViewController(withIdentifier: "signUpChooseScreen")
        signUpChooseVC.modalPresentationStyle = .fullScreen
        self.present(signUpChooseVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, handlerLogout: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionLogout = UIAlertAction(title: "Sign Out", style: .destructive, handler: handlerLogout)
        alert.addAction(action)
        alert.addAction(actionLogout)
        self.present(alert, animated: true, completion: nil)
    }

    func presentAssignmentDetailScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let driverMapVC = storyboard.instantiateViewController(withIdentifier: "driverMap")
        driverMapVC.modalPresentationStyle = .fullScreen
        self.present(driverMapVC, animated: true, completion: nil)
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
