//
//  Product.swift
//  Vinoble
//
//  Created by Woody on 6/11/24.
//

import Foundation


struct Product: Codable{
    var index, year: Int
    var rating, bodyPercent, tanning, sugar, pH: Double
    var wineImage, name, wineType, winery, region, price, grapeTypes, description, alcohol, food1, food2, food3, food4, food5: String
//    var compareFoods
    
    init(index: Int, year: Int, rating: Double, bodyPercent: Double, tanning: Double, sugar: Double, pH: Double, wineImage: String, name: String, wineType: String, winery: String, region: String, price: String, grapeTypes: String, description: String, alcohol: String, food1: String, food2: String, food3: String, food4: String, food5: String) {
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
    }
}

extension Product:Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}
