//
//  EditProfileViewController.swift
//  MoneyMan
//
//  Created by Chandra on 17/12/20.
//  Copyright © 2020 KelompokMMS. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    @IBOutlet weak var accountPicture: UIImageView!
    @IBOutlet weak var btnChangePicture: UIButton!
    @IBOutlet weak var accountUsername: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var imagePicker = UIImagePickerController()
    var imageUrl : String?
    var providerId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIUtil.circleImage(accountPicture)
        UIUtil.circleButton(btnChangePicture)
        UIUtil.buttonStyle(btnSave)
        
        imageUrl = Auth.auth().currentUser!.photoURL?.absoluteString
        
        accountUsername.text = Auth.auth().currentUser?.displayName ?? ""
        accountPicture.load(url: Auth.auth().currentUser!.photoURL)
        
        if let providerData = Auth.auth().currentUser?.providerData {
            providerId = providerData[0].providerID
        }
    
    }
    
    @IBAction func changePictureButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        if providerId == "google.com"{
            showErrorDialog("Error Message", "You can't change password because you login using google account")
            return
        }
        performSegue(withIdentifier: "changePasswordSegue", sender: self)
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let username = accountUsername.text!
        
        if inputValid(username) {
            showLoadingAlert()
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.photoURL = URL.init(fileURLWithPath: imageUrl!)
            changeRequest?.commitChanges { (error) in
                self.dismissLoadingAlert()
                if error == nil {
                    self.writeImageInDocumentDirectory()
                    self.showSuccessDialog("Success",
                    "Your profile successful edited",
                    [
                          "Back to Main" : {
                            self.navigationController?.popToRootViewController(animated: true)
                          }
                    ])
                    return
                }
                self.showErrorDialog("Error Message", "Failed to edit profile picture and username")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           accountPicture.image = image
        } else {
          //showErrorAlert(title: "Error Message", msg: "Failed to get the image")
        }

        if let imgUrl = info[.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending("/\(imgName)")
            imageUrl = localPath
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func inputValid(_ username : String) -> Bool {
        if imageUrl == nil {
            showErrorDialog("Error Message","Image must be selected")
            return false
        }
        
        if username.count < 6 {
            showErrorDialog("Error Message","Username must be at least 6 character")
            return false
        }
        
        return true
    }
    
    func writeImageInDocumentDirectory(){
        let image = accountPicture.image!
        let data = image.pngData()! as NSData
        data.write(toFile: imageUrl!, atomically: true)
    }
}
