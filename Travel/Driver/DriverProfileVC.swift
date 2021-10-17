//
//  DriverProfileVC.swift
//  Travel
//
//  Created by Marvin Marcio on 15/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class DriverProfileVC: UIViewController {
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverMobileNumber: UILabel!
    @IBOutlet weak var driverEmailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBAction func assignmentHistoryBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAssignmentHistoryScreen", sender: self)
        
    }
    @IBOutlet weak var signOutButton: UIButton!
        @IBAction func unwindFromEditDriver (_ sender: UIStoryboardSegue) {
        guard let editDriverProfileVC = sender.source as? EditDriverProfileVC else { return }
        driverNameLabel.text = editDriverProfileVC.driverNameField.text
        driverEmailLabel.text = editDriverProfileVC.driverEmailField.text
        driverImage.image = editDriverProfileVC.driverProfileImage.image
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        performSegue(withIdentifier: "toDriverEditProfile", sender: self)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindDriverProfile", sender: self)
    }
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
    
//    @IBAction func backButtonTapped(_ sender: Any) {
////
//        self.dismiss(animated: true, completion: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()
        setImgandBtn()

        // Do any additional setup after loading the view.
    }
    
    func loadProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.driverNameLabel.text = dictionary["fullname"] as? String
                self.driverMobileNumber.text = dictionary["mobilenumber"] as? String
                self.driverEmailLabel.text = dictionary["email"] as? String
                self.roleLabel.text = dictionary["role"] as? String
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
    
    func showAlert(title: String, message: String, handlerLogout: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionLogout = UIAlertAction(title: "Sign Out", style: .destructive, handler: handlerLogout)
        alert.addAction(action)
        alert.addAction(actionLogout)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setImgandBtn() {
        driverImage.layer.cornerRadius = driverImage.frame.size.width/2
        driverImage.clipsToBounds=true
        driverImage.layer.shadowRadius=10
        driverImage.layer.shadowColor=UIColor.black.cgColor
        driverImage.layer.shadowOffset=CGSize.zero
        driverImage.layer.shadowOpacity=1
        driverImage.layer.shadowPath = UIBezierPath(rect: driverImage.bounds).cgPath
        
        editButton.layer.cornerRadius = 10
        editButton.layer.masksToBounds=true
        editButton.layer.borderColor = #colorLiteral(red: 0.186602354, green: 0.3931151032, blue: 0.8937475681, alpha: 1)
        editButton.layer.borderWidth = 1.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDriverEditProfile") {
            let dest = segue.destination as! EditDriverProfileVC
            dest.driverName = driverNameLabel.text
            dest.driverEmail = driverEmailLabel.text
            dest.passedImg = driverImage.image
            dest.driverMobileNumber = driverMobileNumber.text
        }
    }
    
    func presentSignUpChooseScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpChooseVC = storyboard.instantiateViewController(withIdentifier: "signUpChooseScreen")
        signUpChooseVC.modalPresentationStyle = .fullScreen
        self.present(signUpChooseVC, animated: true, completion: nil)
    }
    
    func presentAssignmentHistoryScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpChooseVC = storyboard.instantiateViewController(withIdentifier: "assignmentHistoryScreen")
        signUpChooseVC.modalPresentationStyle = .fullScreen
        self.present(signUpChooseVC, animated: true, completion: nil)
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
