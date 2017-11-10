//
//  ViewController.swift
//  MatchpointGPS
//
//  Created by Amrit Singh on 8/10/17.
//  Copyright © 2017 foxsolution. All rights reserved.
//

import UIKit
//import IQKeyboardManagerSwift

struct defaultsKeys {
    static let accessToken = "accessToken"
    static let daysLeft = "daysLeft"
    static let isCommentry = "isCommentry"
    static let lastLoginOn = "lastLoginOn"
    static let mobile = "mobile"
    static let name = "name"
    static let roleId = "roleId"
    static let roleName = "roleName"
    static let status = "status"
    static let userId = "userId"
    static let username = "username"
    static let arrsavedmatchid = "arrsavedmatchid"
}

enum ButtonType {
    case left
    case right
}

class BaseViewController: UIViewController, MenuViewControllerDelegate //, SlideMenuDelegate
{
    let modelName = UIDevice.current.model

    var presentWindow : UIWindow!
    var btnBack : UIButton!
    var backButton : UIBarButtonItem!
    var btnShowMenu : UIButton!
    var menuButton : UIBarButtonItem!
    var btnBell : UIButton!
    var bellButton : UIBarButtonItem!
    var btnHome : UIButton!
    var homeButton : UIBarButtonItem!
    var btnClose : UIButton!
    var closeButton : UIBarButtonItem!
    
    var rightsBarButtons : [UIBarButtonItem]!
    
    @IBOutlet weak var btn_forgotpassword: UIButton!
    @IBOutlet weak var btn_helpline: UIButton!
    
//    var returnKeyHandler:IQKeyboardReturnKeyHandler!
    let defaults = UserDefaults.standard
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setBackbutton()
        
        presentWindow = UIApplication.shared.windows.first

       // IQKeyboardManager.sharedManager().disabledToolbarClasses.append(BaseViewController.self)

//        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10;
//        
//        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)

        bellItem()
        menuItem()
        homeItem()
        closeItem()
        backItem()
    }

    func setNavigationBar()
    {
    
        self.navigationController?.navigationBar.setBackgroundImage (UIImage(color: #colorLiteral(red: 0.2906709313, green: 0.5265485048, blue: 0.9083524942, alpha: 1)), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(color: UIColor.lightGray)
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
        
        //let logo = UIImage(named: "logo.png")
//        let imageView = UIImageView(image:logo)
//        imageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = imageView
    }
    
    func setTransperntNavigationBar()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    
    func bellItem()
    {
        btnBell = UIButton(type: .custom)
        btnBell.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnBell.setImage(UIImage(named: "icon-NoAudio"), for: .normal)
        btnBell.imageView?.contentMode = .scaleAspectFit
        btnBell.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnBell.addTarget(self, action: #selector(BaseViewController.onBellButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        btnBell.tag = 11

        bellButton = UIBarButtonItem(customView: btnBell)
        bellButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    
    func homeItem()
    {
        btnHome = UIButton(type: .custom)
        btnHome.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnHome.setImage(UIImage(named: "icon-home"), for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        btnHome.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnHome.addTarget(self, action: #selector(BaseViewController.onHomeButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        homeButton = UIBarButtonItem(customView: btnHome)
        homeButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    
    func menuItem()
    {
        btnShowMenu = UIButton(type: .custom)
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnShowMenu.setImage(UIImage.defaultMenuImage(), for: .normal)
        btnShowMenu.imageView?.contentMode = .scaleAspectFit
        btnShowMenu.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        menuButton = UIBarButtonItem(customView: btnShowMenu)
        menuButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    
    func closeItem()
    {
        btnClose = UIButton(type: .custom)
        btnClose.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnClose.setImage(UIImage.defaultCloseImage(), for: .normal)
        btnClose.imageView?.contentMode = .scaleAspectFit
        btnClose.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnClose.addTarget(self, action: #selector(BaseViewController.onCloseButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        closeButton = UIBarButtonItem(customView: btnClose)
        closeButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    
    func backItem()
    {
        btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        btnBack.setImage(UIImage(named: "icon-back"), for: .normal)
        btnBack.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnBack.addTarget(self, action: #selector(BaseViewController.onBackButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        backButton = UIBarButtonItem(customView: btnBack)
        backButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    
    func addBarButtonWith(title: String, target: AnyObject, selector: Selector, buttonType:ButtonType)
    {
        let customBarItem : UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        //self.navigationItem.rightBarButtonItem = customBarItem;
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        switch buttonType
        {
        case .left:
            self.navigationItem.leftBarButtonItem = customBarItem;
            break
        case .right:
            self.navigationItem.rightBarButtonItem = customBarItem;
            break
        }
    }

    func addRightBarButtonItems(items:[UIBarButtonItem])
    {
        self.navigationItem.rightBarButtonItems = items //[menuButton, bellButton]
    }
   
    func addMenubutton()
    {
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    
    func addBackbutton()
    {
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    func setBackbutton()
    {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func addClosebutton(buttonType:ButtonType)
    {
        switch buttonType
        {
        case .left:
            self.navigationItem.leftBarButtonItem = closeButton;
            break
        case .right:
            self.navigationItem.rightBarButtonItem = closeButton;
            break
        }
    }
    
    func setAppSession(data:[String:Any])
    {
        setUserDefaults(value: data[defaultsKeys.accessToken] ?? 0, key: defaultsKeys.accessToken)
        setUserDefaults(value: data[defaultsKeys.daysLeft] ?? "", key: defaultsKeys.daysLeft)
        setUserDefaults(value: data[defaultsKeys.isCommentry] ?? "", key: defaultsKeys.isCommentry)
        setUserDefaults(value: data[defaultsKeys.lastLoginOn] ?? "", key: defaultsKeys.lastLoginOn)
        setUserDefaults(value: data[defaultsKeys.mobile] ?? "en", key: defaultsKeys.mobile)
        setUserDefaults(value: data[defaultsKeys.name] ?? 0, key: defaultsKeys.name)
        setUserDefaults(value: data[defaultsKeys.roleId] ?? 0, key: defaultsKeys.roleId)
        setUserDefaults(value: data[defaultsKeys.roleName] ?? 0, key: defaultsKeys.roleName)
        setUserDefaults(value: data[defaultsKeys.status] ?? 0, key: defaultsKeys.status)
        setUserDefaults(value: data[defaultsKeys.userId] ?? 0, key: defaultsKeys.userId)
        setUserDefaults(value: data[defaultsKeys.username] ?? 0, key: defaultsKeys.username)
    }
    
    func removeAppSession()
    {
        UserDefaults.standard.removeObject(forKey: defaultsKeys.accessToken)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.daysLeft)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.isCommentry)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.lastLoginOn)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.mobile)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.name)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.roleId)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.roleName)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.status)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.userId)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.username)
        UserDefaults.standard.removeObject(forKey: defaultsKeys.arrsavedmatchid)
    }
    
    func setUserDefaults(value:Any, key: String)
    {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getUserDefaults(key: String) -> Any
    {
        return UserDefaults.standard.object(forKey: key) ?? ""
    }

    func removeUserDefaults(key: String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    func onBackButtonPressed(_ sender : UIButton)
    {
    }
    
    func onCloseButtonPressed(_ sender : UIButton)
    {
    }
    
    func onHomeButtonPressed(_ sender : UIButton)
    {
    }
    
    func onBellButtonPressed(_ sender : UIButton)
    {
        btnBell.alpha = 0.0;
        
        if (sender.tag == 11)
        {
            // To Hide Menu If it already there
            sender.tag = 22;
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.btnBell.setImage(UIImage(named: "icon-Audio"), for: .normal)
                self.btnBell.alpha = 1.0
            }, completion: { (finished) -> Void in
            })
        }
        else
        {
            sender.tag = 11;
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                self.btnBell.setImage(UIImage(named: "icon-NoAudio"), for: .normal)
                self.btnBell.alpha = 1.0
            }, completion: { (finished) -> Void in
            })
        }
       
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton)
    {
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            //            viewMenuBack.backgroundColor = UIColor.clearColor()
            
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            return
        }
        sender.isEnabled = false
        sender.tag = 10
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.showsShadows = false
        menuVC.view.backgroundColor = UIColor.clear;
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.bounds.size.height);
        
        UIView.animate(withDuration: 0.5, animations:  { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.bounds.size.height);
            sender.isEnabled = true
        }, completion: { (finished) -> Void in
            menuVC.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            
        })
        
    }

    
//    func onSlideMenuButtonPressed(_ sender : UIButton)
//    {
//        btnShowMenu.alpha = 0.0;
//        if (sender.tag == 10)
//        {
//            // To Hide Menu If it already there
//            //slideMenuItemSelectedAtIndex(-1);
//            sender.tag = 0;
//            
//            let viewMenuBack : UIView = view.subviews.last!
//            //            viewMenuBack.backgroundColor = UIColor.clearColor()
//            
//            UIView.animate(withDuration: 1.0, animations: {() -> Void in
//                var frameMenu : CGRect = viewMenuBack.frame
//                frameMenu.origin.x = 2 * UIScreen.main.bounds.size.width
//                viewMenuBack.frame = frameMenu
//                viewMenuBack.layoutIfNeeded()
//                viewMenuBack.backgroundColor = UIColor.clear
//                self.btnShowMenu.setImage(UIImage.defaultMenuImage(), for: .normal)
//                self.btnShowMenu.alpha = 1.0
//            }, completion: { (finished) -> Void in
//                viewMenuBack.removeFromSuperview()
//            })
//            return
//        }
//        
//        sender.isEnabled = false
//        sender.tag = 10
//        let menuVC : SlideMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SlideMenuViewController") as! SlideMenuViewController
//        menuVC.showsShadows = false
//        menuVC.view.backgroundColor = UIColor.clear;
//        menuVC.btnMenu = sender
//        menuVC.delegate = self 
//        self.view.addSubview(menuVC.view)
//        self.addChildViewController(menuVC)
//        menuVC.view.layoutIfNeeded()
//        
//        menuVC.view.frame=CGRect(x: 2*UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.bounds.size.height);
//        
//        UIView.animate(withDuration: 1.0, animations:  { () -> Void in
//            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.view.bounds.size.height);
//            sender.isEnabled = true
//            
//            self.btnShowMenu.setImage(UIImage.defaultCloseImage(), for: .normal)
//            self.btnShowMenu.alpha = 1.0
//
//        }, completion: { (finished) -> Void in
//            menuVC.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
//        })
//        
//    }
    func slideMenuItemSelectedAtIndexPatah(_ indexpath: IndexPath)
    {
//        let topViewController : UIViewController = self.navigationController!.topViewController!
//        print("View Controller is : \(topViewController) \n", terminator: "")
        switch (indexpath.section)
        {
        case 0:
            switch(indexpath.row)
            {
            case 0:
                
                print("Dashboard\n", terminator: "")

                break
            case 1:
                print("About us\n", terminator: "")
              
                break
            case 2:
                print("Terms & conditions\n", terminator: "")

                break
            case 3:
                print("Logout\n", terminator: "")
                
                let alert = UIAlertController(title: "", message: "Are you sure you want to logout", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        self.removeAppSession()
                        setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SignInNavigation)
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                break
            case 4:
                print("Play\n", terminator: "")
                break
            default:
                print("default\n", terminator: "")
            }
            break
        case 1:
            switch(indexpath.row)
            {
            case 0:
              
                break
            case 1:
               
                break
            case 2:
               
                break
            case 3:
               
                break
            default:
                print("default\n", terminator: "")
            }
            break
        default:
            print("default\n", terminator: "")
        }
    }

    func slideMenuItemSelectedAtIndex(_ index: Int)
    {
        btnShowMenu.alpha = 0.0;
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.btnShowMenu.setImage(UIImage.defaultMenuImage(), for: .normal)
            self.btnShowMenu.alpha = 1.0
        }, completion: { (finished) -> Void in
        })

        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index)
        {
        case 0:
            print("My Profile\n", terminator: "")
            
            //            //            let prefs:UserDefaults = UserDefaults.standard
            //            let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
            //            if (isLoggedIn != 1)
            //            {
            //                print("not Logon")
            //                self.openViewControllerBasedOnIdentifier("login")
            //            }
            //            else
            //            {
            //
            //                self.openViewControllerBasedOnIdentifier("profile")
            //                print("Logon")
            //
            //            }
            
            break
        case 1:
            
            print("Vhicle list\n", terminator: "")
            //
            //            //            let prefs:UserDefaults = UserDefaults.standard
            //            let isLoggedIn:Int = prefs.integer(forKey: "ISLOGGEDIN") as Int
            //
            //            if (isLoggedIn != 1)
            //            {
            //                print("not Logon")
            //                self.openViewControllerBasedOnIdentifier("login")
            //
            //            }
            //            else
            //            {
            //                print("Logon")
            //                self.openViewControllerBasedOnIdentifier("profile")
            //
            //            }
            
            
            break
        case 2:
            print("Driver list\n", terminator: "")
            break
        case 3:
            print("Reports list\n", terminator: "")
            break
        case 4:
            print("Aletrs / Alaram\n", terminator: "")
    
            //openViewControllerBasedOn(storyboard: Storyboard.AlertModeStoryboard, identifier: Identifier.SelectAlertModeViewController)
            
            break
        case 5:
            print("User Profile\n", terminator: "")
            break
        case 6:
            print("Support\n", terminator: "")
            break
        case 7:
            print("Language\n", terminator: "")
            
            //openViewControllerBasedOn(storyboard: Storyboard.SignInStoryboard, identifier: Identifier.LanguageViewController)
            
//            let storyboard = UIStoryboard(name: Storyboard.SignInStoryboard, bundle: nil)
//            let rootController = storyboard.instantiateViewController(withIdentifier: Identifier.LanguageViewController)
//            let nav = UINavigationController(rootViewController: rootController)
//            self.present(nav, animated: true, completion: nil)
            break
        case 8:
            print("Logout\n", terminator: "")
            
            
            
//            let popup : LogoutView  = LogoutView(frame: self.navigationController!.view.bounds)
//            popup.delegate = self
//            popup.show(view: self.navigationController!.view, strMessage: "Successfully Logged out", complete: { () in
//            })
            
//            let popup : LogoutView  = LogoutView(frame: self.view.bounds)
//            popup.show(view: self.view, strMessage: "", complete: { () in
//            })
            
            let storyboard = UIStoryboard(name: Storyboard.SignInStoryboard, bundle: nil)
            let rootController = storyboard.instantiateViewController(withIdentifier: Identifier.SignInNavigation) as! UINavigationController
            if let window = presentWindow
            {
                window.rootViewController = rootController
                window.makeKeyAndVisible()
            }
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func openViewControllerBasedOn(storyboard:String, identifier:String)
    {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        let topViewController : UIViewController = self.navigationController!.topViewController!
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        }
        else{
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//extension BaseViewController: LogoutViewDelegate
//{
//    func didLogoutViewClick(logoutview: LogoutView)
//    {
//        UserDefaults.standard.removeObject(forKey: defaultsKeys.user)
//        UserDefaults.standard.removeObject(forKey: defaultsKeys.profile_pic)
//        UserDefaults.standard.removeObject(forKey: defaultsKeys.is_agreement_shown)
//        UserDefaults.standard.removeObject(forKey: defaultsKeys.lang_code)
//        UserDefaults.standard.removeObject(forKey: defaultsKeys.token)
//        UserDefaults.standard.removeObject(forKey: defaultsKeys.customer_name)
//        setInitialRootViewContoller(storyboardName: Storyboard.SignInStoryboard)
//    }
//}




