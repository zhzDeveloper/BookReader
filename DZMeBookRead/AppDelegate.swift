//
//  AppDelegate.swift
//  DZMeBookRead
//
//  Created by zhz on 2017/10/16.
//  Copyright © 2017年 ZHZ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
        
        window = UIWindow(frame:UIScreen.main.bounds)
        
        window!.makeKeyAndVisible()
        
        let vc = ZMainViewController()
        
        let navVC = UINavigationController(rootViewController:vc)
        
        window!.rootViewController = navVC
        
        return true
    }
 
    func applicationDidBecomeActive(_ application: UIApplication) {
        let documents: String = NSHomeDirectory() + "/Documents"
        do {
            let fileList = try FileManager.default.contentsOfDirectory(atPath: documents)
            var bookList:[String] = []
            for file in fileList {
                if file.hasSuffix(".txt") {
                    bookList.append(file)
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kBooksHasLoadNotify), object: bookList)
        } catch {
            print("读取失败  " + documents)
        }
    }
  
}

