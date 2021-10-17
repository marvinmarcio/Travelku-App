//
//  FloatingPanelVC.swift
//  Travel
//
//  Created by Marvin Marcio on 24/04/21.
//

import UIKit
import FloatingPanel
import Firebase
import FirebaseDatabase

private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

//class TrendingTopic: NSObject {
//    var topicName: String
//    var senderUID: String
//    var sender: String
//    var senderImg: UIImage?
//    var subject: String
//    var reply: Int
//    
//    init(topicName : String = "", senderUID: String = "", sender: String = "", subject : String = "", reply : Int = 0){
//        self.topicName = topicName
//        self.senderUID = senderUID
//        self.sender = sender
//        self.subject = subject
//        self.reply = reply
//    }
//}

var counter = 0
class FloatingPanelVC: UIViewController, FloatingPanelControllerDelegate {
    @IBOutlet weak var noBookingLabel: UILabel!
    @IBOutlet weak var noBookingLabelBody: UILabel!
    
    @IBOutlet weak var bookingImage: UIImageView!
    
    var bookingArray = [ [String: Any] ]()
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toShowSearchResults", sender: self)
    }
    //
    @IBOutlet weak var currentBookingView: UIView!
    @IBOutlet weak var driverImage: UIImageView!
    @IBAction func trackBtn(_ sender: Any) {
        presentBookingDetailScreen()
    }
    @IBOutlet weak var trackBtn: UIButton!
    
    
    @IBAction func unwindFromProfile (_ sender: UIStoryboardSegue) {
        guard let editProfileVC = sender.source as? CustProfile else { return }
        custNameLabel.text = editProfileVC.custNameLabel.text
        profileImage.image = editProfileVC.profileImage.image
    }
    
    @IBAction func unwindFromSignUpChoose (_ sender: UIStoryboardSegue) {
        guard let editProfileVC = sender.source as? SignUpChooseVC else { return }

    }
    
    @IBOutlet weak var bookedIndicatorLabel: UILabel!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var custNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    let profileButtonView = UIImageView(image: UIImage(named: "profilePictureTemp"))
    
    
    var originCity: String?
    var destCity: String?
    var passengerCount: String?
    var departureDate: String?
    
    var bookedId: String?
    var counterID: String?
    
    let tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      loadProfile()
        transparentNavbar()
        bookingImage.alpha = 0
        noBookingLabel.alpha = 0
        noBookingLabelBody.alpha = 0
        bookedIndicatorLabel.alpha = 0
        currentBookingView.layer.cornerRadius = 10
        driverImage.image = UIImage(named: "profilePictureTemp")
     
        driverImage.layer.borderWidth = 1.0
        driverImage.layer.masksToBounds = false
//        image.layer.borderColor = UIColor.white.cgColor
        driverImage.layer.cornerRadius = driverImage.frame.size.width / 2
        driverImage.clipsToBounds = true
//        addProfileBtn()
//        if bookedIndicatorLabel.text == "Alpha"
//        {
//            currentBookingView.alpha = 0
//            currentBookingView.isUserInteractionEnabled = false
//        }
        if bookedIndicatorLabel.text != "Alpha"
        {
            bookedIndicatorLabel.text = bookedId!
            currentBookingView.alpha = 1
            bookingImage.alpha = 0
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        fetchProfileImage()
       profileImageProperties()
        
//        guard let editProfileVC = sender.source as? FloatingPanelVC else { return }
//        custNameLabel.text = editProfileVC.custNameLabel.text
//        profileImage.image = editProfileVC.profileImage.image
//    }
      
//        if let label = bookedIndicatorLabel
//        {
//            label.text = bookedId!
//            if bookedIndicatorLabel!.text == "Booked"
//            {
//                bookingImage.alpha = 0
//                currentBookingView.alpha = 1
//                //
//            }
//        }
//
        
      

       
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        profileImage.isUserInteractionEnabled = true
//        profileImage.addGestureRecognizer(tapGestureRecognizer)
//

//        profileImageProperties()
      
//            profileImageButton.layer.masksToBounds = false
////            profileImage.layer.borderColor = UIColor.index(ofAccessibilityElement: <#T##Any#>)
//            profileImageButton.layer.cornerRadius = profileImageButton.frame.height/2
//            profileImageButton.clipsToBounds = true
         
        
//        transparentNavbar()

        let fpc = FloatingPanelController(delegate: self)
        fpc.layout = MyFloatingPanelLayout()
        fpc.invalidateLayout()
        
        // Create a new appearance.
        let appearance = SurfaceAppearance()

        // Define shadows
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]

        // Define corner radius and background color
        appearance.cornerRadius = 8.0
     appearance.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Set the new appearance
        fpc.surfaceView.appearance = appearance
        guard let contentVC = storyboard?.instantiateViewController(identifier: "fpc_contents") as? ContentViewControllerExt else
        {
            return
        }
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
    
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
    
    func profileImageProperties()
    {
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func loadProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                self.custNameLabel.text = dictionary["fullname"] as? String
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
    func fetchUserData()
    {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
        
          
                if let dictionary = snapshot.value as? [String: AnyObject]{
                   
                    self.custNameLabel.text = dictionary["fullname"] as? String
                }
        }
    }
    func addProfileBtn() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(profileButtonView)
        profileButtonView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        profileButtonView.clipsToBounds = true
        profileButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileButtonView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            profileButtonView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            profileButtonView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            profileButtonView.widthAnchor.constraint(equalTo: profileButtonView.heightAnchor)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    
        profileButtonView.isUserInteractionEnabled = true
        profileButtonView.addGestureRecognizer(tapGestureRecognizer)
        
        profileButtonView.layer.cornerRadius = profileButtonView.frame.size.width/2
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage == profileImage {
            profileBtnTap()
        }
    }
    
    @objc func profileBtnTap(){
 
   performSegue(withIdentifier: "profileSegue", sender: self)
//        self.performSegue(withIdentifier: "unwindHomeScreen", sender: self)
    }
    
    func fetchProfileImg() {
        if Auth.auth().currentUser == nil {
            self.profileButtonView.image = UIImage(named: "profilePictureTemp")
            return
        }
        else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    if let profileImageURL = dictionary["profileImgURL"] as? String {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!) { (data, response, error) in
                            
                            if error != nil {
                                print("error")
                                return
                            }
                            DispatchQueue.main.async {
                                self.profileButtonView.image = UIImage(data: data!)
                            }
                        }.resume()
                    }
                }
            }
        }
    }
    
    func fetchProfileImage()
    {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
        
          
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
            
//                self.custNameTextField.text = dictionary["fullname"] as? String
                }
        }
    }
    
//    func fetchTrending() {
//        for sub in subject {
//
//            Database.database().reference().child("topic").child("\(sub)").observe(.childAdded) { (snapshot) in
//
//                if let dictionary = snapshot.value as? [String: AnyObject]{
//                    let post = TrendingTopic()
//                    //print("sub saat ini: \(sub)")
//                    post.topicName = (dictionary["topic"] as? String)!
//                    post.subject =  sub
//                    post.senderUID = (dictionary["senderUID"] as? String)!
//                    post.reply = (dictionary["reply"] as? Int)!
//
//                    Database.database().reference().child("users").child(post.senderUID).observeSingleEvent(of: .value) { (snapshot) in
//                        if let dictionary = snapshot.value as? [String: AnyObject]{
//                            post.sender = (dictionary["fullname"] as? String)!
//                            if let profileImageURL = dictionary["profileImgURL"] as? String {
//                                let url = URL(string: profileImageURL)
//                                URLSession.shared.dataTask(with: url!) { (data, response, error) in
//
//                                    if error != nil {
//                                        print("error")
//                                        return
//                                    }
//                                    DispatchQueue.main.async {
//                                        post.senderImg = UIImage(data: data!)!
//                                    }
//                                    self.trendings.insert(post, at: 0)
//                                    DispatchQueue.main.async {
//                                        self.trendings.sort(by: { $0.reply > $1.reply })
//                                        self.lblTrendingSubject.text = self.trendings[0].subject.uppercased()
//                                        self.lblTrendingTopic.text = self.trendings[0].topicName
//                                        self.lblTrendingSender.text = self.trendings[0].sender
//                                        self.lblTrendingReply.text = "\(self.trendings[0].reply) Balasan"
//                                        self.imgTrendingProfile.image = self.trendings[0].senderImg
//                                    }
//                                }.resume()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
       
        fetchProfileImage()
    }
    func presentSignInScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "loginScreen")
        signInVC.modalPresentationStyle = .fullScreen
        self.present(signInVC, animated: true, completion: nil)
    }
    

    func transparentNavbar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func unwindLogout(_ sender: UIStoryboardSegue) {}

    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.profileButtonView.alpha = show ? 1.0 : 0.0
        }
    }
    func presentBookingDetailScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ticketVC = storyboard.instantiateViewController(withIdentifier: "custMapTracking")
        ticketVC.modalPresentationStyle = .fullScreen
        self.present(ticketVC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    

    
    //MARK: Setup Tap untuk trending view
    
 
}
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 150.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
