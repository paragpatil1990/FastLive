//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate
{
    func slideMenuItemSelectedAtIndex(_ index : Int)
    func slideMenuItemSelectedAtIndexPatah(_ indexpath : IndexPath)
}
  
private let DrawerDefaultShadowRadius: CGFloat = 10.0
private let DrawerDefaultShadowOpacity: Float = 0.8


class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var  profileView : UIView!
    @IBOutlet var  userImage : UIImageView!    
    @IBOutlet var userImage_Height: NSLayoutConstraint!
    @IBOutlet var  userName_Lbl : UILabel!
    @IBOutlet var  email_Lbl : UILabel!
    
    @IBOutlet var profile_Btn: UIButton!
    /**
    *  Array to display menu options
    */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions1 = [Dictionary<String,String>]()
    var arrayMenuOptions2 = [Dictionary<String,String>]()

    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : MenuViewControllerDelegate?
    
    /*By default, this is set to YES.
    */
    open var showsShadows: Bool = true {
        didSet {
            self.updateShadowForCenterView()
        }
    }
    open var shadowRadius = DrawerDefaultShadowRadius
    open var shadowOpacity = DrawerDefaultShadowOpacity
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        userImage.layer.cornerRadius = userImage_Height.constant/2
        let prefs:UserDefaults = UserDefaults.standard
        if let loggedInUser:NSDictionary = prefs.value(forKey: "USER") as? NSDictionary
        {
            print(loggedInUser.value(forKey: "userEmail")!)
            let isRegistered:Int = prefs.integer(forKey: "ISREGISTERED") as Int
            if (isRegistered == 1)
            {
                let email = loggedInUser.value(forKey: "userEmail") as? String
                email_Lbl.text = email
                let fname = loggedInUser.value(forKey: "userFName") as? String
                let lname = loggedInUser.value(forKey: "userLName") as? String
                userName_Lbl.text = fname! + lname!
            }
            else
            {
                let email = loggedInUser.value(forKey: "userEmail") as? String
                email_Lbl.text = email
                userName_Lbl.text = loggedInUser.value(forKey: "userName") as? String
//                if let img = prefs.value(forKey: "userAvatar")
//                {
//                    userImage.downloadedFromlink(img as! String)
//                }
            }
            
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    fileprivate func updateShadowForCenterView()
    {
        if self.showsShadows {
            self.view.layer.masksToBounds = false
            self.view.layer.shadowRadius = shadowRadius
            self.view.layer.shadowOpacity = shadowOpacity
            
            /** In the event this gets called a lot, we won't update the shadowPath
             unless it needs to be updated (like during rotation) */
            if let shadowPath = view.layer.shadowPath {
                let currentPath = shadowPath.boundingBoxOfPath
                
                if currentPath.equalTo(view.bounds) == false {
                    view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
                }
            } else {
                self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
            }
        } else if self.view.layer.shadowPath != nil {
            self.view.layer.shadowRadius = 0.0
            self.view.layer.shadowOpacity = 0.0
            self.view.layer.shadowPath = nil
            self.view.layer.masksToBounds = true
        }
    }

    
    func updateArrayMenuOptions()
    {
        arrayMenuOptions1.append(["title":"Dashboard", "icon":"jobSearch_grey"])
        arrayMenuOptions1.append(["title":"About Us", "icon":"myProfile"])
        arrayMenuOptions1.append(["title":"Terms & conditions", "icon":"appliedJobs"])
        arrayMenuOptions1.append(["title":"Logout", "icon":"uploadResume_gray"])
       
//        arrayMenuOptions2.append(["title":"Terms & conditions", "icon":"term&Conditions"])
//        arrayMenuOptions2.append(["title":"Rate us", "icon":"rateUs"])
//        arrayMenuOptions2.append(["title":"About us", "icon":"aboutUs"])
//        arrayMenuOptions2.append(["title":"Promote this App", "icon":"promoteThisApp"])

        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!)
    {
        btnMenu.tag = 0
        
        if (self.delegate != nil)
        {
            var index = button.tag
            if(button == self.btnCloseMenuOverlay)
            {
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        self.closeAnimation()
        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.frame = CGRect(x: -UIScreen.mainScreen().bounds.size.width, y: 0, width: UIScreen.mainScreen().bounds.size.width,height: UIScreen.mainScreen().bounds.size.height)
//            self.view.layoutIfNeeded()
//            self.view.backgroundColor = UIColor.clearColor()
//            }, completion: { (finished) -> Void in
//                self.view.removeFromSuperview()
//                self.removeFromParentViewController()
//        })
    }
    func closeAnimation()
    {
        UIView.animate(withDuration: 0.3, animations:
            { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    @IBAction func profile_BtnClick(_ sender: UIButton)
    {
        sender.tag = 0
        self.onCloseMenuClick(sender)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        if (indexPath.section == 0)
        {
            imgIcon.image = UIImage(named: arrayMenuOptions1[indexPath.row]["icon"]!)
            lblTitle.text = arrayMenuOptions1[indexPath.row]["title"]!
        }
        else
        {
            imgIcon.image = UIImage(named: arrayMenuOptions2[indexPath.row]["icon"]!)
            lblTitle.text = arrayMenuOptions2[indexPath.row]["title"]!
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        btnMenu.tag = 0

        if (self.delegate != nil)
        {
            delegate?.slideMenuItemSelectedAtIndexPatah(indexPath)
        }
        self.closeAnimation()
        
//        let btn = UIButton(type: UIButtonType.Custom)
//        btn.tag = indexPath.row
//        self.onCloseMenuClick(btn)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0)
        {
            return arrayMenuOptions1.count
        }
        else
        {
            return arrayMenuOptions2.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1
        {
            let sectionHeaderView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 8+30+1))
            let headerLabel : UILabel = UILabel(frame: CGRect(x: sectionHeaderView.frame.origin.x+8,y: 8, width: sectionHeaderView.frame.size.width, height: 30))
            headerLabel.textColor = UIColor.darkGray
            headerLabel.text = "Communicate";
            headerLabel.font = UIFont.systemFont(ofSize: 16)
            sectionHeaderView.addSubview(headerLabel)

            let line_Lbl : UILabel = UILabel(frame: CGRect(x: 0,y: 0, width: sectionHeaderView.frame.size.width, height: 1))
            line_Lbl.backgroundColor = UIColor.lightGray
            sectionHeaderView.addSubview(line_Lbl)
            
            return sectionHeaderView;

        }
        else
        {
            return nil;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 1)
        {
            return 8+30+1+8;   //set height according to row or section , whatever you want to do!
        }
        else
        {
            return 0;   //set height according to row or section , whatever you want to do!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

}
