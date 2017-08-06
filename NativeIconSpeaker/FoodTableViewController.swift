//
//  FoodTableViewController.swift
//  NativeIconSpeaker
//
//  Created by Nguyễn Minh Trí on 5/19/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit

class FoodTableViewController: UITableViewController {

    @IBOutlet weak var visualEffectView: UIView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var lblVN: UILabel!
    
    let CELL_ID = "CELL_ID"
    var results:[Direction]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        fetchData()
    }
    
    func setupCell(){
        let nibName = UINib(nibName: "ServiceTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: CELL_ID)
    }
    
    func fetchData(){
        if results == nil {
            results = DBManager.queryDataFoodENG()
        }
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
        let foodData:Direction = results![indexPath.row]
        //corner 
        cell.imgIcon.layer.cornerRadius = cell.imgIcon.frame.size.width/2
        cell.imgIcon.clipsToBounds = true
        cell.imgIcon.image = UIImage(named: foodData.image)
        
        let userDf = UserDefaults.standard
        let isLanguage:String = userDf.object(forKey: "language") as! String
        switch isLanguage {
        case "eng":
            cell.lblEN.text = foodData.txtEn
            break
        case "kav":
            cell.lblEN.text = foodData.txtKorea
            break
        case "jav":
            cell.lblEN.text = foodData.txtJp
            break
        default:
            cell.lblEN.text = foodData.txtEn
            break
        }
        
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
    }
    
    func setupEffectView(_ iloveVN:String, coordinate:String){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let visualVC = storyBoard.instantiateViewController(withIdentifier: "VisualViewViewController") as! VisualViewViewController
        visualVC.strVN = iloveVN
        visualVC.famousCoordinate = coordinate
        present(visualVC, animated: false, completion: nil)
        
    }
}
