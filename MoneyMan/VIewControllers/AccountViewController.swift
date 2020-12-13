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

    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var accountPicture: UIImageView!
    @IBOutlet weak var accountTableView: UITableView!
    
    var options: [AccountOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        options.append(AccountOption("Edit Profile",""))
        options.append(AccountOption("Edit Password",""))
        options.append(AccountOption("Help",""))
        options.append(AccountOption("About",""))
        
        accountPicture.layer.cornerRadius = 60
        accountPicture.layer.masksToBounds = true
        
        accountName.text = Auth.auth().currentUser?.displayName ?? "Name not set"
        accountEmail.text = Auth.auth().currentUser?.email ?? "Email not set"
        
        configureTableView()
    }
    
    // TableView Configurations
    func configureTableView(){
        accountTableView.delegate = self
        accountTableView.dataSource = self
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

extension AccountViewController: UITableViewDelegate, UITableViewDataSource{
    // Actions
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
//            remove(options[indexPath.row])
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Enable editing
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Sections/Rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    // Cell Content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionItem", for: indexPath) as! AccountOptionTableViewCell
        cell.setAccountOption(options[indexPath.row])
        return cell
    }
    
    // Select Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
