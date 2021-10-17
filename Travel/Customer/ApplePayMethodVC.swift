//
//  ApplePayMethodVC.swift
//  Travel
//
//  Created by Marvin Marcio on 13/07/21.
//

import UIKit
import PassKit

class ApplePayMethodVC: UIViewController {
 
    @IBOutlet weak var payBtn: UIButton!
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private var paymentRequest : PKPaymentRequest =
        {
            let request = PKPaymentRequest()
            request.merchantIdentifier = "merchant.travelku"
            request.supportedNetworks = [.quicPay, .masterCard, .visa]
            request.supportedCountries = ["ID", "US"]
            request.merchantCapabilities = .capability3DS
            request.countryCode = "ID"
            request.currencyCode = "IDR"
            
            request.paymentSummaryItems = [PKPaymentSummaryItem(label: "2 travel seats", amount: 250000)]
            return request
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payBtn.layer.cornerRadius = 10
        self.payBtn.addTarget(self, action: #selector(tapForPay), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func tapForPay()
    {
        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil
        {
            controller!.delegate = self
            present(controller!, animated: true, completion: nil)
          
        }
        
        
    }
    func presentTicketScreen(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ticketVC = storyboard.instantiateViewController(withIdentifier: "applePayTicketScreen")
        ticketVC.modalPresentationStyle = .fullScreen
        self.present(ticketVC, animated: true, completion: nil)
    }
  
}



//MARK: - Extension code
extension ApplePayMethodVC : PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
    
        controller.dismiss(animated: true, completion: nil)
        presentTicketScreen()
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
   
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
       
  
    }
    
}
