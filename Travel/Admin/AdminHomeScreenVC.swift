//
//  AdminHomeScreenVC.swift
//  Travel
//
//  Created by Marvin Marcio on 26/04/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class Travel: NSObject {
    var topic: String?
    var senderUID: String?
    var subject: String?
    var sender: String?
    var senderImg: UIImage?
}



//let now = Date()
//let date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: now), minute: Calendar.current.component(.minute, from: now) + 1, second: 0, of: now)!
//let timer = Timer(fire: date, timeInterval: 60, repeats: true) { _ in
//    self.getCurrentTime()
//}


var formatters: DateFormatter = {
    let formatters = DateFormatter()
    formatters.dateFormat = "hh:mm" // or "hh:mm a" if you need to have am or pm symbols
    return formatters
}()
class AdminHomeScreenVC: UIViewController, UIActionSheetDelegate, UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    let ref = Database.database().reference()
    var armadaCounter: [Int] = [0]
    
    @IBOutlet weak var travelCodeLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var oriDestCityLabel: UILabel!
    @IBOutlet weak var customerCounterLabel: UILabel!
    @IBOutlet weak var driverCounterLabel: UILabel!
    @IBOutlet weak var armadaCounterLabel: UILabel!
    @IBOutlet weak var scheduleCounterLabel: UILabel!
    @IBOutlet weak var trackButton: UIButton!
    @IBAction func trackBtnPressed(_ sender: Any) {
        presentAdminMapScreen()
    }
    
    
    
    
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
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
    
    
    let dataTypes:[String] = ["Driver", "Customer", "Travel Armada", "Travel Schedule"]
    var selectedData: Int?
    var selectedDataString: String?
    //FOR NEWEST AND TRENDING
//    var selectedTopic: String?
//    var selectedSender:String?
//    var selectedSenderImg: UIImage?
    
    var dataCounter: [Int] = [0, 0, 0, 0]
    var travelData = [Travel]() {
        didSet {
            self.travelCollectionView.reloadData()
        }
    }
    @IBOutlet weak var customerDataButton: UIButton!
    @IBOutlet weak var driverDataButton: UIButton!
    @IBOutlet weak var travelArmadaDataButton: UIButton!
    @IBOutlet weak var travelScheduleDataButton: UIButton!
    
    @IBOutlet weak var travelView: UIView!
    @IBOutlet weak var customerView: UIView!
    @IBOutlet weak var driverView: UIView!
    @IBOutlet weak var travelArmadaView: UIView!
    @IBOutlet weak var travelScheduleView: UIView!
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Add Menu", message: "Choose the below \"add\" options you want to execute", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Add New Travel Armada", style: .default, handler: { (ACTION :UIAlertAction!)in
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "newArmada") as! AdminAddNewArmadaVC
            self.present(nextView, animated: true, completion: nil)
//            let downloadView = self.storyboard?.instantiateViewController(withIdentifier: "down") as! DownloadView
//            self.present(downloadView, animated:true, completion:nil)
            }))
        actionSheet.addAction(UIAlertAction(title: "Add New Travel Schedule", style: .default, handler: { (ACTION :UIAlertAction!)in
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "newSchedule") as! AdminAddNewScheduleVC
            self.present(nextView, animated: true, completion: nil)
            }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
//    @IBAction func unwindFromEdit (_ sender: UIStoryboardSegue) {
////        guard let editProfileVC = sender.source as? EditCustProfile else { return }
////        custNameLabel.text = editProfileVC.fullNameTextField.text
////        custEmailLabel.text = editProfileVC.emailTextField.text
////        profileImage.image = editProfileVC.profileImage.image
//    }
    
    @IBAction func unwindFromArmadaData (_ sender: UIStoryboardSegue) {
        guard let armadaVC = sender.source as? ArmadaDataVC else { return }
        armadaCounterLabel.text = "\(armadaVC.armadasArray.count) Datas"
    }
    
    @IBAction func unwindFromCustomerData (_ sender: UIStoryboardSegue) {
        guard let customerVC = sender.source as? CustomerDataVC else { return }
        customerCounterLabel.text = "\(customerVC.usersArray.count) Datas"
    }
    
    @IBAction func unwindFromScheduleData (_ sender: UIStoryboardSegue) {
        guard let scheduleVC = sender.source as? ScheduleDataVC else { return }
        scheduleCounterLabel.text = "\(scheduleVC.scheduleArray.count) Datas"
    }
    
    @IBAction func unwindFromDriverData (_ sender: UIStoryboardSegue) {
        guard let driverVC = sender.source as? DriverDataVC else { return }
        driverCounterLabel.text = "\(driverVC.driversArray.count) Datas"
    }
    
    var timer = Timer()
    @IBOutlet weak var travelCollectionView: UICollectionView!
    @IBOutlet weak var dataCollectionView: UICollectionView!
    @IBOutlet weak var AdminName: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var addNewButton: UIButton!
    @IBAction func logOutPressed(_ sender: Any) {
        showAlert(title: "Sign Out", message: "Are you sure want to sign out?", handlerLogout: { (action) in
            do{
                try Auth.auth().signOut()
            } catch{
                print("Error Logout")
            }
            self.presentSignUpChooseScreen()
        }, handlerCancel: { (action) in
            return
        })
       
    }
    @IBOutlet weak var optionsCollView: UICollectionView!
    
    
    
    @IBAction func customerDataButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var signOutButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
//        let usersRef = self.ref.child("armadaCounter")
        Database.database().reference().child("armadaCounter").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String]{
                self.armadaCounterLabel.text = "\(dictionary["armadacount"]! as String) Datas"
           
//        let usersRef = self.ref.child("armadaCounter")
//        let query = usersRef.queryOrdered(byChild: "armadacount")
//               query.observe(.value, with: { (snapshot) in
//                   for child in snapshot.children {
//                        let snap = child as! DataSnapshot
//               let userDict = snap.value as! [String: Any]
//                    self.armadaCounterLabel.text = userDict["armadacount"] as? String
//
//                   }
//               })
            }
            
        }
        
        Database.database().reference().child("driverCounter").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String]{
                self.driverCounterLabel.text = "\(dictionary["drivercount"]! as String) Datas"
        
            }
        }
        
        Database.database().reference().child("scheduleCounter").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String]{
                self.scheduleCounterLabel.text = "\(dictionary["schedulecount"]! as String) Datas"
        
            }
        }
        
        Database.database().reference().child("customerCounter").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String]{
                self.customerCounterLabel.text = "\(dictionary["customercount"]! as String) Datas"
        
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
  

        
//        customerDataButton.alpha = 0
        customerDataButton.layer.cornerRadius = 10
        driverDataButton.layer.cornerRadius = 10
        travelArmadaDataButton.layer.cornerRadius = 10
        travelScheduleDataButton.layer.cornerRadius = 10
        signOutButton.layer.cornerRadius = 10
        travelView.layer.cornerRadius = 10
        customerView.layer.cornerRadius = 10
        driverView.layer.cornerRadius = 10
        travelArmadaView.layer.cornerRadius = 10
        travelScheduleView.layer.cornerRadius = 10
        trackButton.layer.cornerRadius = 10
//        fetchNewest()
      
    
//        let now = Date()
//        let date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: now), minute: Calendar.current.component(.minute, from: now) + 1, second: 0, of: now)!
//        let timer = Timer(fire: date, interval: 60, repeats: true) { _ in
//            self.getCurrentTime()
//        }
        let formatter : DateFormatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
           let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        currentDateLabel.text = myStr
       
       loadAdminProfile()
        setButtonProperties()
        
        
//        for index in 0...10 {
//            Database.database().reference().child("topic").child(subject[index]).observe(.value) { (snapshot) in
//                self.topicCounter[index] = Int(snapshot.childrenCount)
//                subjectCell.lblCounter.text = "\(self.topicCounter[indexPath.row]) topik"
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    
    func getArmadaCounter()
    {
      
        
    }

        
    func loadAdminProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.AdminName.text = dictionary["fullname"] as? String
                if let profileImageURL = dictionary["profileImgURL"] as? String {
                    let url = URL(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        
                        if error != nil {
                            print("error")
                            return
                        }
                    }.resume()
                }
            }
        }
    }
    
    
    func setButtonProperties()
    {
        addNewButton.layer.cornerRadius = 10
        addNewButton.layer.masksToBounds=true
        addNewButton.layer.borderColor = #colorLiteral(red: 0.186602354, green: 0.3931151032, blue: 0.8937475681, alpha: 1)
        addNewButton.layer.borderWidth = 1.5
    }
   
    func fetchNewest() {
        Database.database().reference().child("newest").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
                
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let post = Travel()
                    
                post.topic = dictionary["topic"] as? String
                post.subject = dictionary["subject"] as? String
                post.senderUID = dictionary["senderUID"] as? String
                
                Database.database().reference().child("users").child(post.senderUID!).observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        post.sender = dictionary["fullname"] as? String
                        if let profileImageURL = dictionary["profileImgURL"] as? String {
                            let url = URL(string: profileImageURL)
                            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                                
                                if error != nil {
                                    print("error")
                                    return
                                }
                                DispatchQueue.main.async {
                                    post.senderImg = UIImage(data: data!)
                                }
                            }.resume()
                        }
                    }
                }
                self.travelData.insert(post, at: 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return dataTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
            let dataCell = dataCollectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! optionsCollVCell
            dataCell.chevronButton.isEnabled = false
            
            dataCell.dataNameLabel.text = dataTypes[indexPath.row]
        
        dataCell.dataImage.image = UIImage.init(named: dataTypes[indexPath.row])
        
            //COUNT TOPIC IN SUBJECT COLLECTION VIEW
            for index in 0...3 {
                Database.database().reference().child("data").child(dataTypes[index]).observe(.value) { (snapshot) in
                    self.dataCounter[index] = Int(snapshot.childrenCount)
                    dataCell.dataCounterLabel.text = "\(self.dataCounter[indexPath.row]) data"
                }
            }
        
        dataCell.layer.cornerRadius = 10.0
        
            return dataCell
        
    }

//    func fetchNewest() {
//        Database.database().reference().child("newest").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let post = Newest()
//
//                post.topic = dictionary["topic"] as? String
//                post.subject = dictionary["subject"] as? String
//                post.senderUID = dictionary["senderUID"] as? String
//
//                Database.database().reference().child("users").child(post.senderUID!).observeSingleEvent(of: .value) { (snapshot) in
//                    if let dictionary = snapshot.value as? [String: AnyObject]{
//                        post.sender = dictionary["fullname"] as? String
//                        if let profileImageURL = dictionary["profileImgURL"] as? String {
//                            let url = URL(string: profileImageURL)
//                            URLSession.shared.dataTask(with: url!) { (data, response, error) in
//
//                                if error != nil {
//                                    print("error")
//                                    return
//                                }
//                                DispatchQueue.main.async {
//                                    post.senderImg = UIImage(data: data!)
//                                }
//                            }.resume()
//                        }
//                    }
//                }
//                self.newest.insert(post, at: 0)
//            }
//        }
//    }
    
    
    func showAlert(title: String, message: String, handlerLogout: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionLogout = UIAlertAction(title: "Sign Out", style: .destructive, handler: handlerLogout)
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
        if (segue.identifier == "toCustomerData") {
            let dest = segue.destination as! CustomerDataVC
//            dest.fullName = custNameLabel.text
//            dest.email = custEmailLabel.text
//            dest.passedImg = profileImage.image
//            dest.mobileNumber = mobileNumberLabel.text
        }
        else if (segue.identifier == "toDriverData") {
            let dest = segue.destination as! DriverDataVC
        
    }
        else if (segue.identifier == "toScheduleData") {
            let dest = segue.destination as! ScheduleDataVC
        
    }
        else if (segue.identifier == "toAramdaData") {
            let dest = segue.destination as! ArmadaDataVC
        
    }
    
        
    }
    
    func presentAdminMapScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let adminMapVC = storyboard.instantiateViewController(withIdentifier: "adminMap")
        adminMapVC.modalPresentationStyle = .fullScreen
        self.present(adminMapVC, animated: true, completion: nil)
    }
//    func presentCustomerData(){
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let customerDataVC = storyboard.instantiateViewController(withIdentifier: "customerDataScreen")
//        customerDataVC.modalPresentationStyle = .fullScreen
//        self.present(customerDataVC, animated: true, completion: nil)
//    }

    
//    func getCurrentTime() {
//        currentTimeLabel.text = formatters.string(from: Date())
//    }
    
//    func presentSignUpChooseScreen(){
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let signUpChooseVC = storyboard.instantiateViewController(withIdentifier: "signUpChooseScreen")
//        signUpChooseVC.modalPresentationStyle = .fullScreen
//        self.present(signUpChooseVC, animated: true, completion: nil)
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

extension AdminHomeScreenVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
//        moveAndResizeImage(for: height)
    }
}
