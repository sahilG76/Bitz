//
//  ResultsDataV1.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/14/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import Foundation

struct ResultsData: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let _type: String
    let _id: String
    let _score: Double
    let fields: Fields
}

struct Fields: Codable {
    let item_id: String
    let item_name: String
    let brand_name: String
    let nf_calories: Float
    let nf_total_fat: Float
    let nf_total_carbohydrate: Float
    let nf_protein: Float
    let nf_serving_weight_grams: Float?
}
