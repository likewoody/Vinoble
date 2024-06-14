//
//  WishListModel.swift
//  Vinoble
//
//  Created by Woody on 6/13/24.
//


struct WishListModel{
    var id: Int
    var wishlist: Int
    
    init(id: Int, wishlist: Int) {
        self.id = id
        self.wishlist = wishlist
    }
}

extension WishListModel: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
