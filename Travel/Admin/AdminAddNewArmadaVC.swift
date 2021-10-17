//
//  AdminAddNewArmadaVC.swift
//  Travel
//
//  Created by Marvin Marcio on 02/05/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AdminAddNewArmadaVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   
    
    var vehicleTypes = ["Toyota Innova", "Ertiga", "Toyota Avanza", "Daihatsu Xenia"]
    var vehicleCapacities = ["5", "6", "7", "8", "9", "10"]
    var vehicleColors = ["black", "silver", "white","grey","blue","red","brown","green","yellow"]
    
    var selectedTypes: String?
    var selectedCapacities: String?
    var selectedColors: String?
    
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imgArmada: UIImageView!
    @IBOutlet weak var vehicleTypeField: UITextField!
    @IBOutlet weak var vehiclePlateNumberField: UITextField!
    @IBOutlet weak var vehicleCapacityField: UITextField!
    @IBOutlet weak var vehicleColorField: UITextField!
    @IBOutlet weak var vehicleIDField: UITextField!
    @IBOutlet weak var armadaCounterLabel: UILabel!
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
     
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if (vehicleTypeField.text == "" || vehiclePlateNumberField.text == "" || vehicleCapacityField.text == "" || vehicleColorField.text == "" || vehicleIDField.text == ""){
            //error input register data
            print("please input data")
            createAlert(message: "Please fill in all the required fields")
        }
        else
        {
            let vehicletype = vehicleTypeField.text
            let vehicleplatenumber = vehiclePlateNumberField.text
            let vehiclecapacity = vehicleCapacityField.text
            let vehiclecolor = vehicleColorField.text
            let vehicleid = vehicleIDField.text
            
            self.showSpinner()
//            let uid = Auth.auth().currentUser?.uid
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child(imageName + ".png")
            if let uploadData = self.imgArmada.image!.pngData() {
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

            let ref = Database.database().reference(fromURL: "https://travel-b65e1-default-rtdb.firebaseio.com")
                        let travelArmadaRef = ref.child("armada").childByAutoId()
                        let key = travelArmadaRef.key
                        let values = ["vehicletype": vehicletype!, "vehicleplatenumber": vehicleplatenumber!, "vehiclecapacity": vehiclecapacity!, "vehiclecolor": vehiclecolor!, "vehicleid": vehicleid!, "profileImgURL": url!.absoluteString, "profileImgName": imageName + ".png", "trips": 0, "randvehicleid": key] as [String : Any]
            travelArmadaRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    return
                }
                
                print("Saved to database")
            })
            
            self.removeSpinner()
            print("User Created Success")
            
        })
    }
    
}
           
            let armadact = Int(armadaCounterLabel.text!) ?? 0
            var vc = armadact + 1
            var vd = String(vc)
            let armadacount = vd
            
            
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
//
//            var vb = Int(armadacounter) ?? 0
//          //                var vc = vb + 1
//          //                self.armadaCounterLabel.text =
        textFieldDefaults()
    }//elseclose
        
    }
    
    @IBAction func SelectImageButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Choose Travel Armada Picture", message: "Choose from library or use camera", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
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
            imgArmada.image = selectedImgProfile
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        submitButton.layer.cornerRadius = 10
        armadaCounterLabel.isUserInteractionEnabled = false
        armadaCounterLabel.alpha = 0
        let uid = Auth.auth().currentUser?.uid
//        let usersRef = self.ref.child("armadaCounter")
        Database.database().reference().child("armadaCounter").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String]{
                var armadacounter = dictionary["armadacount"]! as String
                self.armadaCounterLabel.text = armadacounter
//               var vb = Int(armadacounter) ?? 0
//                var vc = vb + 1
//                self.armadaCounterLabel.text =
                
            }
            
        }
        
        createPickerView()
        dismissPickerView()
        pickerView1.dataSource = self
          pickerView1.delegate = self
          pickerView2.dataSource = self
          pickerView2.delegate = self
        pickerView3.dataSource = self
        pickerView3.delegate = self
        
//        pickerView1.tag = 1
//        pickerView2.tag = 2;

        vehicleTypeField.inputView = pickerView1
        vehicleCapacityField.inputView = pickerView2
        vehicleColorField.inputView = pickerView3
       
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

    func textFieldDefaults()
    {
        vehicleIDField.text = ""
        vehicleTypeField.text = ""
        vehicleColorField.text = ""
        vehicleCapacityField.text = ""
        vehiclePlateNumberField.text = ""
        imgArmada.image = #imageLiteral(resourceName: "profilePictureTemp")
    }
  
    func createPickerView(){
        let pickerView1 = UIPickerView();
        let pickerView2 = UIPickerView();
        let pickerView3 = UIPickerView();
        
        pickerView1.delegate = self;
        pickerView2.delegate = self;
        pickerView3.delegate = self;
        
        vehicleTypeField.inputView = pickerView1;
        vehicleCapacityField.inputView = pickerView2;
        vehicleColorField.inputView = pickerView3;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1
        {
            return vehicleTypes.count
        }
        else if pickerView == pickerView2
        {
            return vehicleCapacities.count
        }
        else if pickerView == pickerView3
        {
            return vehicleColors.count
        }
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pickerView1
        {
            return vehicleTypes[row];
        }
        else if pickerView == pickerView2
        {
            return vehicleCapacities[row]
        }
        else if pickerView == pickerView3
        {
            return vehicleColors[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == pickerView1
        {
            selectedTypes = vehicleTypes[row]
            vehicleTypeField.text = selectedTypes
        }
    else if pickerView == pickerView2
    {
        selectedCapacities = vehicleCapacities[row]
        vehicleCapacityField.text = selectedCapacities
    }
        else if pickerView == pickerView3
        {
            selectedColors = vehicleColors[row]
            vehicleColorField.text = selectedColors
        }
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
        vehicleTypeField.inputAccessoryView = toolbar
        vehicleCapacityField.inputAccessoryView = toolbar
        vehicleColorField.inputAccessoryView = toolbar
    }
    @objc func dissmissKeyboard(){
        vehicleTypeField.text = selectedTypes
        vehicleCapacityField.text = selectedCapacities
        vehicleColorField.text = selectedColors
        view.endEditing(true);
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
