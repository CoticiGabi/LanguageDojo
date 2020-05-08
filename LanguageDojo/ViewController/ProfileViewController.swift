//
//  ProfileViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 5/2/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logOutButton_TouchUpInside(_ sender: Any) {

        do {
            try Auth.auth().signOut()
        } catch let logOutErr{
            print(logOutErr)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
        signInViewController.modalPresentationStyle = .fullScreen
        present(signInViewController, animated: true, completion: nil)
    }
}
