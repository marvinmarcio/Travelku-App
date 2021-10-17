//
//  driverHomeScreenVC.swift
//  Travel
//
//  Created by Marvin Marcio on 23/04/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class driverHomeScreenVC: UIViewController {
    var pesanHasil: String!
    @IBOutlet weak var helloTextFields: UITextField!
    @IBOutlet weak var fullName: UILabel!
    @IBAction func logOutPressed(_ sender: Any) {
        showAlert(title: "Sign Out", message: "Are you sure want to sign out?", handlerLogout: { (action) in
            do{
                try Auth.auth().signOut()
            } catch{
                print("Error Signout")
            }
            self.presentSignUpChooseScreen()
        }, handlerCancel: { (action) in
            return
        })
        helloTextFields.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloTextFields.alpha = 0
//        helloTextFields.text! = "\(String(describing: pesanHasil))"
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
        
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.fullName.text = dictionary["fullname"] as? String
//                self.lblDisplayName.text = dictionary["fullname"] as? String
//                self.lblBio.text = dictionary["bio"] as? String
//                self.lblPost.text =  "\(dictionary["post"] as! Int)"
//                self.lblVote.text = "\(dictionary["vote"] as! Int)"
//                self.lblRep.text = "\(dictionary["rep"] as! Int)"
            }
        }
    }

    func showAlert(title: String, message: String, handlerLogout: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionLogout = UIAlertAction(title: "Log Out", style: .destructive, handler: handlerLogout)
        alert.addAction(action)
        alert.addAction(actionLogout)
        self.present(alert, animated: true, completion: nil)
    }
    func presentSignUpChooseScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpChooseVC = storyboard.instantiateViewController(withIdentifier: "signUpChooseScreen")
        signUpChooseVC.modalPresentationStyle = .fullScreen
        self.present(signUpChooseVC, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SignUpChooseVC {
            destination.pesanAkhir = helloTextFields.text!
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
