//
//  RegisterViewController.swift
//  MoneyMan
//
//  Created by Chandra on 19/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set button style
        UIUtil.buttonStyle(btnRegister)
    }

    @IBAction func doRegister(_ sender: Any) {
        let username = txtUsername.text ?? ""
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        let confirmPassword = txtConfirmPassword.text ?? ""
        
        if inputValid(username,email,password,confirmPassword) {
            register(username,email,password)
        }
    }
    
    func register(_ username : String, _ email : String, _ password : String) {
        showLoadingAlert()
        Auth.auth().createUser(withEmail: email, password: password){
            (authResult, error) in
            
            if let error = error {
                self.dismissLoadingAlert()
                self.showErrorDialog("Error Message","\(error.localizedDescription)")
                return
            }
            
            self.setUsernameToFirebase(username)
        }
    }
    
    func setUsernameToFirebase (_ username : String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { (error) in
            self.dismissLoadingAlert()
            //show main page
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as! UITabBarController
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func inputValid(_ username : String, _ email : String, _ password : String, _ confirmPassword : String) -> Bool{
        
        if username.count < 6 {
            showErrorDialog("Error Message","Username must be at least 6 character")
            return false
        }
        
        if email == ""  {
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
        
        if confirmPassword != password {
            showErrorDialog("Error Message","Confirm password must be same with password")
            return false
        }
        
        return true
    }
}
