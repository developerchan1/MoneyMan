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
        Auth.auth().createUser(withEmail: email, password: password){
            (authResult, error) in
            
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            //add username to firestore
            Firestore.firestore().collection("user").document((authResult?.user.uid)!).setData(["username":username])
            //show main page
            let tabBarController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as! UITabBarController
            self.view.window?.rootViewController = tabBarController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func inputValid(_ username : String, _ email : String, _ password : String, _ confirmPassword : String) -> Bool{
            
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
        
    func showErrorDialog(_ title : String, _ msg : String){
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

}
