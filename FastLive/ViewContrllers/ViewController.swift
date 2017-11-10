//
//  ViewController.swift
//  FastFive
//
//  Created by Amrit Singh on 9/6/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit

func isUserExist() -> Bool
{
    return UserDefaults.standard.object(forKey: defaultsKeys.accessToken) != nil
}

class ViewController: UIViewController, LoginViewControllerDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.perform(#selector(ViewController.addNextVC), with: self, afterDelay: 1.0)

    }
    
    func addNextVC()
    {
        if isUserExist()
        {
            setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.MainNavigation)
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateInitialViewController()

            
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let navSignIn = storyBoard.instantiateViewController(withIdentifier: "NavSignIn")
            //self.present(vc!, animated: true, completion: nil)
        }
        else
        {
            setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SignInNavigation)

//            let storyboard = UIStoryboard(name: Storyboard.Main, bundle: nil)
//            let rootController = storyboard.instantiateViewController(withIdentifier: Identifier.SignInNavigation) as! UINavigationController
//            let login = rootController.topViewController as! LoginViewController
//            login.delegate = self
//            self.present(rootController, animated: true, completion: nil)
        }
    }

    func login() {
        setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.MainNavigation)
    }

    func logout() {
        setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SignInNavigation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

