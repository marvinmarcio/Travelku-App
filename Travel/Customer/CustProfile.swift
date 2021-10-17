//
//  CustEditProfileVC.swift
//  Travel
//
//  Created by Marvin Marcio on 26/04/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class CustProfile: UIViewController {
    @IBAction func unwindFromEdit (_ sender: UIStoryboardSegue) {
        guard let editProfileVC = sender.source as? EditCustProfile else { return }
        custNameLabel.text = editProfileVC.fullNameTextField.text
        custEmailLabel.text = editProfileVC.emailTextField.text
        profileImage.image = editProfileVC.profileImage.image
    }
    
    @IBAction func unwindFromHomeScreen (_ sender: UIStoryboardSegue) {
        guard let editProfileVC = sender.source as? FloatingPanelVC else { return }
        custNameLabel.text = editProfileVC.custNameLabel.text
        profileImage.image = editProfileVC.profileImage.image
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindHome", sender: self)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var custNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var custEmailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
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
    override func viewDidLoad() {
        super.viewDidLoad()
//       profileImageProperties()
        setImgandBtn()
        loadProfile()
        // Do any additional setup after loading the view.
    }
    func loadProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.custNameLabel.text = dictionary["fullname"] as? String
                self.mobileNumberLabel.text = dictionary["mobilenumber"] as? String
                self.custEmailLabel.text = dictionary["email"] as? String
                self.roleLabel.text = dictionary["role"] as? String
                if let profileImageURL = dictionary["profileImgURL"] as? String {
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        
                        if error != nil {
                            print("error")
                            return
                        }
                        DispatchQueue.main.async {
                            self.profileImage.image = UIImage(data: data!)
                        }
                    }.resume()
                }
            }
        }
    }
    
    func fetchProfileImage()
    {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
        
//            let uid = Auth.auth().currentUser?.uid
//            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
//
//
//                    if let dictionary = snapshot.value as? [String: AnyObject]{
//
//                        self.custNameTextField.text = dictionary["fullname"] as? String
//                    }
//            }
               if let dictionary = snapshot.value as? [String: AnyObject]{
                if let profileImageURL = dictionary["profileImgURL"] as? String {
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        
                        if error != nil {
                            print("error")
                            return
                        }
                        DispatchQueue.main.async {
                            print(profileImageURL)
                            self.profileImage.image = UIImage(data: data!)
                    
                            
                        }
                    }.resume()
                }
                self.custNameLabel.text = dictionary["fullname"] as? String
                self.mobileNumberLabel.text = dictionary["mobilenumber"] as? String
                self.custEmailLabel.text = dictionary["email"] as? String
                self.roleLabel.text = dictionary["role"] as? String
//                self.custNameTextField.text = dictionary["fullname"] as? String
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
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds=true
        profileImage.layer.shadowRadius=10
        profileImage.layer.shadowColor=UIColor.black.cgColor
        profileImage.layer.shadowOffset=CGSize.zero
        profileImage.layer.shadowOpacity=1
        profileImage.layer.shadowPath = UIBezierPath(rect: profileImage.bounds).cgPath
        
        editProfileButton.layer.cornerRadius = 10
        editProfileButton.layer.masksToBounds=true
        editProfileButton.layer.borderColor = #colorLiteral(red: 0.186602354, green: 0.3931151032, blue: 0.8937475681, alpha: 1)
        editProfileButton.layer.borderWidth = 1.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editSegue") {
            let dest = segue.destination as! EditCustProfile
            dest.fullName = custNameLabel.text
            dest.email = custEmailLabel.text
            dest.passedImg = profileImage.image
            dest.mobileNumber = mobileNumberLabel.text
        }
    }
    
    func presentSignUpChooseScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpChooseVC = storyboard.instantiateViewController(withIdentifier: "signUpChooseScreen")
        signUpChooseVC.modalPresentationStyle = .fullScreen
        self.present(signUpChooseVC, animated: true, completion: nil)
    }
    
    func profileImageProperties()
    {
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        fetchProfileImage()
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
