//
//  NutrientViewController.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/12/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class NutrientViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var proteinLabel: UILabel!
    @IBOutlet var carbsLabel: UILabel!
    @IBOutlet var fatLabel: UILabel!
    @IBOutlet var servingLabel: UILabel!
    @IBOutlet var unitPicker: UIPickerView!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var results: ResultsModel?
    var index: Int?
    var food: CustomFoodModel?
    var searchString: String?

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        unitPicker.dataSource = self
        unitPicker.delegate = self
//        var thisFood = CustomFoodModel(originalFood: (results?.foods[index!])!)
//        thisFood.setAmount(newAmt: 100)
        self.title = nil
        updateLabels(modifiedFood: food!)
        amountTextField.placeholder = "\(food?.amount ?? 0)"
        amountTextField.keyboardType = UIKeyboardType.numberPad
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(self.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
        textFieldDidEndEditing(amountTextField)
    }
    
//    func updateLabels(i: Int) {
//        nameLabel.text = results?.foods[i].name
//        brandLabel.text = results?.foods[i].brand
//        caloriesLabel.text = "Calories: " + String(format: "%.0f", results?.foods[i].calories as! CVarArg)
//        proteinLabel.text = "Protein(g): " + String(format: "%.0f", results?.foods[i].gramsProtein as! CVarArg)
//        carbsLabel.text = "Carbs(g): " + String(format: "%.0f", results?.foods[i].gramsCarbs as! CVarArg)
//        fatLabel.text = "Total Fat(g): " + String(format: "%.0f", results?.foods[i].gramsFat as! CVarArg)
//        servingLabel.text = "grams/serving: " + (results?.foods[i].gramsPerServing)!
//    }
    
    func updateLabels(modifiedFood: CustomFoodModel) {
        nameLabel.text = modifiedFood.name
        brandLabel.text = modifiedFood.brand
        caloriesLabel.text = "Calories: " + String(format: "%.0f", modifiedFood.macros.calories as! CVarArg)
        proteinLabel.text = "Protein(g): " + String(format: "%.0f", modifiedFood.macros.gramsProtein as! CVarArg)
        carbsLabel.text = "Carbs(g): " + String(format: "%.0f", modifiedFood.macros.gramsCarbs as! CVarArg)
        fatLabel.text = "Total Fat(g): " + String(format: "%.0f", modifiedFood.macros.gramsFat as! CVarArg)
        servingLabel.text = "grams/serving: " + String(format: "%.0f", modifiedFood.amount as! CVarArg)
        unitLabel.text = modifiedFood.unit.rawValue
    }
    
    

    //MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Unit.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Unit.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        food?.setUnit(selectedUnit: Unit.allCases[row])
        food?.updateQuantities()
        updateLabels(modifiedFood: food!)
        unitLabel.text = food?.unit.rawValue
    }
    
    
    // MARK: - Saving Foods and Navigation to Library
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    
    
    @IBAction func saveFoodPressed(_ sender: Any) {
        if let userEmail = Auth.auth().currentUser?.email {
            errorLabel.text = ""
            food?.sender = userEmail
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: userEmail,
                K.FStore.foodField: food as Any
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving this food to Firestore, \(e)")
                }
                else {
                    print("This food has been saved!")
                }
            }
        }
        else {
            errorLabel.text = "Must sign-in to save custom food labels"
            return
        }
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "LibraryViewController") as? LibraryViewController {
//            viewController.results = results
//            viewController.index = indexPath.row
//            viewController.food = CustomFoodModel(originalFood: (results?.foods[indexPath.row])!)
//            viewController.searchString = searchString
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

}


//MARK: -UITextFieldDelegate
extension NutrientViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
//        self.view.endEditing(true)
//        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
           return true
        }
        else {
           textField.placeholder = "Type something."
           return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            food?.setAmount(newAmt: Float(amountTextField.text!)!)
            food?.updateQuantities()
        }
        updateLabels(modifiedFood: food!)
    }
}
    
