//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mac Book on 22.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
        } catch  {
            print("Error installing realm")
        }
        
        return true
    }
    

}

