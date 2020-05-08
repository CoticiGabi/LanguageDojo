//
//  SignInViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 4/30/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.tintColor =  UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        passwordTextField.tintColor =  UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        signInButton.isEnabled = false
        signInButton.backgroundColor = UIColor.lightGray
        handleTextField()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    
    func handleTextField() {

        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButton.backgroundColor = UIColor.lightGray
            signInButton.isEnabled = false
            return
        }
        
        signInButton.backgroundColor = UIColor.init(red: 187/255, green: 173/255, blue: 255/255, alpha: 1.0)
        signInButton.isEnabled = true

    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        print("AAAAAAAAAAAa")
        view.endEditing(true)
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                return
            } else {
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
                print(user?.user.email)
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
