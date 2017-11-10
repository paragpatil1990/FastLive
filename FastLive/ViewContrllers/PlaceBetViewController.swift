//
//  PlaceBetViewController.swift
//  FastLive
//
//  Created by Amrit Singh on 9/19/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit

class PlaceBetViewController: BaseViewController
{

    @IBOutlet weak var view_setBet: UIView!
    
    @IBOutlet weak var txt_rate: UITextField!
    
    @IBOutlet weak var txt_amount: UITextField!
    
    @IBOutlet weak var txt_support: UITextField!
    
    @IBOutlet weak var txt_teams: UITextField!
    
    @IBOutlet weak var txt_setCommission: UITextField!
    
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    @IBOutlet weak var btn_reset: UIButton!
    
    let arrSupport = ["K", "L"]
    let arrCommissio = ["0", "0.05", "0.10", "0.15", "0.20"]
    var arrTeamName:[String]!// = [String]()
    
    var delegate: HomeViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txt_support.loadDropdownData(data: arrSupport, onSelect: didSelectSupport)
        txt_setCommission.loadDropdownData(data: arrCommissio, onSelect: didSelectCommission)
        txt_teams.loadDropdownData(data: arrTeamName, onSelect: didSelectTeams)

    }
    
    func didSelectSupport(selectedText: String)
    {
       txt_support.text = selectedText
    }
    
    func didSelectCommission(selectedText: String)
    {
        txt_setCommission.text = selectedText
    }
    
    func didSelectTeams(selectedText: String)
    {
        txt_teams.text = selectedText
    }
    
    @IBAction func btn_closePressed(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func btn_okPressed(_ sender: UIButton)
    {
        let parameters = ["teamName":txt_teams.text!, "support":txt_support.text!, "rate":txt_rate.text!, "betAmount":txt_amount.text!, "commission":txt_setCommission.text!]
        if delegate == nil
        {
            self.view.removeFromSuperview()
            return
        }
        else
        {            
        }
        delegate.createTxn(parameters: parameters)
    }
    
    @IBAction func btn_ResetPressed(_ sender: UIButton) {
        txt_support.loadDropdownData(data: arrSupport, onSelect: didSelectSupport)
        txt_setCommission.loadDropdownData(data: arrCommissio, onSelect: didSelectCommission)
        txt_teams.loadDropdownData(data: arrTeamName, onSelect: didSelectTeams)
        txt_amount.text = ""
        txt_rate.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


