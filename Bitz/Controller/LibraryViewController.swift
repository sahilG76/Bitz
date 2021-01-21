//
//  LibraryViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/12/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var savesTable: UITableView!
    
    
    var saves: [CustomFoodModel]?
    var foodNameGeneric: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        savesTable.dataSource = self
        savesTable.delegate = self
        savesTable.register(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated)
        if let selectedIndexPath = savesTable.indexPathForSelectedRow {
            savesTable.deselectRow(at: selectedIndexPath, animated: animated)
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
extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saves?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savesTable.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        cell.title.text = saves?[indexPath.row].name
        cell.subtitle.text = "\(saves?[indexPath.row].brand as! String), \(saves?[indexPath.row].amount as! String) \(saves?[indexPath.row].unit.rawValue)"
        cell.calories.text = String(format: "%.0f", saves?[indexPath.row].macros.calories as! CVarArg)
        return cell
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NutrientViewController") as? NutrientViewController {
            viewController.index = indexPath.row
            viewController.food = saves?[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

