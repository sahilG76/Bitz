//
//  LogRegViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/12/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LogRegViewController: UIViewController {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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

//MARK: - GIDSignInDelegate
extension LogRegViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        //handle sign-in errors
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
            print("error signing into Google \(error.localizedDescription)")
            }
        return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("authentication error \(error.localizedDescription)")
            }
            else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
