//
//  DirectionTableViewController.swift
//  NativeIconSpeaker
//
//  Created by Nguyễn Minh Trí on 5/19/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit

class DirectionTableViewController: UITableViewController {

    let CELL_ID = "CELL_ID"
    var results:[Direction]?
    
    //popup
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    //end popup
    @IBOutlet var viewChooseLanguage: UIView!
    @IBOutlet weak var btnChooseENG: UIButton!
    @IBOutlet weak var btnChooseKo: UIButton!
    @IBOutlet weak var btnChooseJa: UIButton!
    @IBOutlet weak var lblVN: UILabel!
    
    var coor_test:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        setupChooseView()
    }
    
    func setupCell(){
        let nibName = UINib(nibName: "ServiceTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: CELL_ID)
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 49, 0)
    }
    
    func setupChooseView(){
        results = []//choose language
        viewChooseLanguage.layer.cornerRadius = 10
        btnChooseENG.layer.cornerRadius = btnChooseENG.frame.size.width/2
        btnChooseJa.layer.cornerRadius = btnChooseJa.frame.size.width/2
        btnChooseKo.layer.cornerRadius = btnChooseKo.frame.size.width/2
        viewChooseLanguage.clipsToBounds = true
        viewChooseLanguage.center = tableView.center
        tableView.addSubview(viewChooseLanguage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ServiceTableViewCell
        let direction:Direction = results![indexPath.row]
        
        //EXPLAIN: STUPID_SOLUTION istead of autoLayout - horizontal center
        
        //var test = dictionaryData.txtEn
//        if test.characters.count > 50 {
//            for indexChar in 30...40{
//                let index = test.index (test.startIndex, offsetBy: indexChar)
//                print(test[index])
//                if test[index] == " " {
//                    test.insert("\n", at: test.index(test.startIndex, offsetBy: indexChar))
//                    break
//                }
//            }
//        }
        cell.imgIcon.layer.cornerRadius = cell.imgIcon.frame.size.width/2
        cell.imgIcon.clipsToBounds = true
        let userDf = UserDefaults.standard
        let isLanguage:String = userDf.object(forKey: "language") as! String
        switch isLanguage {
        case "eng":
            cell.lblEN.text = direction.txtEn
            break
        case "kav":
            cell.lblEN.text = direction.txtKorea
            break
        case "jav":
            cell.lblEN.text = direction.txtJp
            break
        default:
            cell.lblEN.text = direction.txtEn
            break
        }
        
        cell.selectionStyle = .none
        
        //img
        cell.imgIcon.image = UIImage(named: direction.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionaryData:Direction = results![indexPath.row]
        let strVN = dictionaryData.txtVn
        let coordinate = dictionaryData.coordinate
        setupEffectView(strVN, coordinate: coordinate)
        coor_test = dictionaryData.coordinate
    }
    
    
    func setupEffectView(_ iloveVN:String, coordinate:String){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let visualVC = storyBoard.instantiateViewController(withIdentifier: "VisualViewViewController") as! VisualViewViewController
        visualVC.strVN = iloveVN
        visualVC.famousCoordinate = coordinate
        present(visualVC, animated: false, completion: nil)
        
    }
    
    func setupEffectView(_ iloveVN:String){
        
        popupView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.3) {
            self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(self.visualEffectView)
            self.visualEffectView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            self.visualEffectView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.visualEffectView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
            
            self.lblVN.text = iloveVN
            self.popupView.transform = CGAffineTransform.identity
            self.popupView.layer.cornerRadius = 10
            self.setupCloseRecognize()

            }
    }
    
    func setupCloseRecognize(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeVisualView))
        singleTap.numberOfTapsRequired = 1
        visualEffectView.isUserInteractionEnabled = true
        visualEffectView.addGestureRecognizer(singleTap)
    }
    
    func closeVisualView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }) { (success) in
            self.visualEffectView.removeFromSuperview()
        }
    }
    
    @IBAction func handleDrection(_ sender: Any) {
        if (coor_test?.characters.count)! > 1 {
            test_famous_map(coor_test!)
        } else {
            test_map()
        }
    }
    
    func test_map(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        present(mapVC, animated: true, completion: nil)
    }
    
    func test_famous_map(_ str:String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mapVCFamous = storyBoard.instantiateViewController(withIdentifier: "FamousMapViewController") as! FamousMapViewController
        mapVCFamous.famousPlaceDestination = str
        present(mapVCFamous, animated: false, completion: nil)
    }
    //choose language on first load
    @IBAction func chooseENG(_ sender: Any) {
        let engLanguage:String = "eng"
        let userDefaults = UserDefaults.standard
        userDefaults.set(engLanguage, forKey: "language")
        userDefaults.synchronize()
        reloadDirectiontableView()
    }
    
    @IBAction func chooseKAV(_ sender: Any) {
        let engLanguage:String = "kav"
        let userDefaults = UserDefaults.standard
        userDefaults.set(engLanguage, forKey: "language")
        userDefaults.synchronize()
        reloadDirectiontableView()
    }
    
    @IBAction func choose(_ sender: Any) {
        let engLanguage:String = "jav"
        let userDefaults = UserDefaults.standard
        userDefaults.set(engLanguage, forKey: "language")
        userDefaults.synchronize()
        reloadDirectiontableView()
    }
    
    func reloadDirectiontableView(){

        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        viewChooseLanguage.removeFromSuperview()
        results = DBManager.queryDataDirectionENG()
        tableView.reloadData()
    }
    
    
}
