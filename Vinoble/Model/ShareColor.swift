//
//  ShareColor.swift
//  Vinoble
//
//  Created by Woody on 6/9/24.
//

import SwiftUI
import ComposableArchitecture

struct ShareColor{
    
    let store: StoreOf<ProductFeature>
    
    
    
    // --- Functions ----
    func initColorWithAlpha() -> UIColor {
        return UIColor(red: store.burgundyR, green: store.burgundyG, blue: store.burgundyB, alpha: 1)
    }
    
    func mainColor() -> Color{
        return Color(red: store.burgundyR, green: store.burgundyG, blue:store.burgundyB)
    }
    
    func productBackGroundColor() -> Color{
        return Color(red: store.productR, green: store.productG, blue:store.productB)
    }
    
}
