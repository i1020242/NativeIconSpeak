//
//  ServiceTableViewController.swift
//  NativeIconSpeaker
//
//  Created by BDAFshare on 5/18/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit

class ServiceTableViewController: UITableViewController {
    
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
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 49, 0)
    }
    
    func fetchData(){
        if results == nil {
            results = DBManager.queryDataServiceENG()
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
        let serviceData:Direction = results![indexPath.row]
        
        //corner icon
        cell.imgIcon.layer.cornerRadius = cell.imgIcon.frame.size.width/2
        cell.imgIcon.clipsToBounds = true
        
        let userDf = UserDefaults.standard
        let isLanguage:String = userDf.object(forKey: "language") as! String
        switch isLanguage {
        case "eng":
            cell.lblEN.text = serviceData.txtEn
            break
        case "kav":
            cell.lblEN.text = serviceData.txtKorea
            break
        case "jav":
            cell.lblEN.text = serviceData.txtJp
            break
        default:
            cell.lblEN.text = serviceData.txtEn
            break
        }
        cell.imgIcon.image = UIImage(named: serviceData.image)
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
