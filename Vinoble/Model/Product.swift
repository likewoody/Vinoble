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
    var wineImage, name, wineType, winery, region, price, grapeTypes, description, alcohol, compareFoods: String
//    var compareFoods
    
    init(index: Int, year: Int, rating: Double, bodyPercent: Double, tanning: Double, sugar: Double, pH: Double, wineImage: String, name: String, wineType: String, winery: String, region: String, price: String, grapeTypes: String, description: String, alcohol: String, compareFoods: String) {
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
        self.compareFoods = compareFoods
    }
}

extension Product:Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}
