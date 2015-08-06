//
//  AppDelegate.swift
//  FBNavigationPattern
//
//  Created by Florent TM on 31/07/2015.
//  Copyright © 2015 Florent THOMAS-MOREL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var viewControllers:[UIViewController] = []
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc1"))
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc2"))
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc3"))
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc1"))
        
        var images:[UIImage] = []
        images.append(UIImage(named: "home168")!)
        images.append(UIImage(named: "document224")!)
        images.append(UIImage(named: "compass49")!)
        images.append(UIImage(named: "group58")!)
        
        let initialViewController = FBSideMenuViewController(viewsControllers: viewControllers, withImages: images, forLimit: 90, withMode: FBSideMenuMode.SwipeFromScratch)
        initialViewController.pictoAnimation = {(desactive:UIImageView?, active:UIImageView?, index:Int)-> Void in
            desactive?.alpha = 0.2
            desactive?.transform = CGAffineTransformMakeScale(0.8,0.8);
            active?.alpha = 1
            active?.transform = CGAffineTransformMakeScale(1,1);
        }
        
        initialViewController.view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

