//
//  VisualViewViewController.swift
//  NativeIconSpeaker
//
//  Created by Nguyễn Minh Trí on 7/21/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit

class VisualViewViewController: UIViewController {
    @IBOutlet weak var popupview: UIView!
    @IBOutlet weak var lblVN: UILabel!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var famousCoordinate:String?
    var strVN:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCloseRecognize()
        btnDirection.isUserInteractionEnabled = true
    }
    
    func setupView(){
        popupview.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.3) {
            
            self.lblVN.text = self.strVN
            self.popupview.transform = CGAffineTransform.identity
            self.popupview.layer.cornerRadius = 10
        }
    }
    
    func setupCloseRecognize(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(closeVisualView))
        singleTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(singleTap)
    }
    
    func closeVisualView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.popupview.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        }) { (success) in
            self .dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func handleDirection(_ sender: Any) {
        if (famousCoordinate?.characters.count)! > 1 {
            test_famous_map(famousCoordinate!)
        } else {
            test_map()
        }
    }
    
    @IBOutlet weak var btnDirection: UIButton!
    
    
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

}
