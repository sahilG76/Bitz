//
//  ViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 5/15/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var libraryButton: UIButton!
    @IBOutlet var calculatorButton: UIButton!
    @IBOutlet var userButton: UIButton!
    @IBOutlet var errUserLabel: UILabel!
    @IBOutlet var creditLabelLink: UILabel!
    @IBOutlet var creditTextView: UITextView!
    
    var foodsManager = ResultsManager()
    var searchResults: ResultsModel?
    var searchTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        foodsManager.delegate = self
        setCreditLinkText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
            errUserLabel.text = "Welcome \(user.displayName!)"
            print(multiFactorString)
        }
        else {
            errUserLabel.text = ""
        }
    }
    
    
    @IBAction func libraryButtonPressed(_ sender: Any) {
        if Auth.auth().currentUser != nil {
          // User is signed in.
            performSegue(withIdentifier: "SearchToLibrary", sender: self)
          // ...
        }
        if Auth.auth().currentUser == nil {
          // No user is signed in.
            errUserLabel.text = "Please login to use Saved Foods functionality"
          // ...
        }
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToTemp" {
//            // Get the new view controller using segue.destination.
//            let destinationVC = segue.destination as! TempViewController
//            // Pass the selected object to the new view controller.
//            destinationVC.results = searchResults
//            destinationVC.currentTitle = searchTitle
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            // Get the new view controller using segue.destination.
            let destinationVC = segue.destination as! ResultsViewController
            // Pass the selected object to the new view controller.
            destinationVC.results = searchResults
            destinationVC.searchString = searchTitle
        }
    }
    
    func setCreditLinkText() {
        let plainAttributedString = NSMutableAttributedString(string: "Powered by ", attributes: nil)
        let string = "Nutritionix API"
        let attributedLinkString = NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: URL(string: "https://www.nutritionix.com/business/api")!])
        let fullAttributedString = NSMutableAttributedString()
        fullAttributedString.append(plainAttributedString)
        fullAttributedString.append(attributedLinkString)
        creditLabelLink.isUserInteractionEnabled = true
        creditLabelLink.attributedText = fullAttributedString
        creditTextView.isUserInteractionEnabled = true
        creditTextView.isEditable = false
        creditTextView.attributedText = fullAttributedString
        creditTextView.centerXAnchor.constraint(equalTo: (creditTextView.superview?.centerXAnchor)!).isActive = true
        creditTextView.textAlignment = .center
    }
    
}



//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        print(searchBar.text!)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
         if searchBar.text != "" {
            return true
         }
         else {
            searchBar.placeholder = "Type something."
            return false
         }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchTitle = searchBar.text
        errUserLabel.text = ""
        foodsManager.fetchResults(foodName: searchBar.text!)
    }
}



//MARK: - FoodsManagerDelegate
extension SearchViewController: ResultsManagerDelegate {
    func didUpdateSearchResults(_ resultsManager: ResultsManager, _ results: ResultsModel) {
        print(results.foods)
        searchResults = results
        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "goToTemp", sender: self)
            self.performSegue(withIdentifier: "goToResults", sender: self)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.errUserLabel.text = "There was an issue with the data retrieved from this query. Please modify your search."
        }
    }
}

