//
//  HomeViewController.swift
//  FastFive
//
//  Created by Amrit Singh on 9/10/17.
//  Copyright © 2017 iphoneSolution. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: BaseViewController {

    @IBOutlet weak var view_over: UIView!
    @IBOutlet weak var lbl_sessionDesc: UILabel!
    @IBOutlet weak var lbl_sessionValue: UILabel!
    @IBOutlet weak var view_run: UIView!
    @IBOutlet weak var lbl_commentry: UILabel!
    @IBOutlet weak var lbl_commentryTwo: UILabel!
    
    @IBOutlet weak var lbl_heading: UILabel!
    
    @IBOutlet weak var view_team: UIView!
    @IBOutlet weak var lbl_team1_name: UILabel!
    @IBOutlet weak var lbl_team2_name: UILabel!
    @IBOutlet weak var lbl_team1bet: UILabel!
    @IBOutlet weak var lbl_team2bet: UILabel!
    
    @IBOutlet weak var view_matchRateListBg: UIView!
    @IBOutlet weak var btn_matchRateList_delete: UIButton!
    @IBOutlet weak var table_matchRateList: UITableView!
    @IBOutlet weak var table_matchRateList_height: NSLayoutConstraint!
    
    @IBOutlet weak var table_matchScoreList: UITableView!
    @IBOutlet weak var table_matchScoreList_height: NSLayoutConstraint!
    
    @IBOutlet weak var table_transaction: UITableView!
    @IBOutlet weak var table_transaction_height: NSLayoutConstraint!
    
    @IBOutlet weak var table_matech: UITableView!
    @IBOutlet weak var table_matech_height: NSLayoutConstraint!
    
    @IBOutlet weak var btn_refresh: UIButton!
    
    @IBOutlet weak var btn_placeBet: UIButton!
    
    
    var arrMatchRateList = [Any]()
    var arrMatchScoreList = [Any]()
    var arrTeamMatches = [Match]()
    var arrMatches = [Match]()
    var arrUserTxnSum = [UserTxnSum]()
    var arrUserTxnList = [UserTxnList]()
    var arrTeamName:[String] = [String]()
    
    var placeBetVC :PlaceBetViewController!

    var arrSaveMatchId = [Int]() //= [String]()
    var arrTempSaveMatchId = [Int]() //= [String]()
    
    
    var webTimer: Timer!
    
    var player : AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //addBarButtonWith(title: "Logout", target: self, selector: #selector(btn_logoutClick(_:)), buttonType: .right)

        addMenubutton()
        addRightBarButtonItems(items: [bellButton])
        
        self.setNavigationBar()
        self.title = "Fast Live"

        btn_placeBet.titleLabel?.numberOfLines = 0
        btn_placeBet.titleLabel?.textAlignment = .center
        btn_placeBet.setShadow()

        view_matchRateListBg.isHidden = true
        //btn_matchRateList_delete.isHidden = true
        
        table_matchRateList_height.constant = 0
        table_matchScoreList_height.constant = 0
        table_transaction_height.constant = 0

        table_matchRateList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        table_matchScoreList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

        table_transaction.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

        table_matech.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        if let arr = UserDefaults.standard.object(forKey: defaultsKeys.arrsavedmatchid) as? [Any]
        {
            arrSaveMatchId = arr as! [Int]
        }
        arrTempSaveMatchId = arrSaveMatchId
        
        if arrSaveMatchId.count > 0
        {
            let stringArray = arrSaveMatchId.flatMap { String($0) }
            let matchIdStr = stringArray.joined(separator: ",")
            getMatchScores(matchIdStr: matchIdStr)
        }
        
        getMatchDetails()
        
        getMatchList()
        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        if self.webTimer == nil
        {
            self.webTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.getMatchDetails), userInfo: nil, repeats: true)
        }
    }
    
    override func onBellButtonPressed(_ sender: UIButton) {
        super.onBellButtonPressed(sender)
    }
    func btn_logoutClick(_ sender : UIButton)
    {
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
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if arrMatchRateList.count > 0
        {
            table_matchRateList_height.constant = table_matchRateList.contentSize.height
        }

        if arrMatchScoreList.count > 0
        {
            table_matchScoreList_height.constant = table_matchScoreList.contentSize.height
        }
        
        if arrUserTxnSum.count > 0
        {
            table_transaction_height.constant = table_transaction.contentSize.height
        }
        
        table_matech_height.constant = table_matech.contentSize.height
    }
    
    deinit
    {
        table_matchRateList.removeObserver(self, forKeyPath: "contentSize")
        table_matchScoreList.removeObserver(self, forKeyPath: "contentSize")
        table_transaction.removeObserver(self, forKeyPath: "contentSize")
        table_matech.removeObserver(self, forKeyPath: "contentSize")
        
    }

    @IBAction func btn_matchRateList_deletePressed(_ sender: UIButton)
    {
        self.arrMatchRateList.remove(at: sender.tag)
        self.table_matchRateList.reloadData()
        if self.arrMatchRateList.count == 0
        {
            self.table_matchRateList_height.constant = 0
        }
    }
    
    @IBAction func btn_refreshPressed(_ sender: UIButton)
    {
    
    }
    
    @IBAction func btn_deleteTxnPressed(_ sender: UIButton)
    {
        let txn = arrUserTxnList[sender.tag]
        let parameters = ["txnId":txn.id!] as [String:Any]
        deleteTxn(parameters: parameters)
    }
    
    @IBAction func btn_placeBetPressed(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if placeBetVC == nil
        {
            placeBetVC = storyboard.instantiateViewController(withIdentifier: Identifier.PlaceBetViewController) as! PlaceBetViewController
        }
        
        placeBetVC.arrTeamName = self.arrTeamName
        placeBetVC.delegate = self
        placeBetVC.view.frame = presentWindow.bounds
        presentWindow.addSubview(placeBetVC.view)
        placeBetVC.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4064105308)
        placeBetVC.view_setBet.layer.cornerRadius = CGFloat(10)
        placeBetVC.view_setBet.layer.borderWidth = 1
        placeBetVC.view_setBet.layer.borderColor = UIColor.clear.cgColor
        placeBetVC.view_setBet.clipsToBounds = true
        placeBetVC.view_setBet.setShadow()
        
    }
    
    func playSound(comentry:String)
    {
        let url = Bundle.main.url(forResource: comentry, withExtension: "wav")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    player.volume = 0.0
        } catch let error as NSError {
            print(error.description)
        }
    }

    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(true)
        if webTimer != nil{
            self.webTimer.invalidate()
            self.webTimer = nil
        }
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

extension HomeViewController
{
    func getMatchDetails()
    {
        
        //self.playSound(comentry: "2 RUN")

        
//        1 RUN
//        2 RUN
//        3 RUN
//        4 RUN
//        6 RUN
//        FREE HIT
//        BOWLER RUKA
//        NO BALL
//        FREE HIT
//        NOT OUT
//        SPINNER
//        FAST BOWLER
//        WICKET
//        REVIEW LIYA
//        THIRD UMPIRE
//        SORRY
//        WEATHER KHARAB HAI
//        WIDE BALL
//        DRINK
//        OVER HO GAYA
//        BALL CHALU
//        90-11
//        80-20
//        TIME OUT 
//        SECURITY PROBLEM
//        BALL HAWA ME
//        APPEAL 
//        1.1-50
//        BARISH RAIN
//        OVERTHROW
        
        let network = NetworkCall()
        
        network.headers["accessToken"] = getUserDefaults(key: defaultsKeys.accessToken) as? String
        network.apicall(api: "match/getMatchDetails", method: .get, parameters: [:], isHud: true, completion: { response in
            
            if network.is_success
            {
                //self.getMatchList()
                
                let data = network.data as! [String:Any]
                
                self.lbl_sessionDesc.text = data["sessionDesc"] as? String
                self.lbl_sessionValue.text = data["sessionValue"] as? String
                self.lbl_commentry.text = data["commentry"] as? String
                self.lbl_commentryTwo.text = data["commentryTwo"] as? String
                self.lbl_heading.text = data["heading"] as? String
                
                self.playSound(comentry: data["commentry"] as! String)
            }
            else
            {
                if network.response_message.contains("Invalid access token")
                {
                    self.removeAppSession()
                    setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SignInNavigation)
                }
                self.presentWindow.makeToast(message: network.response_message)
            }
        })
    }

    func getMatchList()
    {
        let network = NetworkCall()
        network.headers["accessToken"] = getUserDefaults(key: defaultsKeys.accessToken) as? String
        network.apicall(api: "match/getMatchList", method: .get, parameters: [:], isHud: true, completion: { response in
            
            if network.is_success
            {
                let data = network.data as! [String:Any]
                let arrMatchList = data["matchList"] as! [[String:Any]]
                self.arrMatches.removeAll()
                for matchDic in arrMatchList
                {
                    let match = Match.match(match: Match(), data: matchDic)
                    self.arrMatches.append(match)
                }
                self.table_matech.reloadData()
                
                let teamsName = data["teamsName"] as? String
                self.arrTeamName = (teamsName?.components(separatedBy: ","))!

                let arr_UserTxnList = data["userTxnList"] as! [[String:Any]]
                for item in arr_UserTxnList
                {
                    let userTxnList = UserTxnList.userTxnList(UserTxnList: UserTxnList(), data: item)
                    self.arrUserTxnList.append(userTxnList)
                }
                self.table_transaction.reloadData()

                
                let arr_UserTxnSum = data["userTxnSum"] as! [[String:Any]]
                for item in arr_UserTxnSum
                {
                    let userTxnSum = UserTxnSum.userTxnSum(UserTxnSum: UserTxnSum(), data: item)
                    self.arrUserTxnSum.append(userTxnSum)
                }
                if self.arrUserTxnSum.count > 0
                {
                    self.configureUserTxnSum()
                }
            }
            else
            {
                self.presentWindow.makeToast(message: network.response_message)
            }
        })
    }
    
    func configureUserTxnSum()
    {
        let userTxnSumTeam1 = arrUserTxnSum[0]
        self.lbl_team1_name.text = userTxnSumTeam1.team
        self.lbl_team1bet.text = String(format: "%d", userTxnSumTeam1.teamAmount!)
        
        if userTxnSumTeam1.teamAmount! < 0
        {
            self.lbl_team1bet.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        else
        {
            self.lbl_team1bet.textColor = .black
        }
        
        let userTxnSumTeam2 = arrUserTxnSum[1]
        self.lbl_team2_name.text = userTxnSumTeam2.team
        self.lbl_team2bet.text = String(format: "%d", userTxnSumTeam2.teamAmount!)
        if userTxnSumTeam2.teamAmount! < 0
        {
            self.lbl_team2bet.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        else
        {
            self.lbl_team2bet.textColor = .black
        }
    }
    
   
    func createTxn(parameters:[String : Any])
    {
        let network = NetworkCall()
        
        //{"teamName":"India","support":"L","rate":2,"betAmount":900.00,"commission":0}
        network.headers["accessToken"] = getUserDefaults(key: defaultsKeys.accessToken) as? String
        network.apicall(api: "match/createTxn", method: .post, parameters: parameters, isHud: true, completion: { response in
            
            if network.is_success
            {
                let data = network.data as! [String:Any]

                let arr_UserTxnList = data["userTxnList"] as! [[String:Any]]
                
                self.arrUserTxnList.removeAll()

                for item in arr_UserTxnList
                {
                    let userTxnList = UserTxnList.userTxnList(UserTxnList: UserTxnList(), data: item)
                    self.arrUserTxnList.append(userTxnList)
                }
                self.table_transaction.reloadData()
                
                
                let arr_UserTxnSum = data["userTxnSum"] as! [[String:Any]]
                
                for item in arr_UserTxnSum
                {
                    let userTxnSum = UserTxnSum.userTxnSum(UserTxnSum: UserTxnSum(), data: item)
                    self.arrUserTxnSum.append(userTxnSum)
                }
                self.configureUserTxnSum()
            }
            else
            {
                self.presentWindow.makeToast(message: network.response_message)
            }
            self.placeBetVC.view.removeFromSuperview()
        })
    }
    
    func deleteTxn(parameters:[String : Any])
    {
        let network = NetworkCall()
        
        //{"teamName":"India","support":"L","rate":2,"betAmount":900.00,"commission":0}
        network.headers["accessToken"] = getUserDefaults(key: defaultsKeys.accessToken) as? String
        network.apicall(api: "match/deleteTxn", method: .put, parameters: parameters, isHud: true, completion: { response in
            
            if network.is_success
            {
                self.presentWindow.makeToast(message: network.response_message)
                
                let arr_UserTxnList = network.data as! [[String:Any]]
                
                self.arrUserTxnList.removeAll()
                
                for item in arr_UserTxnList
                {
                    let userTxnList = UserTxnList.userTxnList(UserTxnList: UserTxnList(), data: item)
                    self.arrUserTxnList.append(userTxnList)
                }
                self.table_transaction.reloadData()
            }
            else
            {
                self.presentWindow.makeToast(message: network.response_message)
            }
        })
    }
    
    func getMatchScores(matchIdStr:String)
    {
        let network = NetworkCall()
        
        //{"teamName":"India","support":"L","rate":2,"betAmount":900.00,"commission":0}
        network.headers["accessToken"] = getUserDefaults(key: defaultsKeys.accessToken) as? String
        network.apicall(api: "match/getMatchScores/" + matchIdStr, method: .get, parameters: [:], isHud: true, completion: { response in
            
            if network.is_success
            {
                //self.presentWindow.makeToast(message: network.response_message)
                
                let data = network.data as! [String:Any]
                
                let arr_MatchRateList = data["matchRateList"] as! [[String:Any]]
            
                var arr_MatchRate = [MatchRate]()
                
                for item in arr_MatchRateList
                {
                    let matchRate = MatchRate.matchRate(matchRate: MatchRate(), data: item)
                    arr_MatchRate.append(matchRate)
                }
                self.arrMatchRateList.removeAll()
                self.arrMatchRateList = arr_MatchRate.group { $0.matchId}
                //print("arrMatchRateList = \(self.arrMatchRateList)")
                self.table_matchRateList.reloadData()
                
                let arr_MatchScoreList = data["matchScoreList"] as! [[String:Any]]
                var arr_ScoreList = [MatchRate]()
                
                for item in arr_MatchScoreList
                {
                    let matchRate = MatchRate.matchRate(matchRate: MatchRate(), data: item)
                    arr_ScoreList.append(matchRate)
                }
                self.arrMatchScoreList.removeAll()
                self.arrMatchScoreList = arr_ScoreList.group { $0.matchId}
                self.table_matchScoreList.reloadData()
                
                if (self.arrMatchRateList.count > 0) || (self.arrMatchScoreList.count > 0)
                {
                    self.view_matchRateListBg.isHidden = false
                }
            }
            else
            {
                self.presentWindow.makeToast(message: network.response_message)
            }
        })
    }
}

extension Sequence
{
    func group<GroupingType: Hashable>(by key: (Iterator.Element) -> GroupingType) -> [[Iterator.Element]] {
        var groups: [GroupingType: [Iterator.Element]] = [:]
        var groupsOrder: [GroupingType] = []
        forEach { element in
            let key = key(element)
            if case nil = groups[key]?.append(element) {
                groups[key] = [element]
                groupsOrder.append(key)
            }
        }
        return groupsOrder.map { groups[$0]! }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == table_matchRateList
        {
            return arrMatchRateList.count
        }
        else if tableView == table_matchScoreList
        {
            return arrMatchScoreList.count
        }
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == table_matchRateList
        {
            return (arrMatchRateList[section] as! [Any]).count
        }
        else if tableView == table_matchScoreList
        {
            return (arrMatchScoreList[section] as! [Any]).count
        }
        else if tableView == table_transaction
        {
            return arrUserTxnList.count
        }
        else if tableView == table_matech
        {
            return arrMatches.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == table_matchRateList
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RateTeamcell", for: indexPath) as! MatchRateListTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            let arrMatchRate = arrMatchRateList[indexPath.section] as! [MatchRate]
            let matchRate = arrMatchRate[indexPath.row]
            
            cell.lblteam.text = matchRate.team
            cell.lblbackpoint.text = String(matchRate.lay!)
            cell.lbllayAmt.text = String(matchRate.layAmt!)
            cell.lblbackpoint.text = String(matchRate.back!)
            cell.lblbackAmt.text = String(matchRate.backAmt!)
            
            return cell
        }
        else if tableView == table_matchScoreList
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTeamcell", for: indexPath) as! MatchScoreListTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let arrMatchRate = arrMatchScoreList[indexPath.section] as! [MatchRate]
            let matchRate = arrMatchRate[indexPath.row]
            
            cell.lblteam.text = matchRate.team
//            cell.lblbackpoint.text = String(matchRate.lay!)
//            cell.lbllayAmt.text = String(matchRate.layAmt!)
//            cell.lblbackpoint.text = String(matchRate.back!)
//            cell.lblbackAmt.text = String(matchRate.backAmt!)
            
            return cell
        }
        else if tableView == table_transaction
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let txn = arrUserTxnList[indexPath.row]
            cell.lblid.text = "\(txn.id ?? 0)"
            cell.lblrate.text = "\(txn.rate ?? 0)"
            cell.lblcommission.text = "\(txn.commission ?? 0)"
            cell.lblsupport.text = "\(txn.support ?? "--")"
            cell.lblteamname.text = "\(txn.teamName ?? "--")"
            cell.lblbetamount.text = "\(txn.betAmount ?? 0)"
            cell.btndelete.tag = indexPath.row
            return cell

        }
        else if tableView == table_matech
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchcell", for: indexPath) as! MatechTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none

            let match = arrMatches[indexPath.row]
            cell.contentView.backgroundColor = UIColor.hexStringToUIColor(hex: match.colorCode!)
            cell.lblIndexnumber.text = "\(indexPath.row + 1)"
            cell.lblmatchname.text = match.matchName
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matchcell", for: indexPath) as! MatechTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == table_matech
        {
            let match = arrMatches[indexPath.row]
            
            if let arr = UserDefaults.standard.object(forKey: defaultsKeys.arrsavedmatchid) as? [Any]
            {
                arrSaveMatchId = arr as! [Int]
            }
            arrTempSaveMatchId = arrSaveMatchId
            
            let arr = arrTempSaveMatchId.filter { (id) -> Bool in
                id == match.matchId
            }
            
            if arr.count==0
            {
                arrTempSaveMatchId.append(match.matchId!)
            }
            
            let userdefaults =  UserDefaults.standard
            userdefaults.set(self.arrTempSaveMatchId, forKey: defaultsKeys.arrsavedmatchid)
            userdefaults.synchronize()
            
            let stringArray = arrTempSaveMatchId.flatMap { String($0) }
            let matchIdStr = stringArray.joined(separator: ",")
            
            getMatchScores(matchIdStr: matchIdStr)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == table_matchRateList
        {
            let header = tableView.dequeueReusableCell(withIdentifier: "RateHeadercell")! as! MatchRateListTableViewCell
           
            header.btncross.tag = section
               return header.contentView
        }
        else if tableView == table_matchScoreList
        {
            let header = tableView.dequeueReusableCell(withIdentifier: "ScoreHeadercell")! as! MatchRateListTableViewCell
            
            header.btncross.tag = section
            return header.contentView
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == table_matchRateList || tableView == table_matchScoreList
        {
            return 62 //UITableViewAutomaticDimension
        }
        else
        {
           return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == table_transaction
        {
            return 54
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

class MatchRateListTableViewCell : UITableViewCell
{
    @IBOutlet weak var lblteam: UILabel!
    @IBOutlet weak var lblbackpoint: UILabel!
    @IBOutlet weak var lblbackAmt: UILabel!
    @IBOutlet weak var lbllaypoint: UILabel!
    @IBOutlet weak var lbllayAmt: UILabel!
    
    //header
    @IBOutlet weak var btncross: UIButton!
}

class MatchScoreListTableViewCell : UITableViewCell
{
    @IBOutlet weak var lblteam: UILabel!
    @IBOutlet weak var lblrun: UILabel!
}

class MatechTableViewCell : UITableViewCell
{
    @IBOutlet weak var lblIndexnumber: UILabel!
    @IBOutlet weak var lblmatchname: UILabel!
}

class TransactionTableViewCell : UITableViewCell
{
    @IBOutlet weak var lblid: UILabel!
    @IBOutlet weak var lblteamname: UILabel!
    @IBOutlet weak var lblsupport: UILabel!
    @IBOutlet weak var lblrate: UILabel!
    @IBOutlet weak var lblbetamount: UILabel!
    @IBOutlet weak var lblcommission: UILabel!
    @IBOutlet weak var btndelete: UIButton!
}

