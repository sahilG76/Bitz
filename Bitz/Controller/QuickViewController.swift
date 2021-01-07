//
//  ViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 5/15/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit

class QuickViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var libraryButton: UIButton!
    @IBOutlet var calculatorButton: UIButton!
    @IBOutlet var userButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
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
        if segue.identifier == "goToSearch" {
            // Get the new view controller using segue.destination.
            let destinationVC = segue.destination as! SearchViewController
            // Pass the selected object to the new view controller.
            destinationVC.results = searchResults
            destinationVC.currentTitle = searchTitle
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
    }
    
}



//MARK: - UISearchBarDelegate
extension QuickViewController: UISearchBarDelegate {

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
        errorLabel.text = ""
        foodsManager.fetchResults(foodName: searchBar.text!)
    }
}



//MARK: - FoodsManagerDelegate
extension QuickViewController: ResultsManagerDelegate {
    func didUpdateSearchResults(_ resultsManager: ResultsManager, _ results: ResultsModel) {
        print(results.foods)
        searchResults = results
        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "goToTemp", sender: self)
            self.performSegue(withIdentifier: "goToSearch", sender: self)

        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
        DispatchQueue.main.async {
            self.errorLabel.text = "There was an issue with the data retrieved from this query. Please modify your search."
        }
    }
}

