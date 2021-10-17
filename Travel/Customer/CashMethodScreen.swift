//
//  CashMethodScreen.swift
//  Travel
//
//  Created by Marvin Marcio on 11/07/21.
//

import UIKit

class CashMethodScreen: UIViewController {
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmBtnPressed(_ sender: Any) {
        showAlert(title: "Order details and payment", message: "Please check order details and confirm payment", handlerConfirm: { (action) in
          
            self.presentTicketScreen()
        }, handlerCancel: { (action) in
            return
        })

    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    func showAlert(title: String, message: String, handlerConfirm: ((UIAlertAction) -> Void)?, handlerCancel: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default, handler: handlerCancel)
        let actionConfirm = UIAlertAction(title: "Confirm", style: .destructive, handler: handlerConfirm)
        alert.addAction(action)
        alert.addAction(actionConfirm)
        self.present(alert, animated: true, completion: nil)
    }

    func presentTicketScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ticketVC = storyboard.instantiateViewController(withIdentifier: "ticketScreen")
        ticketVC.modalPresentationStyle = .fullScreen
        self.present(ticketVC, animated: true, completion: nil)
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
