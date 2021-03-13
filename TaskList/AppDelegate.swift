//
//  AppDelegate.swift
//  TaskList
//
//  Created by Admin on 2020/11/18.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let notificationManager = NotificationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = "684876868777-jkkkjj62t8gte4o5t50u3dg4u1li023e.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let rootViewController = TaskListController()
        window?.rootViewController = rootViewController
        
        // Request notification authorization
        self.notificationManager.requestAuthorization()
        
        // Set time launchScreen
        Thread.sleep(forTimeInterval: 0.2)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.notificationManager.setNotifications()
    }
    
    // [START openurl]
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Failed to sign in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        print("Successfully sign in.")
        
        //let config = FirestoreConfigRepository()
        let authenticationService = AuthenticationService()
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        guard let taskListViewController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController as? TaskListController else { return }
        
        if let user = Auth.auth().currentUser {
            taskListViewController.user = User(uid: user.uid, name: user.displayName ?? "", email: user.email ?? "", photoURL: user.photoURL?.absoluteString ?? "")
            taskListViewController.loadData()
        } else {
            // Use the credentials to authenticate with Firebase.
            authenticationService.authenticationToFirebase(with: credential) { (user) in
                taskListViewController.user = user
                taskListViewController.loadData()
            }
        }
                
        // Dismiss sign in view controller
        if let presentingViewController = GIDSignIn.sharedInstance()?.presentingViewController, presentingViewController is SignInController {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
}
