//
//  AccountViewController.swift
//  MoneyMan
//
//  Created by Chandra on 20/11/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        showLogoutDialog()
    }
    
    func showLogoutDialog() {
        //show alert before logout
        let alertController = UIAlertController.init(title: "Logout", message: "Are you sure to logout from MoneyMan?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) {
            (action) in
            //logout the user
            self.logout()
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            goToLoginVC()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func goToLoginVC(){
        if Auth.auth().currentUser == nil {
           //show LoginViewController
           let loginViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as! LoginViewController
           
           self.view.window?.rootViewController = loginViewController
           self.view.window?.makeKeyAndVisible()
       }
    }
}
