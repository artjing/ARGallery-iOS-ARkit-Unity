//
//  AppDelegate.swift
//  ARGallery
//
//  Created by 董静 on 6/17/21.
//

import UIKit
import UnityFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var unityFramework:UnityFramework?

    //MARK:- Unity Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // inital view
        let firstVC = HomeViewController()
        let navVC = ARNavigationViewController()
        
        // add to window
        navVC.addChild(firstVC)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    @objc func backFromUnity(){
        self.unityFramework?.pause(true)
        window?.makeKeyAndVisible()

    }
    
    @objc func unityDidUnload(notification : NSNotification){
        
    }
    
    func unityFrameworkLoad() -> UnityFramework? {
        let bundlePath = Bundle.main.bundlePath.appending("/Frameworks/UnityFramework.framework")
        if let unityBundle = Bundle.init(path: bundlePath){
            if let frameworkInstance = unityBundle.principalClass?.getInstance(){
               return frameworkInstance
               }
            }
            return nil
        }
    
    // Entry for unity
    public func initAndShowUnity() -> Void {
            
            // get unity framework
            if let framework = self.unityFrameworkLoad(){
                self.unityFramework = framework
                self.unityFramework?.setDataBundleId("com.unity3d.framework")
                self.unityFramework?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: [:])
                self.unityFramework?.showUnityWindow()
                let rootView = self.unityFramework?.appController()?.rootViewController
                
                // add back button
                let btn = UIButton(type: .system)
                btn.backgroundColor = .black
                btn.setTitle("< back", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                btn.frame = CGRect(x: 15, y: 15, width: 60, height: 60)
                btn.addTarget(self, action: #selector(AppDelegate.backFromUnity), for: .primaryActionTriggered)
                rootView?.view.addSubview(btn)
                rootView?.view.bringSubviewToFront(btn)
            }
        }

}
