//
//  CellarModel.swift
//  Vinoble
//
//  Created by Diana Kim on 6/12/24.
//

/*
 Author : Diana
 Date : 2024.06.12 Wed
 Description: Cellar Model
*/


import Foundation
struct Wine: Codable, Hashable {
    let wineindex: Int
    let name, year, price: String
    let sugar, body, tannin: Double
    let type, note: String
    let pH: Double
    let alcohol: String

    init(wineindex: Int, name: String, year: String, price: String, sugar: Double, body: Double, tannin: Double, type: String, note: String, pH: Double, alcohol: String) {
        self.wineindex = wineindex
        self.name = name
        self.year = year
        self.price = price
        self.sugar = sugar
        self.body = body
        self.tannin = tannin
        self.type = type
        self.note = note
        self.pH = pH
        self.alcohol = alcohol
    }
}


