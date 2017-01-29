//
//  LoginController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-24.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import TwitterKit

class LoginController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    //var nearByEventsCollectionController = NearByEventsCollectionController()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupFBButtons()
        setupGoogleButton()
        setupTwitterButton()
        
        GIDSignIn.sharedInstance().uiDelegate = self

    }
    
    fileprivate func setupFBButtons(){
        
        //FB login button
        let fbLoginButton = FBSDKLoginButton()
        fbLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fbLoginButton)
        
        //ios 9 constraints x, y, w, h
        fbLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fbLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        fbLoginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        fbLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["email", "public_profile"]

        
        
    }
    
    fileprivate func setupGoogleButton() {
        
        //google sign in button
        //let googleButton = GIDSignInButton()
        let customGoogleButton = UIButton(type: .system)
        customGoogleButton.backgroundColor = .red
        customGoogleButton.setTitle("Signin with Google", for: .normal)
        customGoogleButton.setTitleColor(.white, for: .normal)
        customGoogleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        customGoogleButton.layer.cornerRadius = 5
        customGoogleButton.layer.masksToBounds = true
        customGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customGoogleButton)
        //ios 9 constraints x, y, w, h
        customGoogleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customGoogleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100 + 66).isActive = true
        customGoogleButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        customGoogleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    fileprivate func setupTwitterButton() {
        
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error {
                print("Failed to login via Twitter: ", err)
                return
            }
            print("Successfully logged in via Twitter")
            
            guard let authToken = session?.authToken else {return}
            guard let tokenSecret = session?.authTokenSecret else {return}
            let credentials = FIRTwitterAuthProvider.credential(withToken: authToken, secret: tokenSecret)
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                if let err = error {
                    print("Failed to signin to Firebase via Twitter: ", err)
                }
                print("Successfully signed in to Firebase via Twitter: ", user?.uid ?? "")
                self.checkUserIfUserExist()
            })
        }
        
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(twitterButton)
        
        //ios 9 contrainsts
        twitterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100 + 66 + 66).isActive = true
        twitterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        twitterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    //fb logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //enter logout actions here
    }
    //fb login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showUserInfo()
        checkUserIfUserExist()
    }
    
    func handleGoogleSignIn() {
        
        GIDSignIn.sharedInstance().signIn()
        checkUserIfUserExist()
        
    }
    
    func checkUserIfUserExist() {
        
        let userId = FIRAuth.auth()?.currentUser?.uid
        if userId != nil {
            dismiss(animated: true, completion: nil)
        }

        
    }
    
    func showUserInfo() {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                guard let err = error else {return}
                print("Somthing went wrong with our FB login: ", err)
            }
            guard let userInfo = user else {return}
            print("Successfully logged in user via Facebook!")
            print(userInfo)
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, results, error) in
            if error != nil {
                print("Failed graph request",error ?? "Error")
                return
            }
            
            print(results ?? "Results")
            
        }
        
    }
       
}

//shorten the constraints, COPY AND PASTE THIS WHEN USING addConstraints withVisualFormat
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        //making the views dictionary
        var viewsDictionary = [String: UIView]()
        //loop through the views and assign a index to the views then stick that index to the string as the viewID
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        //adding the parameters into the addConstraints() method
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}

