//
//  ResultsManager.swift
//  Bitz
//
//  Created by Sahil Gupta on 8/15/20.
//  Copyright © 2020 Sahil Gupta. All rights reserved.
//

import Foundation

protocol ResultsManagerDelegate {
    func didUpdateSearchResults(_ resultsManager: ResultsManager, _ results: ResultsModel)
    func didFailWithError(_ error: Error)
}

struct ResultsManager {
    var delegate: ResultsManagerDelegate?
    var results: ResultsModel?
    
    var baseUrlString: String?
    let appID = "dd917dd6"
    let appKey = "910ad32671af85e6f06bf74e18995b8a"
    
    mutating func fetchResults(foodName: String){
        baseUrlString = "https://api.nutritionix.com/v1_1/search/"
        baseUrlString! += "\(foodName)?"
        var urlString = baseUrlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        urlString! += "results=0:30"
        urlString! += "&fields=item_name,brand_name,item_id,nf_calories,nf_protein,nf_total_carbohydrate,nf_total_fat,nf_serving_weight_grams"
        urlString! += "&appId=\(appID)"
        urlString! += "&appKey=\(appKey)"
        print(urlString!)
        performRequest(urlString!)
    }
    
    func performRequest(_ urlStr: String) {
        //1. creating the URL
        if let url = URL(string: urlStr){
            //2. creating URLSession
            let session = URLSession(configuration: .default)
            //3, giving session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let foods = self.parseJSON(safeData){
                        self.delegate?.didUpdateSearchResults(self, foods)
                    }
                }
            }
            //4. starting the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> ResultsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ResultsData.self, from: data)
            var foods: [Food] = []
            for hit in decodedData.hits {
                if hit.fields.nf_serving_weight_grams == nil {
                    foods.append(Food(name: hit.fields.item_name,
                    brand: hit.fields.brand_name,
                    calories: hit.fields.nf_calories,
                    gramsProtein: hit.fields.nf_protein,
                    gramsCarbs: hit.fields.nf_total_carbohydrate,
                    gramsFat: hit.fields.nf_total_fat,
                    gramsPerServing: "No Available Serving Mass"))
                }
                else{
                    foods.append(Food(name: hit.fields.item_name,
                    brand: hit.fields.brand_name,
                    calories: hit.fields.nf_calories,
                    gramsProtein: hit.fields.nf_protein,
                    gramsCarbs: hit.fields.nf_total_carbohydrate,
                    gramsFat: hit.fields.nf_total_fat,
                    gramsPerServing: String(hit.fields.nf_serving_weight_grams!)))
                }
            }
            let resultsObj = ResultsModel(foods: foods)
            return resultsObj
        }
        catch{
            delegate?.didFailWithError(error)
            return nil
        }
    }
  
    
}
