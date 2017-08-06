//
//  VietNamViewController.swift
//  NativeIconSpeaker
//
//  Created by Nguyễn Minh Trí on 5/30/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit

let CELL_ID = "CELL_ID"


class VietNamViewController: UIViewController {

    @IBOutlet weak var tblVN: UITableView!
    @IBOutlet weak var txtVN: UITextView!
    
    var results:[Direction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptableView()
        fetchData()
    }
    
    func setuptableView(){
        
        //tblVN.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        let nibName = UINib(nibName: "ServiceTableViewCell", bundle: nil)
        tblVN.register(nibName, forCellReuseIdentifier: CELL_ID)
        tblVN.delegate = self
        tblVN.dataSource = self
    }
    
    func fetchData(){
        if results == nil {
            results = DBManager.queryDataDirectionENG()
            tblVN.reloadData()
        }
    }
}

extension VietNamViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ServiceTableViewCell
        let dictionaryData:Direction = results![indexPath.row]
        cell.lblEN.text = dictionaryData.txtVn
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionaryData:Direction = results![indexPath.row]
        settxtText(dictionaryData.txtEn)
    }
    
    func settxtText(_ txt:String){
        let temp = txtVN.text
        let txtAll = temp! + " :)) " + txt
        txtVN.text = txtAll
    }
}

extension VietNamViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
}
