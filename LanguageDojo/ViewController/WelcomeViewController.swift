//
//  WelcomeViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/10/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import DropDown
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class WelcomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var letsTrainBtn: UIButton!
    @IBOutlet weak var selectApprenticeLanguagesBtn: UIButton!
    @IBOutlet weak var selectMasterLanguagesBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    let masterBarDropDown = DropDown()
    let apprenticeBarDropDown = DropDown()
    var selectedMasterLanguage = ""
    var selectedApprenticeLanguage = ""
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //Master Dropdown
        
        masterBarDropDown.anchorView = selectMasterLanguagesBtn
        masterBarDropDown.dataSource = ["English", "Spanish", "Romanian", "French"]
        masterBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        masterBarDropDown.backgroundColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        masterBarDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            // Setup your custom UI components
            cell.optionLabel.textAlignment = .center
            }
        
        //Apprentice Dropdown
               
       apprenticeBarDropDown.anchorView = selectApprenticeLanguagesBtn
       apprenticeBarDropDown.dataSource = ["English", "Spanish", "Romanian", "French"]
       apprenticeBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
       apprenticeBarDropDown.backgroundColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
    
        
        //Profile Image
        
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.clipsToBounds = true
        selectedImage = UIImage(named: "profile_icon")
        
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.handleSelectProfileImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            profileImage.image = image
            selectedImage = image
        }
        print("did pick photo")
        print(info)
//        profileImage.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectProfileImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    // Select master languages from dropdown
    @IBAction func onClickSelectMasterLanguages(_ sender: Any) {
        
        
        if selectMasterLanguagesBtn.currentTitle == "You are a master" {
            selectMasterLanguagesBtn.setTitle("", for: UIControl.State.normal)
        }
        else if self.selectMasterLanguagesBtn.currentTitle == "" {
            self.selectMasterLanguagesBtn.setTitle("You are a master", for: UIControl.State.normal)
        }
        
        masterBarDropDown.selectionAction = { (index: Int, item: String) in
            self.selectedMasterLanguage = item
            self.selectMasterLanguagesBtn.setTitle(item, for: UIControl.State.normal)
            
            

        }
        
        masterBarDropDown.width = selectMasterLanguagesBtn.frame.size.width
        masterBarDropDown.bottomOffset = CGPoint(x: 0, y:(masterBarDropDown.anchorView?.plainView.bounds.height)!)
        masterBarDropDown.show()
        print(selectedMasterLanguage)
    }
    
    // Select apprentice languages from dropdown
    @IBAction func onClickSelectApprenticeLanguages(_ sender: Any) {
        
        if selectApprenticeLanguagesBtn.currentTitle == "You are an apprentice" {
            selectApprenticeLanguagesBtn.setTitle("", for: UIControl.State.normal)
        }
        
        apprenticeBarDropDown.selectionAction = { (index: Int, item: String) in
         print("Selected item: \(item) at index: \(index)")
            self.selectedApprenticeLanguage = item
            self.selectApprenticeLanguagesBtn.setTitle(item, for: UIControl.State.normal)

        }
        apprenticeBarDropDown.width = selectApprenticeLanguagesBtn.frame.size.width
        apprenticeBarDropDown.bottomOffset = CGPoint(x: 0, y:(apprenticeBarDropDown.anchorView?.plainView.bounds.height)!)
        apprenticeBarDropDown.show()
        print(selectedApprenticeLanguage)
    }
    
    
    //Go to Home.Storyboard
    @IBAction func onClickLetsTrain(_ sender: Any) {
        
        let storageRef = Storage.storage().reference(forURL: "gs://languagedojo-bab50.appspot.com")
        let storageProfileRef = storageRef.child("profileImage").child(Auth.auth().currentUser!.uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let profileImageRef = storageRef.child("profile_image")
        guard let profileImg = self.selectedImage else {
            return
        }
        
        guard let imageData = profileImg.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        storageProfileRef.putData(imageData, metadata: metadata, completion: { (storage, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    print(metaImageUrl)
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["profileImage": metaImageUrl, "masterLanguage": self.selectedMasterLanguage, "apprenticeLanguage": self.selectedApprenticeLanguage])

                }
            }
        })
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    
}

