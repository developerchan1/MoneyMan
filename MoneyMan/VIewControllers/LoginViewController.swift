//
//  ViewController.swift
//  MoneyMan
//
//  Created by Chandra on 19/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate{

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        //set button style
        UIUtil.buttonStyle(btnLogin)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isUserLoggedIn()
    }
    
    @IBAction func doLogin(_ sender: Any) {
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        
        if inputValid(email,password) {
            signIn(email,password)
        }
    }
    
    @IBAction func googleSignInButtonPressed(_ sender: Any) {
          GIDSignIn.sharedInstance().signIn()
    }
    
    func inputValid(_ email : String, _ password : String) -> Bool{
        if email == "" {
            showErrorDialog("Error Message","Email must be filled")
            return false
        }
        
        if !(!email.hasPrefix("@") && email.contains("@") && !email.contains("@.") && !email.hasSuffix(".")) {
            showErrorDialog("Error Message","Invalid email format")
            return false
        }
        
        if password.count < 8 {
            showErrorDialog("Error Message","Password must be at least 8 characters")
            return false
        }
        
        return true
    }
    
    func signIn(_ email : String, _ password : String){
        showLoadingAlert()
        //sign in with email and password
        Auth.auth().signIn(withEmail: email, password: password){
            (authResult, error) in
            
            if let error = error {
                self.dismissLoadingAlert()
                self.showErrorDialog("Error Message","\(error.localizedDescription)")
                return
            }
            
            self.isUserLoggedIn()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //sign in with google sign in
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        
        if let auth = user.authentication {
            showLoadingAlert()
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)

            Auth.auth().signIn(with: credentials) {
                (authResult, error) in

                if let error = error {
                    self.dismissLoadingAlert()
                    self.showErrorDialog("Error Message","\(error.localizedDescription)")
                    return
                }

                self.isUserLoggedIn()
            }
        }
    }
    
    func isUserLoggedIn(){
        if let user = Auth.auth().currentUser{
            //add initial balance and debt for new user
            Firestore.firestore().collection("balanceAndDebt").document(user.uid).getDocument { (document, error) in
                if error == nil {
                    if document == nil || !(document!.exists) {
                         Firestore.firestore().collection("balanceAndDebt").document(user.uid).setData(["balance":0,"debt":0])
                    }
                }
            }
            
            dismissLoadingAlert()
            
            let tabBarController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as! UITabBarController
            view.window?.rootViewController = tabBarController
            view.window?.makeKeyAndVisible()
        }
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        //nothing to do
    }
}
