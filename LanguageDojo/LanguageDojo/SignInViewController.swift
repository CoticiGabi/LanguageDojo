//
//  SignInViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 4/30/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        signUpViewController.modalPresentationStyle = .fullScreen
        present(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true, completion: nil)
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
