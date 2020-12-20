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

    @IBOutlet weak var accountUsername: UILabel!
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var accountPicture: UIImageView!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var accountCard: UIView!
    
    var options: [AccountOption] = []
    var imageUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        options.append(AccountOption("Edit Profile","Edit Profile"))
        options.append(AccountOption("Help","Help"))
        options.append(AccountOption("About","About"))
        options.append(AccountOption("Logout","Logout"))
        
        
        UIUtil.circleImage(accountPicture)
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageUrl = Auth.auth().currentUser!.photoURL
             
        accountUsername.text = Auth.auth().currentUser?.displayName ?? "Name not set"
        accountEmail.text = Auth.auth().currentUser?.email ?? "Email not set"
        accountPicture.load(url: imageUrl)
        
        configureAccountCard()
   }

    func configureAccountCard(){
        //set corner radius and give gradient to the card
        UIUtil.roundedCornerCardStyle(accountCard)
        accountCard.layer.insertSublayer(gradientLayer(), at : 0)
    }
    
    func gradientLayer () -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = accountCard.bounds
        gradientLayer.contentsCenter = CGRect(x: 0, y: 0, width: 1, height: 1)
        gradientLayer.colors = [UIColor.debtGradient1.cgColor,
                                UIColor.balanceGradient1.cgColor]
        gradientLayer.locations = [0.0, 0.6]
        gradientLayer.cornerRadius = 20.0
        gradientLayer.add(gradientAnimation(), forKey: nil)
        
        
        return gradientLayer
    }
    
    func gradientAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0,1]
        animation.toValue = [-0.5,0.5]
        animation.duration = 5
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    // TableView Configurations
    func configureTableView(){
        accountTableView.delegate = self
        accountTableView.dataSource = self
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            goToLoginVC()
        } catch let signOutError as NSError {
            showErrorDialog("Error Message", "\(signOutError.localizedDescription)")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
        if indexPath.row == 0 {
            performSegue(withIdentifier: "editProfileSegue", sender: self)
        }
        else if indexPath.row == 3 {
            showConfirmationDialog("Logout Confirmation","Are you sure to logout from MoneyMan?",{self.logout()})
        }
    }
}
