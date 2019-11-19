//
//  AppDelegate.swift
//  StundenApp
//
//  Created by Serz on 14.11.2019.
//  Copyright © 2019 Serz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn


var credential: AuthCredential!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    
    var window: UIWindow?
    let GNC = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
       // deleteKeychain(itemKey: "USER_DATA")
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        

        GNC.isNavigationBarHidden = true
        
        welcomCtrl()
        
        return true
    }
    
    func welcomCtrl(){
        let welcomView = Welcom()
        GNC.addChild(welcomView);
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.isUserInteractionEnabled = true
        if let window = self.window{
            window.rootViewController = GNC
            window.makeKeyAndVisible()
        }
    }
    
    
    class func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    //=====================
    //MARK: GOOOGLE AUTH
    //=====================
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            for ctrl in GNC.viewControllers{
                if let wel = ctrl as? Welcom{
                    wel.removeOverlay()
                    break
                }
            }

            return
        }
        guard let authentication = user.authentication else { return }
        firebaseLogIn(idToken: authentication.idToken, accessToken:authentication.accessToken)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {


    }
    

    //=====================
    //MARK: FIREBASE AUTH
    //=====================
    func firebaseLogIn(idToken: String!, accessToken: String!, firstTime: Bool = true){
        credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        
        
        Firebase.Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            Firebase.Auth.auth().currentUser?.getIDTokenResult(completion: { (token, error) in
                FIREBASE_TOKEN = token!.token
                
                USER_DATA["idToken"] = idToken
                USER_DATA["accessToken"] = accessToken
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: USER_DATA, options: JSONSerialization.WritingOptions.prettyPrinted)
                    saveKeychain(itemKey: "USER_DATA", dataValue: data)
                }   catch let error as NSError {
                    print(error)
                }
                
                
                if USER_DATA["userID"] == nil {
                    let userID = Firebase.Auth.auth().currentUser?.uid ?? ""
                    let displayName = (Firebase.Auth.auth().currentUser?.displayName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                    let email = Firebase.Auth.auth().currentUser?.email ?? ""
                    let phoneNumber = Firebase.Auth.auth().currentUser?.phoneNumber ?? ""
                    
                    USER_DATA = NSMutableDictionary()
                    USER_DATA["userID"] = userID
                    USER_DATA["profileComplited"] = false

                    USER_DATA["email"] = email
                    USER_DATA["phoneNumber"] = phoneNumber
                    USER_DATA["displayName"] = displayName

                    do {
                        let data = try JSONSerialization.data(withJSONObject: USER_DATA, options: JSONSerialization.WritingOptions.prettyPrinted)
                        saveKeychain(itemKey: "USER_DATA", dataValue: data)
                    }   catch let error as NSError {
                        print(error)
                    }
                    
                    let profile = Profile()
                    profile.firstStart = true
                    self.GNC.pushViewController(profile, animated: true)

                    
                } else {
                    if USER_DATA["profileComplited"] as! Bool == true{
                        let main = Main()
                        self.GNC.pushViewController(main, animated: false)
                    } else {
                        let profile = Profile()
                        profile.firstStart = true
                        self.GNC.pushViewController(profile, animated: false)                }
                    
                }
                
            })

        }
        
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

