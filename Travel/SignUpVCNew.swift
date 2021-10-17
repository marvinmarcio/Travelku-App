//
//  SignUpVCNew.swift
//  Travel
//
//  Created by Marvin Marcio on 15/10/21.
//

//
//  SignUpVC.swift
//  Travel
//
//  Created by Marvin Marcio on 09/04/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos



class SignUpVCNew: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
    
//    @IBAction func backButtonPressed(_ sender: UIButton) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let backViewController = storyBoard.instantiateViewController(withIdentifier: "AddCoinTableViewController") as! AddCoinTableViewController
//        self.present(nextViewController, animated:true, completion:nil)
//    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var conPasswordField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    
    var role = ["Customer", "Driver"]
    var selectedRole: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
           
           Reach().monitorReachabilityChanges()
        createPickerView()
        dismissPickerView()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func signUpPressed(_ sender: UIButton) {
        if (firstNameField.text == "" || lastNameField.text == "" || genderField.text == "" || dobField.text == "" || mobileNumberField.text == "" || emailField.text == "" || passwordField.text == "" || conPasswordField.text == "" || roleField.text == ""){
            //error input register data
            print("please input data")
            createAlert(message: "Please fill in all the required fields")
        }
        else if passwordTextField.text != confirmPasswordTextField.text {
            createAlert(message: "Password doesn't match")
        }
        else {
            let email = emailAddressTextField.text
            let password = passwordTextField.text
            let fullname = fullNameTextField.text
            let mobilenumber = mobileNumberTextField.text
            let roles = roleTextField.text
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                //CHECK ERROR FIREBASE
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    self.createAlert(message: firebaseError.localizedDescription)
                    
                    return
                }
                self.showSpinner()
                //SAVE PROFILE IMAGE TO DATABASE
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child(imageName + ".png")
                if let uploadData = self.imgProfile.image!.pngData() {
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        storageRef.downloadURL(completion: { [self] (url, error) in
                            if error != nil {
                                print("error")
                                return
                            }
                            else {
                                //SAVE USER DATA TO DATABASE
                                let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
                                let uid = user!.user.uid
                                let usersRef = ref.child("users").child(uid)
                                let key = usersRef.key
//                                let values = ["roles": ]
                                let values = ["fullname": fullname!, "email": email!, "password": password!, "post": 0, "mobilenumber": mobilenumber!, "rep": 0, "profileImgURL": url!.absoluteString, "profileImgName": imageName + ".png", "role": roles!, "randuserid": key] as [String : Any]
                                usersRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                                    
                                    if err != nil {
                                        print(err!)
                                        return
                                    }
                                    
                                    print("Saved to database")
                                })
                                
                                self.removeSpinner()
                                print("User Created Success")
                                if selectedRole == role[1]
                                {
                                    self.presentDriverLoggedInScreen()
                                }
                                else
                                {
                                self.presentLoggedInScreen()
                                }
//                                }
                            }
                        })
                    }
                }
            }
        }
    }

    //GENERATING IMAGE PICKER FOR PROFILE
    @IBAction func SelectImageButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Choose Profile Picture", message: "Choose from library or use camera", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
                 switch photoAuthorizationStatus {
                 case .authorized:
                     self.present(imagePickerController, animated: true, completion: nil)
                 case .notDetermined:
                     PHPhotoLibrary.requestAuthorization({
                         (newStatus) in
                         DispatchQueue.main.async {
                             if newStatus ==  PHAuthorizationStatus.authorized {
                                 self.present(imagePickerController, animated: true, completion: nil)
                             }else{
                                 print("User denied")
                             }
                         }})
                     break
                 case .restricted:
                     print("restricted")
                     break
                 case .denied:
                     print("denied")
                     break
                 case .limited:
                    break
                 @unknown default:
                    break
                 }
     
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImg
        }
        else if let originalImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImg
        }
        
        if let selectedImg = selectedImage {
            let selectedImgProfile = resizeImage(image: selectedImg, targetSize: CGSize(width: 250, height: 250))
            imgProfile.image = selectedImgProfile
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //CREATING PICKERVIEW ROLE
        func createPickerView(){
            let pickerView = UIPickerView();
            pickerView.delegate = self;
            
            roleTextField.inputView = pickerView;
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return role.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return role[row];
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedRole = role[row];
            roleTextField.text = selectedRole;
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1;
        }
    //ADD DONE BUTTON TO PICKERVIEW
        func dismissPickerView(){
            let toolbar = UIToolbar();
            toolbar.sizeToFit();
            
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
            toolbar.setItems([flexibleSpace, doneBtn], animated: false);
            toolbar.isUserInteractionEnabled = true;
            
            roleTextField.inputAccessoryView = toolbar;
        }
        @objc func dissmissKeyboard(){
            roleTextField.text = selectedRole
            view.endEditing(true);
        }
    //SEGUE LOGIN
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
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
}

