//
//  AppDelegate.swift
//  NativeIconSpeaker
//
//  Created by BDAFshare on 5/10/17.
//  Copyright © 2017 RAD-INF. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let keyAPI = "AIzaSyB-EMRu7GvmVEXXMziZbFxp6P8rqJSIKd4"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(keyAPI)
        GMSPlacesClient.provideAPIKey(keyAPI)
        setupTabbar()
        return true
    }
    let tabbarVC = UITabBarController()
    func setupTabbar(){
        
        //addDB()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let directionVC = storyBoard.instantiateViewController(withIdentifier: "DirectionTableViewController")
        let foodVC = storyBoard.instantiateViewController(withIdentifier: "FoodTableViewController")
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController")
        let serviceVC = storyBoard.instantiateViewController(withIdentifier: "ServiceTableViewController")
        
        //
        let imgDirection = UIImage(named: "ic_street")
        directionVC.tabBarItem = UITabBarItem(title: nil, image: imgDirection, selectedImage: nil)
        directionVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
        let imgFood = UIImage(named: "ic_food")
        foodVC.tabBarItem = UITabBarItem(title: nil, image: imgFood, selectedImage: nil)
        foodVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
        let imgSearch = UIImage(named: "ic_search")
        searchVC.tabBarItem = UITabBarItem(title: nil, image: imgSearch, selectedImage: nil)
        searchVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
        let imgUlti = UIImage(named: "ic_ultility")
        serviceVC.tabBarItem = UITabBarItem(title: nil, image: imgUlti, selectedImage: nil)
        serviceVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9, left: 0, bottom: -9, right: 0)
        
        let viewControllers = [directionVC, foodVC, serviceVC, searchVC]
        tabbarVC.viewControllers = viewControllers
        tabbarVC.delegate = self as? UITabBarControllerDelegate
        
        //IMPORTTANT
        window?.rootViewController = tabbarVC
        tabbarVC.tabBar.isUserInteractionEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: Notification.Name("NotificationIdentifier"), object: nil)
    }
    
    func test(){
        tabbarVC.tabBar.isUserInteractionEnabled = true
    }
    
    func addDB(){
        let dbManager = DBManager()
        dbManager.addDataDirection()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

