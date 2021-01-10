//
//  NutrientViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/12/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit

class NutrientViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var carbsLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
    @IBOutlet var servingLabel: UILabel!
    
    var results: ResultsModel?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateLabels(i: index!)
    }
    
    func updateLabels(i: Int) {
        nameLabel.text = results?.foods[i].name
        brandLabel.text = results?.foods[i].brand
        caloriesLabel.text = "Calories: " + String(format: "%.0f", results?.foods[i].calories as! CVarArg)
        proteinLabel.text = "Protein(g): " + String(format: "%.0f", results?.foods[i].gramsProtein as! CVarArg)
        carbsLabel.text = "Carbs(g): " + String(format: "%.0f", results?.foods[i].gramsCarbs as! CVarArg)
        fatLabel.text = "Total Fat(g): " + String(format: "%.0f", results?.foods[i].gramsFat as! CVarArg)
        servingLabel.text = "grams/serving: " + (results?.foods[i].gramsPerServing)!
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
