//
//  FoodModel.swift
//  Bitz
//
//  Created by Sahil Gupta on 1/9/21.
//  Copyright © 2021 Sahil Gupta. All rights reserved.
//

import Foundation

struct CustomFoodModel {
    
    let name: String
    let brand: String
 
    var unit: Unit
    let isFluid: Bool
    var defAmount: Float
    var defMacros: Macros
    var amount: Float
    var macros: Macros
    
    init(originalFood: Food) {
        name = originalFood.name
        brand = originalFood.brand
        unit = Unit.grams
        isFluid = false
        defAmount = originalFood.grams
        defMacros = Macros(calories: originalFood.calories,
                           gramsProtein: originalFood.gramsProtein,
                           gramsCarbs: originalFood.gramsCarbs,
                           gramsFat: originalFood.gramsFat)
        amount = defAmount
        macros = defMacros
    }
    
    mutating func updateQuantities() {
        var gramAmount: Float
        switch unit {
        case .grams:
            gramAmount = amount
        case .ounces:
            gramAmount = 28.35 * amount
        //temporarily treating millilters as equal to grams
        case .milliliters:
            gramAmount = amount
        //temporarily treating fluid oz as equal to solid oz
        case .fluidOunces:
            gramAmount = 28.35 * amount
        }
        
        macros.calories = (gramAmount/defAmount) * defMacros.calories
        macros.gramsProtein = (gramAmount/defAmount) * defMacros.gramsProtein
        macros.gramsCarbs = (gramAmount/defAmount) * defMacros.gramsCarbs
        macros.gramsFat = (gramAmount/defAmount) * defMacros.gramsFat
    }
    
    mutating func setUnit(selectedUnit: Unit) {
        unit = selectedUnit
    }
    
    //in grams unless setUnit() was called for a different unit before setAmount()
    mutating func setAmount(newAmt: Float) {
        amount = newAmt
        updateQuantities()
    }
    
}

enum Unit: String, CaseIterable {
    case grams
    case ounces
    case milliliters
    case fluidOunces
}

struct Macros {
    var calories: Float
    var gramsProtein: Float
    var gramsCarbs: Float
    var gramsFat: Float
}
