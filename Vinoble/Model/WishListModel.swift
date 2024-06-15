//
//  WishListModel.swift
//  Vinoble
//
//  Created by Woody on 6/13/24.
//


struct WishListModel: Codable{
    var id: Int
    var productID: Int
    var isWish: Int
    var userEmail: String
    
    init(id: Int, productID: Int, isWish: Int, userEmail: String) {
        self.id = id
        self.productID = productID
        self.isWish = isWish
        self.userEmail = userEmail
    }
}

extension WishListModel: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
