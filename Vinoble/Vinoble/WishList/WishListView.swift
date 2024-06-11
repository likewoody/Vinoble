//
//  WishListView.swift
//  Vinoble
//
//  Created by Woody on 6/8/24.
//

/*
 Author : Woody
 Date : 2024.06.08 Saturday
 Description : 1차 UI frame 작업 (2024.06.08 Saturday 10:30)
 */

import SwiftUI
import ComposableArchitecture

struct WishListView: View {
    
    let store: StoreOf<ProductFeature>

    
    // MARK: For test
    @State private var wineList: [[String]] = [
        ["Concha Y Toro", "bor", "2014", "flower_01"],
        ["Merlot", "rhone", "2024", "flower_02"],
        ["Cabernet sauvignon", "misa", "2011", "flower_03"],
        ["Pinot noir", "italy", "2021", "flower_04"],
        ["Pinot grigio", "eng", "1999", "flower_05"],
        ["Riesling", "bor", "2022", "flower_06"],
        ["Zinfandel", "bog", "2011", "flower_01"],
    ]
    
    
    // MARK: if start view, change navigation title
    init(store: StoreOf<ProductFeature>) {
        self.store = store
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme), // Title color
                                                            
            .font: UIFont.boldSystemFont(ofSize: 24.0) // Title font size
        
        ]
    }
    
    var body: some View {
        NavigationView(content: {
            List{
                ForEach(wineList, id: \.self) { wine in
                    VStack(content: {
                        HStack(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.theme.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Image(wine[3])
                                        .resizable()
                                        .frame(width: 50, height: 100)

                                }
                                .padding(.trailing, 40)
                            VStack(alignment:.leading,spacing: 10, content: {
                                Text(wine[0])
                                    .bold()
                                Text(wine[1])
                                Text(wine[2])
                            })
                        })
                    }) // VStack
                } // ForEach
            } // List
            .navigationTitle("VINOBLE")
            .navigationBarTitleDisplayMode(.inline)
            
        }) // Navigation View
    } // body
} // WishListView

#Preview {
    WishListView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}
