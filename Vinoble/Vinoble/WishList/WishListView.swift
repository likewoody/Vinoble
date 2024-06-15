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
 
 Date : 2024.06.16 Saturday
 Description : 2차 DB 작업 (2024.06.16)
 */

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct WishListView: View {
    
    let store: StoreOf<ProductFeature>
    
    // MARK: if start view, change navigation title
    init(store: StoreOf<ProductFeature>) {
        self.store = store
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme), // Title color
                                                            
            .font: UIFont.boldSystemFont(ofSize: 24.0) // Title font size
        
        ]
    }
    
    var body: some View {
        NavigationStack{
            List{
                if store.isLoading{
                    ProgressView()
                }else {
                    ForEach(store.products, id:\.index) { product in
                        NavigationLink(destination:
                            ProductDetail(store: Store(initialState: DetailFeature.State()){
                                   DetailFeature()
                               },
                               noteStore: Store(initialState: TastingNoteFeature.State()){
                                   TastingNoteFeature()
                               }, index: product.index)
                        ) {
                            HStack(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .id(product.index)
                                    .foregroundStyle(.theme.opacity(0.2))
                                    .frame(width: 120, height: 150)
                                    .padding(.top, 30)
                                    .overlay {
                                        ZStack {
                                            let url = URL(string: product.wineImage)
                                                
                                            WebImage(url: url)
                                                .resizable()
                                                .frame(width: 50, height: 200)
                                                .padding(.bottom, 50)
                                            
                                        } // ZStack
                                        .padding(100)
                                    } // overlay
                                    .padding(.bottom, 5)
                                
                                Text(product.name)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 20))
                                    .padding()
                            }) // VStack
                            
                        } // NavigationLink
                        
                        
                    } // ForEach
                }
                
            } // List
            .navigationTitle("VINOBLE")
            .navigationBarTitleDisplayMode(.inline)
            
            
        } // Navigation Stack
        .onAppear(perform: {
            store.send(.searchOnlyWish)
        })
        
    } // body
} // WishListView

#Preview {
    WishListView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}
