//
//  TicketViewVC.swift
//  Travel
//
//  Created by Marvin Marcio on 07/07/21.
//

import UIKit

class TicketViewVC: UIViewController {
    @IBAction func homeButton(_ sender: Any) {
        showAlert(title: "Go to home screen?", message: "Screenshot the e-ticket for later use", handlerConfirm: { (action) in
          
            self.presentHomeScreen()
        }, handlerCancel: { (action) in
            return
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
   
    
    func showAlert(title: String, message: String, handlerConfirm: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionConfirm = UIAlertAction(title: "Confirm", style: .destructive, handler: handlerConfirm)
        alert.addAction(action)
        alert.addAction(actionConfirm)
        self.present(alert, animated: true, completion: nil)
    }
 
    
    func presentHomeScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreenVC = storyboard.instantiateViewController(withIdentifier: "homeScreen")
        homeScreenVC.modalPresentationStyle = .fullScreen
        self.present(homeScreenVC, animated: true, completion: nil)
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
