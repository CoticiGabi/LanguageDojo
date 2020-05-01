//
//  SignUpViewController.swift
//  LanguageDojo
//
//  Created by Cotici Gabriel on 4/30/20.
//  Copyright © 2020 Cotici Gabriel. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func alreadyHaveAnAccountButton(_ sender: Any) {
        let signInViewController = storyboard?.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
        signInViewController.modalPresentationStyle = .fullScreen
        present(signInViewController, animated: true, completion: nil)
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
