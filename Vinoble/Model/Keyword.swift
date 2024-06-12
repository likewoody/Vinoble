//
//  Keywords.swift
//  Vinoble
//
//  Created by Woody on 6/12/24.
//

import Foundation


struct Keyword: Codable{
    var keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
    }
}

extension Keyword: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyword)
    }
}
