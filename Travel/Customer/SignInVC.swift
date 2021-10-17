//
//  SignInVC.swift
//  Travel
//
//  Created by Marvin Marcio on 09/04/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailAddressSignIn: UITextField!
    @IBOutlet weak var passwordSignIn: UITextField!
    @IBOutlet weak var helloTextField: UITextField!
    @IBOutlet weak var labelEx: UILabel!
    
    @IBAction func dontHaveAccountSignUpPressed(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        labelEx.alpha = 0
        helloTextField.alpha = 0
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
//        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func signInPressed(_ sender: Any) {
        if (emailAddressSignIn.text == "" || passwordSignIn.text == ""){
            //check if text field is empty
            print("please input data")
            createAlert(message: "Please input your email and password")
        }
        else{
            let email = emailAddressSignIn.text
            let password = passwordSignIn.text

            Auth.auth().signIn(withEmail: email!, password: password!) { user, error in
                //CHECK ERROR FIREBASE
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)

                    if firebaseError.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        self.createAlert(message: "The entered email is not registered yet.")
                    }
                    else if firebaseError.localizedDescription == "The password is invalid or the user does not have a password." {
                        self.createAlert(message: "Wrong password.")
                    }
                    else{
                        self.createAlert(message: firebaseError.localizedDescription)
                    }
                    return
                }
                let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        self.labelEx.text = dictionary["role"] as? String
                        print(self.labelEx.text)
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
                print("Login Success!")
              
            }
        }
    }
//    @objc func dissmissKeyboard(){
//        selectedRole = role[0]
//        roleTextField.text = selectedRole
//        view.endEditing(true);
//    }
    
    func checkuserInfo()
    {
        if Auth.auth().currentUser != nil
        {
            print(Auth.auth().currentUser?.uid)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func login()
    {
        labelEx.alpha = 0
//        createAccountUsingEmailButton.layer.cornerRadius = 10
//        createAccountUsingEmailButton.clipsToBounds = true
     
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
    
}

 
//    @IBAction func backButtonPressed(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    @IBAction func dontHaveAccSignUpPressed(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "signUpp")
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true)
//    }
//    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
//    }
//
//    func validateFields()
//    {
//        if emailAddressSignIn.text?.isEmpty == true
//        {
//            print("No email text")
//            return
//        }
//        if passwordSignIn.text?.isEmpty == true
//        {
//            print("No password")
//            return
//        }
//     login()
//    }
//
//    func login()
//    {
//        Auth.auth().signIn(withEmail: emailAddressSignIn.text!, password: passwordSignIn.text!) { [weak self] authResult, err in
//            guard let strongSelf = self else {return}
//            print(err?.localizedDescription)
//        }
//        self.checkUserInfo()
//    }
//
//    func checkUserInfo()
//    {
//        if Auth.auth().currentUser != nil
//        {
//            print(Auth.auth().currentUser?.uid)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "mainHome")
//            vc.modalPresentationStyle = .overFullScreen
//            present(vc, animated: true)
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        checkUserInfo()
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        signInButton.layer.cornerRadius = 10
//        signInButton.clipsToBounds = true
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//}
//    }
//
  
//}
