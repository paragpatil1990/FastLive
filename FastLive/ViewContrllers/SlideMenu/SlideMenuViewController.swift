//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol SlideMenuDelegate:class
{
    @objc optional func slideMenuItemSelectedAtIndex(_ index : Int)
    //@objc optional func slideMenuItemSelectedAtIndexPatah(_ indexpath : IndexPath)
}

private let DrawerDefaultShadowRadius: CGFloat = 10.0
private let DrawerDefaultShadowOpacity: Float = 0.8


class SlideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
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
    var arrayMenu = [String]()

    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!
    
    /**
    *  Delegate of the MenuVC
    */
    
    weak var delegate: SlideMenuDelegate?
    
    /*By default, this is set to YES.
    */
    open var showsShadows: Bool = true {
        didSet {
            self.updateShadowForCenterView()
        }
    }
    
    var menuindex = -1
    
    open var shadowRadius = DrawerDefaultShadowRadius
    open var shadowOpacity = DrawerDefaultShadowOpacity
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblMenuOptions.tableFooterView = UIView()
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
        arrayMenu = ["My Profile", "Vehicle List", "Driver List", "Trips", "Reports", "Alerts Modes", "User Profiles", "Support", "Logout"]
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!)
    {
        btnMenu.tag = 0
        
//        if (self.delegate != nil)
//        {
//            var index = Int(button.tag)
//            if(button == self.btnCloseMenuOverlay)
//            {
//                index = -1
//            }
            //delegate?.slideMenuItemSelectedAtIndex?(index)
//        }
        
        menuindex = Int(button.tag)
        if(button == self.btnCloseMenuOverlay){
            menuindex = -1
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
        UIView.animate(withDuration: 1.0, animations:
            { () -> Void in
            self.view.frame = CGRect(x: 2*UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                
                if (self.delegate != nil)
                {
                    self.delegate?.slideMenuItemSelectedAtIndex?(self.menuindex)
                }
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
//        cell.layoutMargins = UIEdgeInsets.zero
//        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        lblTitle.textColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
//        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
//            imgIcon.image = UIImage(named: arrayMenuOptions2[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenu[indexPath.row]
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        btnMenu.tag = 0
        
        menuindex = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath)
        let lblTitle : UILabel = cell!.contentView.viewWithTag(101) as! UILabel
        lblTitle.textColor = #colorLiteral(red: 0.9397750497, green: 0.4646142125, blue: 0.1712039113, alpha: 1)
        
//        if (self.delegate != nil)
//        {
//            delegate?.slideMenuItemSelectedAtIndexPatah?(indexPath)
//        }
        self.closeAnimation()
        
//        let btn = UIButton(type: UIButtonType.Custom)
//        btn.tag = indexPath.row
//        self.onCloseMenuClick(btn)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayMenu.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//            let sectionHeaderView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
//        sectionHeaderView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            return sectionHeaderView;
//
//            }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 44;
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return UITableViewAutomaticDimension
        let height = tableView.frame.size.height/arrayMenu.count-10
        return height
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return UITableViewAutomaticDimension
//    }
}
