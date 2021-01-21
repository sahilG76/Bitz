//
//  SearchViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/12/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var resultsTable: UITableView!
    
    
//    var foodsManager = ResultsManager()
    var results: ResultsModel?
    var searchString: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultsTable.dataSource = self
        resultsTable.delegate = self
        resultsTable.register(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        if let selectedIndexPath = resultsTable.indexPathForSelectedRow {
            resultsTable.deselectRow(at: selectedIndexPath, animated: animated)
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


//MARK: - UITableViewDelegate
extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results?.foods.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTable.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        cell.title.text = results?.foods[indexPath.row].name
        cell.subtitle.text = "\(results?.foods[indexPath.row].brand as! String), \(results?.foods[indexPath.row].gramsPerServing as! String) grams"
        cell.calories.text = String(format: "%.0f", results?.foods[indexPath.row].calories as! CVarArg)
        return cell
    }
}

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NutrientViewController") as? NutrientViewController {
            viewController.results = results
            viewController.index = indexPath.row
            viewController.food = CustomFoodModel(originalFood: (results?.foods[indexPath.row])!)
            viewController.searchString = searchString
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
