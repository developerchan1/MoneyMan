//
//  ChangePasswordViewController.swift
//  MoneyMan
//
//  Created by Chandra on 18/12/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIUtil.buttonStyle(btnSave)
        user = Auth.auth().currentUser
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let oldPassword = txtOldPassword.text!
        let newPassword = txtNewPassword.text!
        let confirmPassword = txtConfirmPassword.text!
        
        oldPasswordIsValid(oldPassword, {(valid) in
            if !valid {
                self.showErrorDialog("Error Message", "Old Password is not valid")
                return
            }
            
            if self.inputValid(newPassword, confirmPassword) {
                self.showLoadingAlert()
                self.user!.updatePassword(to: newPassword) { (error) in
                    self.dismissLoadingAlert()
                    if error == nil {
                       self.showSuccessDialog("Success",
                       "Your password successful changed",
                       [
                             "Back to Edit Profile" : {
                                self.navigationController?.popViewController(animated: true)
                             }
                       ])
                       return
                    }
                    else{
                        self.showErrorDialog("Error Message", "Failed to change the password")
                    }
                }
            }
        })
    }
    
    func inputValid(_ newPassword : String, _ confirmPassword : String) -> Bool{
        
        if newPassword.count < 8 {
           showErrorDialog("Error Message","New Password must be at least 8 characters")
           return false
        }
        
        if confirmPassword != newPassword {
           showErrorDialog("Error Message","Confirm password must be same with new password")
           return false
        }
        
        return true
    }
    
    func oldPasswordIsValid(_ password : String, _ completion : @escaping (Bool)->Void){
        let email = user?.email
        var valid = false
        
        let credential = EmailAuthProvider.credential(withEmail: email!, password: password)
        
        user?.reauthenticate(with: credential) { (result,error) in
            if error == nil{
                valid = true
            }
            completion(valid)
        }
    }
}
