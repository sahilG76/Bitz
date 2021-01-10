//
//  FoodModel.swift
//  Bitz
//
//  Created by Sahil Gupta on 1/9/21.
//  Copyright © 2021 Sahil Gupta. All rights reserved.
//

import Foundation

struct FoodModel {
    
    enum Unit {
        case grams
        case ounces
        case milliliters
        case fluidOunces
    }
    
    let isFluid: Bool
    var amount: Float
    var macros: [Macros]
    
}

struct Macros {
    var calories: Float
    var gramsProtein: Float
    var gramsCarbs: Float
    var gramsFat: Float
}
