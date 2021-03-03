//
//  SignInController.swift
//  TaskList
//
//  Created by Admin on 2021/03/03.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInController: UIViewController {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "startup")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome To TaskList" // タスクリストへようこそ
        label.textColor = UIColor.scheme.label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Compile and manage the goals to be achieved." // 達成すべき目標をまとめて管理する。
        label.textColor = UIColor.scheme.secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.scheme.primary
        button.setTitle("Get started", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleGetStarted), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        view.backgroundColor = UIColor.scheme.secondaryBackground
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(getStartedButton)
        
        let paddingTop: CGFloat = calculateImageViewPaddingTop(value: view.frame.height, total: 896)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, paddingTop: paddingTop, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        titleLabel.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 42, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        getStartedButton.anchor(top: descriptionLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 36)
        getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func calculateImageViewPaddingTop(value: CGFloat, total: CGFloat) -> CGFloat {
        return value / total * 100.0
    }
    
    @objc private func handleGetStarted() {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension SignInController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Failed to signin
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let firUser = authResult?.user else { return }
            let uid = firUser.uid
            let profileImageURL = firUser.photoURL!.absoluteString
            let username = firUser.displayName!
            let email = firUser.email!
            
            guard let taskListController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController as? TaskListController else { return }
            
            let user = User(uid: uid, profileImageURL: profileImageURL, username: username, email: email)
            taskListController.user = user
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
