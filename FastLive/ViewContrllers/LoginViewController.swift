//
//  LoginViewController.swift
//  MatchpointGPS
//
//  Created by Amrit Singh on 8/11/17.
//  Copyright © 2017 foxsolution. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate:class
{
    func login()
}

class LoginViewController: BaseViewController
{

    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var txt_email: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_password: SkyFloatingLabelTextField!

    var delegate:LoginViewControllerDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setNavigationBar()
        self.title = "Sign In"
        
        txt_email.updateLengthValidationMsg("Enter email")
        txt_password.updateLengthValidationMsg("Enter password")
        
        btn_signin.setShadow()
        
        txt_email.text = "abhishek"
        txt_password.text = "12345"

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
       
        //self.navigationController?.isNavigationBarHidden = true
        //UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBAction
    @IBAction func button_signin_pressed(_ sender: UIButton)
    {
        if (txt_email.validate() && txt_password.validate())
        {
           // _ = txt_email.resignFirstResponder()
            
            let parameters = ["username":txt_email.text!, "password":txt_password.text!, "ipAddress": "127.1.1.0"] as [String : Any]
            
            let network = NetworkCall()

            network.headers["appKey"] = "web-8765437-atkey"
            network.apicall(api: "login/userLogin", method: .post, parameters: parameters, isHud: true, completion: { response in
                    
                    if network.is_success
                    {
                        self.setAppSession(data: network.data as! [String : Any])
                        setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.MainNavigation)

//                        self.dismiss(animated: true, completion: { isComlet in
//                            self.setAppSession(data: NetworkCall.sharedInstance.data as! [String : Any])
//                            self.delegate?.login()
//                        })
                    }
                    else
                    {
                        self.presentWindow.makeToast(message: network.response_message)
                    }
                })
            }
            else
            {
                //_ = txt_mobileno.resignFirstResponder()
                self.presentWindow.makeToast(message: "Please enter Username / Password")
            }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == Segue.otp)
        {
            
        }
    }

}

