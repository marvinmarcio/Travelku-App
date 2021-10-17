//
//  SignUpVC.swift
//  Travel
//
//  Created by Marvin Marcio on 09/04/21.
//

import UIKit
import UIKit
import Firebase
import FirebaseAuth

class SignUpChooseVC: UIViewController {
    var pesanAkhir: String!
  
    @IBOutlet weak var labelEx: UILabel!
    @IBOutlet weak var helloTextField: UITextField!
    @IBOutlet weak var createAccountUsingEmailButton: UIButton!
    @IBAction func phoneAndEmailPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "signUpp")
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true)
    }
 
    @IBAction func haveAnAccountSignInPressed(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "signIn")
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
//            helloTextField.text! = "\(pesanAkhir)"
            //check if text field is empty
            print(helloTextField.text!)
        }
        else
        {
            
        checkuserInfo()
        login()
          
        }
    }
    override func viewDidLoad() {
    
//        helloTextField.text = pesanAkhir
        super.viewDidLoad()
        
//        helloTextField.text = "Hello"
//        helloTextField.text = "Logged In"
//        helloTextField.text! = "\(pesanAkhir ?? "")"
//        if (Auth.auth().currentUser == nil){
////            helloTextField.text! = "\(pesanAkhir)"
//            //check if text field is empty
//            print(helloTextField.text!)
//        }
//        else
//        {
//            
//        checkuserInfo()
//        login()
//          
//        }
        
        labelEx.alpha = 0
        helloTextField.alpha = 0
        createAccountUsingEmailButton.layer.cornerRadius = 10
        createAccountUsingEmailButton.clipsToBounds = true
//        let uid = Auth.auth().currentUser?.uid
//        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                self.labelEx.text = dictionary["role"] as? String
//                if self.labelEx.text == "Pengemudi"
//                {
//                    self.presentDriverLoggedInScreen()
//                }
//                else if self.labelEx.text == "Admin"
//                {
//                    self.presentAdminLoggedInScreen()
//                }
//                else if self.labelEx.text == "Customer"
//                {
//                    self.presentLoggedInScreen()
//                }
////        self.checkuserInfo()
//        // Do any additional setup after loading the view.
//    }
//
//    }
    }
    
    func login()
    {
        labelEx.alpha = 0
        createAccountUsingEmailButton.layer.cornerRadius = 10
        createAccountUsingEmailButton.clipsToBounds = true
        let uid = Auth.auth().currentUser?.uid
 
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.labelEx.text = dictionary["role"] as? String
                if self.labelEx.text == "Driver"
                {
                    self.presentDriverLoggedInScreen()
                }
                else if self.labelEx.text == "Admin"
                {
                    self.presentAdminLoggedInScreen()
                }
                else if self.labelEx.text == "Customer"
                {
                    self.presentLoggedInScreen()
                }
//        self.checkuserInfo()
        // Do any additional setup after loading the view.
    }
        
    }
    }
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    let driverHomeScreen = storyBoard.instantiateViewController(withIdentifier: "driverHomeScreen") as! driverHomeScreenVC
//    driverHomeScreen.stringVariable = stringVariable
//    self.present(driverHomeScreen, animated: true, completion: nil)
//    self.navigationController?.isNavigationBarHidden = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func checkuserInfo()
    {
        if Auth.auth().currentUser != nil
        {
            print(Auth.auth().currentUser?.uid)
            helloTextField.text = "Not Logged In"
        }
    }
   

//    override func viewDidAppear(_ animated: Bool) {
//        checkuserInfo()
//    }

   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func presentLoggedInScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInVC = storyboard.instantiateViewController(withIdentifier: "homeScreen")
        loggedInVC.modalPresentationStyle = .fullScreen
        self.present(loggedInVC, animated: true, completion: nil)
    }
    func presentDriverLoggedInScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInDriverVC = storyboard.instantiateViewController(withIdentifier: "driverHomeScreen")
        loggedInDriverVC.modalPresentationStyle = .fullScreen
        self.present(loggedInDriverVC, animated: true, completion: nil)
    }
    
    func presentAdminLoggedInScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInDriverVC = storyboard.instantiateViewController(withIdentifier: "adminHomeScreen")
        loggedInDriverVC.modalPresentationStyle = .fullScreen
        self.present(loggedInDriverVC, animated: true, completion: nil)
    }
    
    func presentStartingScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "signUpScreen")
        signUpVC.modalPresentationStyle = .fullScreen
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? driverHomeScreenVC {
            helloTextField.text = "Logged In"
//            destination.pesanHasil = helloTextField.text!
        }
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
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
