//
//  EditCustProfile.swift
//  Travel
//
//  Created by Marvin Marcio on 27/04/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import Photos

class EditCustProfile: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
  
    
    
    @IBAction func backButtonTapped(_ sender: Any) {

            self.dismiss(animated: true, completion: nil)
    }
    
    
    var fullName: String?
    var email: String?
    var mobileNumber: String?
    var passedImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImg()
        self.hideKeyboardWhenTappedAround()
        fullNameTextField.text = fullName!
        mobileNumberTextField.text = mobileNumber!
        emailTextField.text = email!
        // Do any additional setup after loading the view.
    }
    
    func setImg() {
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds=true
        profileImage.layer.shadowRadius=10
        profileImage.layer.shadowColor=UIColor.black.cgColor
        profileImage.layer.shadowOffset=CGSize.zero
        profileImage.layer.shadowOpacity=1
        profileImage.layer.shadowPath = UIBezierPath(rect: profileImage.bounds).cgPath
        
        profileImage.image = passedImg!
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        if (fullNameTextField.text == "") {
            createAlert(message: "Full name must be filled out.")
        }
        else if profileImage.image != passedImg {
            showSpinner()
            
            //FETCH OLD IMAGE TO BE DELETED
            let uid = Auth.auth().currentUser?.uid
            var oldImgName: String?
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    oldImgName = dictionary["profileImgName"] as? String
                    
                    let delRef = Storage.storage().reference().child(oldImgName!)
                    delRef.delete { (error) in
                        if error != nil {
                            print("error")
                            return
                        }
                        else {
                            print("delete complete.")
                        }
                    }
                }
            }
            //UPLOADING NEW PROFILE IMAGE
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(imageName + ".png")
            if let uploadData = self.profileImage.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print("error")
                            return
                        }
                        else {
                            //SAVE USER DATA TO DATABASE
                            let uid = (Auth.auth().currentUser?.uid)!
                            let refPost = Database.database().reference().child("users").child(uid)
                            
                            let values = ["fullname": self.fullNameTextField.text!, "profileImgURL": url!.absoluteString, "profileImgName": imageName + ".png","mobilenumber": self.mobileNumberTextField.text!, "email": self.emailTextField.text!]
                            refPost.updateChildValues(values)
                            
                            self.removeSpinner()
                            self.performSegue(withIdentifier: "unwindProfile", sender: self)
                            print("Upload complete.")
                        }
                    })
                }
            }
        }
        else {
            let uid = (Auth.auth().currentUser?.uid)!
            let refPost = Database.database().reference().child("users").child(uid)
            
            let values = ["fullname": fullNameTextField.text!,"mobilenumber": mobileNumberTextField.text!, "email": emailTextField.text!]
            refPost.updateChildValues(values)
            
            self.performSegue(withIdentifier: "unwindProfile", sender: self)
        }
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func btnEditTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Choose Profile Picture", message: "Take picture from gallery or camera", preferredStyle: .actionSheet)
        
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
            profileImage.image = selectedImgProfile
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
