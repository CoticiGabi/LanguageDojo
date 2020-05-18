//
//  SignUpViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 4/30/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.tintColor =  UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        usernameTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor =  UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        passwordTextField.tintColor =  UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        signUpButton.backgroundColor = UIColor.lightGray
        signUpButton.isEnabled = false
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpButton.backgroundColor = UIColor.lightGray
            signUpButton.isEnabled = false
            return
        }
        
        signUpButton.backgroundColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        signUpButton.isEnabled = true

    }
    

    @IBAction func alreadyHaveAnAccountButton(_ sender: Any) {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
        signInViewController.modalPresentationStyle = .fullScreen
        present(signInViewController, animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        view.endEditing(true)
        if (emailTextField != nil && passwordTextField != nil) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (Auth, Error) in
                if Error != nil {
                    return
                } else {
                    let ref = Database.database().reference()
                    let userRef = ref.child("users")
                    let uid = Auth?.user.uid
                    let newUserRef = userRef.child(uid!)
                    newUserRef.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "profileImage":"", "posts": []])
                    let welcomeController = self.storyboard?.instantiateViewController(withIdentifier: "welcome") as! UIViewController
                    welcomeController.modalPresentationStyle = .fullScreen
                    self.present(welcomeController, animated: true, completion: nil)
                }
            }
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.layer.borderColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0).cgColor
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            textField.layer.borderWidth = 2.0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
