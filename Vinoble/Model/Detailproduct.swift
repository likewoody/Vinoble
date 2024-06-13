//
//  Detailproduct.swift
//  Vinoble
//
//  Created by 이대근 on 6/12/24.
//

import Foundation

struct Detailproduct: Codable{
    
    var index: Int, year: Int
    var rating, bodyPercent, tanning, sugar, pH: Double
    var wineImage, name, wineType, winery, region, price, grapeTypes, description, alcohol, food1, food2, food3, food4, food5: String
    var foodname1: String
    var foodname2: String
    var foodname3: String
    var foodname4: String
    var foodname5: String
    
    init(index: Int, year: Int, rating: Double, bodyPercent: Double, tanning: Double, sugar: Double, pH: Double, wineImage: String, name: String, wineType: String, winery: String, region: String, price: String, grapeTypes: String, description: String, alcohol: String, food1: String, food2: String, food3: String, food4: String, food5: String, foodname1: String, foodname2: String, foodname3: String, foodname4: String, foodname5: String) {
        self.index = index
        self.year = year
        self.rating = rating
        self.bodyPercent = bodyPercent
        self.tanning = tanning
        self.sugar = sugar
        self.pH = pH
        self.wineImage = wineImage
        self.name = name
        self.wineType = wineType
        self.winery = winery
        self.region = region
        self.price = price
        self.grapeTypes = grapeTypes
        self.description = description
        self.alcohol = alcohol
        self.food1 = food1
        self.food2 = food2
        self.food3 = food3
        self.food4 = food4
        self.food5 = food5
        self.foodname1 = foodname1
        self.foodname2 = foodname2
        self.foodname3 = foodname3
        self.foodname4 = foodname4
        self.foodname5 = foodname5
    }
        
}

extension Detailproduct: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}
