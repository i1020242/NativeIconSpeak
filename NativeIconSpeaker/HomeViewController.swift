//
//  ViewController.swift
//  NativeIconSpeaker
//
//  Created by BDAFshare on 5/10/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let CELL_ID = "CELL_ID"
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tbl_searchView: UITableView!
    
    var searchResultController: SearchResultsController!
    var results:[Direction] = []
    
    //search bar
    
    
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchData()
        hideKeyboadWhenTapAround()
    }
    
    func setupTableView(){
        tbl_searchView.delegate = self
        tbl_searchView.dataSource = self
        searchBar.delegate = self
        let nibName = UINib(nibName: "ServiceTableViewCell", bundle: nil)
        tbl_searchView.register(nibName, forCellReuseIdentifier: CELL_ID)
    }
    
    func fetchData(){
        
        results = DBManager.queryAllData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (results.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ServiceTableViewCell
        let allData:Direction = results[indexPath.row]
        //corner
        cell.imgIcon.layer.cornerRadius = cell.imgIcon.frame.size.width/2
        cell.imgIcon.clipsToBounds = true
        cell.imgIcon.image = UIImage(named: allData.image)
        
        let userDf = UserDefaults.standard
        let isLanguage:String = userDf.object(forKey: "language") as! String
        switch isLanguage {
        case "eng":
            cell.lblEN.text = allData.txtEn
            break
        case "kav":
            cell.lblEN.text = allData.txtKorea
            break
        case "jav":
            cell.lblEN.text = allData.txtJp
            break
        default:
            cell.lblEN.text = allData.txtEn
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionaryData:Direction = results[indexPath.row]
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
    
    // MARK : searchbar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Change")
        if searchBar.text == nil || searchBar.text == "" {
            
            
            
            view.endEditing(true)
            
            tbl_searchView.reloadData()
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.results.removeAll()
                let realm = try! Realm()
                let predicate = NSPredicate(format: "txtEn CONTAINS[c] %@", searchText)
                let filtered_people = realm.objects(Direction.self).filter(predicate)
                print(filtered_people.count)
                if filtered_people.count == 0 {
                    self.results = []
                    self.tbl_searchView.reloadData()
                } else {
                    for each in filtered_people{
                        self.results.append(each)
                        self.tbl_searchView.reloadData()
                    }
                }
                
            }
        }
    }
}

extension UIViewController {
    func hideKeyboadWhenTapAround(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dissmissKeyboard(){
        view.endEditing(true)
    }
}


