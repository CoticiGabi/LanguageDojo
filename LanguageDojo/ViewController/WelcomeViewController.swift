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
    var selectedMasterLanguagesList = [String]()
    var selectedApprenticeLanguagesList = [String]()
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
            print("Selected item: \(item) at index: \(index)")
            if (self.selectMasterLanguagesBtn.currentTitle?.contains(", "+item))! {
                self.selectMasterLanguagesBtn.setTitle(self.selectMasterLanguagesBtn.currentTitle?.replacingOccurrences(of: ", "+item, with: ""),  for: UIControl.State.normal)
                if let indexValue = self.selectedMasterLanguagesList.firstIndex(of: item) {
                self.selectedMasterLanguagesList.remove(at: indexValue)
                }
                
                if self.selectMasterLanguagesBtn.currentTitle == "" {
                    self.selectMasterLanguagesBtn.setTitle("You are a master", for: UIControl.State.normal)
                }
                return
            }
            else if (self.selectMasterLanguagesBtn.currentTitle?.contains(item + ","))! {
                self.selectMasterLanguagesBtn.setTitle(self.selectMasterLanguagesBtn.currentTitle?.replacingOccurrences(of: item+",", with: ""),  for: UIControl.State.normal)
                
                if let indexValue = self.selectedMasterLanguagesList.firstIndex(of: item) {
                self.selectedMasterLanguagesList.remove(at: indexValue)
                }
                
                if self.selectMasterLanguagesBtn.currentTitle == "" {
                    self.selectMasterLanguagesBtn.setTitle("You are a master", for: UIControl.State.normal)
                }
                return
            }else if (self.selectMasterLanguagesBtn.currentTitle?.contains(item))! {
                self.selectMasterLanguagesBtn.setTitle(self.selectMasterLanguagesBtn.currentTitle?.replacingOccurrences(of: item, with: ""),  for: UIControl.State.normal)
                
                if let indexValue = self.selectedMasterLanguagesList.firstIndex(of: item) {
                self.selectedMasterLanguagesList.remove(at: indexValue)
                }
                
                if self.selectMasterLanguagesBtn.currentTitle == "" {
                    self.selectMasterLanguagesBtn.setTitle("You are a master", for: UIControl.State.normal)
                }
                return
            }
            
            self.selectedMasterLanguagesList.append(item)
            
            if self.selectMasterLanguagesBtn.currentTitle == "" {
                self.selectMasterLanguagesBtn.setTitle(self.selectMasterLanguagesBtn.currentTitle! + item, for: UIControl.State.normal)
            } else {
            self.selectMasterLanguagesBtn.setTitle(self.selectMasterLanguagesBtn.currentTitle! + ", " + item, for: UIControl.State.normal)
            }
        }
        
        masterBarDropDown.width = selectMasterLanguagesBtn.frame.size.width
        masterBarDropDown.bottomOffset = CGPoint(x: 0, y:(masterBarDropDown.anchorView?.plainView.bounds.height)!)
        masterBarDropDown.show()
        print(selectedMasterLanguagesList)
    }
    
    // Select apprentice languages from dropdown
    @IBAction func onClickSelectApprenticeLanguages(_ sender: Any) {
        
        if selectApprenticeLanguagesBtn.currentTitle == "You are an apprentice" {
            selectApprenticeLanguagesBtn.setTitle("", for: UIControl.State.normal)
        }
        
        apprenticeBarDropDown.selectionAction = { (index: Int, item: String) in
         print("Selected item: \(item) at index: \(index)")
            
            if (self.selectApprenticeLanguagesBtn.currentTitle?.contains(", "+item))! {
               self.selectApprenticeLanguagesBtn.setTitle(self.selectApprenticeLanguagesBtn.currentTitle?.replacingOccurrences(of: ", "+item, with: ""),  for: UIControl.State.normal)
                
                if let indexValue = self.selectedApprenticeLanguagesList.firstIndex(of: item) {
                self.selectedApprenticeLanguagesList.remove(at: indexValue)
                }
                
               if self.selectApprenticeLanguagesBtn.currentTitle == "" {
                   self.selectApprenticeLanguagesBtn.setTitle("You are an apprentice", for: UIControl.State.normal)
                   }
                   return
               }
               else if (self.selectApprenticeLanguagesBtn.currentTitle?.contains(item + ","))! {
                   self.selectApprenticeLanguagesBtn.setTitle(self.selectApprenticeLanguagesBtn.currentTitle?.replacingOccurrences(of: item+",", with: ""),  for: UIControl.State.normal)
                
                if let indexValue = self.selectedApprenticeLanguagesList.firstIndex(of: item) {
                self.selectedApprenticeLanguagesList.remove(at: indexValue)
                }
                
                   if self.selectApprenticeLanguagesBtn.currentTitle == "" {
                       self.selectApprenticeLanguagesBtn.setTitle("You are an apprentice", for: UIControl.State.normal)
                   }
                   return
               }else if (self.selectApprenticeLanguagesBtn.currentTitle?.contains(item))! {
                   self.selectApprenticeLanguagesBtn.setTitle(self.selectApprenticeLanguagesBtn.currentTitle?.replacingOccurrences(of: item, with: ""),  for: UIControl.State.normal)
                
                if let indexValue = self.selectedApprenticeLanguagesList.firstIndex(of: item) {
                self.selectedApprenticeLanguagesList.remove(at: indexValue)
                }
                
                   if self.selectApprenticeLanguagesBtn.currentTitle == "" {
                       self.selectApprenticeLanguagesBtn.setTitle("You are an apprentice", for: UIControl.State.normal)
                   }
                   return
               }
            
            
       self.selectedApprenticeLanguagesList.append(item)
   
       if self.selectApprenticeLanguagesBtn.currentTitle == "" {
           self.selectApprenticeLanguagesBtn.setTitle(self.selectApprenticeLanguagesBtn.currentTitle! + item, for: UIControl.State.normal)
       } else {
        self.selectApprenticeLanguagesBtn.setTitle(self.selectApprenticeLanguagesBtn.currentTitle! + ", " + item, for: UIControl.State.normal)
            }
        }
        apprenticeBarDropDown.width = selectApprenticeLanguagesBtn.frame.size.width
        apprenticeBarDropDown.bottomOffset = CGPoint(x: 0, y:(apprenticeBarDropDown.anchorView?.plainView.bounds.height)!)
        apprenticeBarDropDown.show()
        print(selectedApprenticeLanguagesList)
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
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["profileImage": metaImageUrl, "masterLanguages": self.selectedMasterLanguagesList, "apprenticeLanguages": self.selectedApprenticeLanguagesList])

                }
            }
        })
        
//        let ref = Database.database().reference()
//        let masterLanguagesRef = ref.child("users").child(Auth.auth().currentUser!.uid).child("masterLanguages")
//        for masterLanguage in selectedMasterLanguagesList {
//            masterLanguagesRef.setValue([masterLanguage: true])
//        }
//
//        let apprenticeLanguagesRef = ref.child("apprenticeLanguages")
//        for apprenticeLanguage in selectedApprenticeLanguagesList {
//            let newApprenticeLanguageRef = apprenticeLanguagesRef.child(Auth.auth().currentUser!.uid)
//            newApprenticeLanguageRef.setValue(["apprenticeLanguage": apprenticeLanguage])
//        }
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    
}

