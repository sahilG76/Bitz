//
//  ResultsModel.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/15/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import Foundation

struct ResultsModel {
    let foods: [Food]
}

struct Food {
    let name: String
    let brand: String
    let calories: Float
    let gramsProtein: Float
    let gramsCarbs: Float
    let gramsFat: Float
    let gramsPerServing: String
}
