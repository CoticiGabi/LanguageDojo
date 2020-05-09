//
//  AddViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/2/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import DropDown
import FirebaseDatabase
import FirebaseAuth

class AddViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var wordCounterTextView: UITextField!
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var selectLanguageButton: UIButton!
    let rightBarDropDown = DropDown()

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var circularProfileImage: UIImageView!
    var selectedImage: UIImage?
    let tableView = UITableView()
    var selectedButton = UIButton()
    
    let transparentView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        circularProfileImage.layer.masksToBounds = true
        circularProfileImage.layer.cornerRadius = circularProfileImage.bounds.width / 2
        textView.delegate = self
        textView.text = "What's happening ?"
        textView.textColor = UIColor.lightGray
        self.textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//
//        customView.backgroundColor = UIColor.red
        customView.layer.borderWidth = 1.0
        customView.layer.borderColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0).cgColor
        wordCounterTextView.layer.cornerRadius = 10.0
        wordCounterTextView.layer.borderWidth = 0.0
        wordCounterTextView.layer.borderColor = UIColor.red.cgColor
        wordCounterTextView.isEnabled = false

        textView.inputAccessoryView = customView
        self.view.bringSubviewToFront(textView)
        
        
        //Dropdown
        
        rightBarDropDown.anchorView = selectLanguageButton
        rightBarDropDown.dataSource = ["English", "Spanish"]
        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }

        
    }
    
    //POST button
    
    @IBAction func postButton_TouchUpInside(_ sender: Any) {
        sendDataToDatabase()
        
         let storyboard = UIStoryboard(name: "Start", bundle: nil)
         let homeViewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)    }
    
    //Save the post ot database
    func sendDataToDatabase() {
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key!
        let newPostReference = postsReference.child(newPostId)
        newPostReference.setValue(["language": self.selectLanguageButton.currentTitle, "message": textView.text!])
    }
    
    // Select the langauge fot he post
    @IBAction func onClickSelectLanguage(_ sender: Any) {

           rightBarDropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectLanguageButton.setTitle(item, for: UIControl.State.normal)
        }

           rightBarDropDown.width = 140
           rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
           rightBarDropDown.show()
        }
    

    
    @IBAction func photoPickerButton(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        


        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view

        if 280 - updatedText.count < 10 && 280 - updatedText.count >= 0{
            wordCounterTextView.text = String(280 - updatedText.count + 1)
            wordCounterTextView.layer.borderWidth = 2.0

        } else if  280 - updatedText.count + 1 <= 0{
            wordCounterTextView.text = String(0)
            wordCounterTextView.layer.borderWidth = 2.0

        } else {
            wordCounterTextView.layer.borderWidth = 0.0
            wordCounterTextView.text = ""
        }
        
        if updatedText.isEmpty {

            textView.text = "What's happening ?"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
        // if the number of characters > 280 stop writing
        /// TO DO :  add some detail that will inform the user that he can't wrtite any more words
        else if(updatedText.count == 282 && range.length == 0) {
            print("Please summarize in 20 characters or less")
            return false;
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    
    @IBAction func closeAddViewController(_ sender: Any) {
        
         let storyboard = UIStoryboard(name: "Start", bundle: nil)
         let homeViewController = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        homeViewController.modalPresentationStyle = .fullScreen
        self.present(homeViewController, animated: true, completion: nil)
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

}

extension AddViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did finish picking Media!AKJHGAKJHAGKJHAGKJHAGKJAHGKAJHGAKJHGAKJHGAKJHAG")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
        }
    }
}

extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
