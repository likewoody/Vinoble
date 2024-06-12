//
//  RecommendView.swift
//  Vinoble
//
//  Created by Woody on 6/11/24.
//

/*
 Author : Woody
 Date : 2024.06.11 Tuesday
 Description : when users input keywords, we will recommend by them
 */

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct RecommendView: View {
    
    
    @Bindable var store: StoreOf<RecommendDomain>
    
    // MARK: if start view, change navigation title
    init(store: StoreOf<RecommendDomain>) {
        // store 속성을 초기화합니다. 예를 들어, 기본값을 사용하거나 인자를 받을 수 있습니다.
        self.store = store
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme), // Title color
            .font: UIFont.boldSystemFont(ofSize: 24.0) // Title font size
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Need Help Deciding?")
                    .font(.title)
                    .foregroundStyle(.theme)
                    .padding(.top, 30)
                
                VStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 300, height: 35)
                        .overlay {
                            HStack(content: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.theme)
                                    .padding(.leading,12)
                                
                                
                                TextField("Search Product", text: $store.searchRecommend)
                                    .multilineTextAlignment(.leading)
                                    .onSubmit {
                                        store.send(.fetchRecommend)
                                    } // onSubmit of TextField
//                                NavigationLink(destination: ShowRecommendation(store: Store(initialState: RecommendDomain.State()){
//                                    RecommendDomain()
//                                })) {
                                Button("Search") {
                                    store.send(.fetchRecommend)
                                }
                                .foregroundStyle(.theme)
                                .padding(.trailing, 15)
//                                }
                                
                            }) // HStack
                        } // overlay
                        .padding(.top,15)
                    
                    Text("Hot Keywords")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.top, .leading], 40)
                        .foregroundStyle(.red)
                    ScrollView(.horizontal, content: {
                        
                        // Array(repeating: GridItem(), count: 3) GridView로 1 row 몇개의 item? count 3
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: 50))], spacing: 10, content: {
                            // List, Grid는 무조건 ForEach로 반복해서 데이터를 보여진다.
                            HStack(spacing: 10, content: {
                                ForEach(Array(store.newKeywords), id: \.key, content: { keywords in
                                    let (keyword, condition) = keywords
                                    
                                    Button(keyword) {store.send(.keywordButtonTapped(keyword))}
                                        .frame(width: 120, height: 40)
                                        .background(condition ? .theme : .clear)
                                        .foregroundStyle(condition ? .white : .gray)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                                .stroke(Color.gray, lineWidth: 1) // stroke 색상과 너비 설정
                                        )
                                    
                                })  // ForEach
                                
                            }) // HStack
                            
                        }) // LazyVGrid
                        .padding([.trailing, .leading], 15)
                        
                    }) // VStack
                    Divider()
                    
                    // MARK: Product list
                    if store.isLoading{
                        GeometryReader(content: { geometry in
                            ProgressView()
                                .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }) // GeometryReader
                    }else{
                        ScrollViewReader(content: { proxy in
                            ScrollView {
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                                    ForEach(store.recommendProducts, id:\.index) { recommendation in
    
                                        NavigationLink(destination: MainView()) {
                                            VStack(content: {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .foregroundStyle(.theme.opacity(0.2))
                                                    .frame(width: 120, height: 150)
                                                    .padding(.top, 30)
                                                    .overlay {
                                                        let url = URL(string: recommendation.wineImage)
                                                        WebImage(url: url)
                                                            .resizable()
                                                            .frame(width: 50, height: 200)
                                                            .padding(.bottom, 50)
    
                                                    }
                                                    .padding(.bottom, 5)
    
    
                                                Text(recommendation.name)
                                                    .foregroundStyle(.black)
                                                    .padding(.bottom, 30)
    
                                            }) // VStack
    
    
                                        } // Link
    
                                    } // ForEach
                                    
                                    
                                    
                                }) // Lazy V Grid
                                .padding(.top, 30)
                                
                            } // ScrollView
                            
                        }) // ScrollViewReader

                    } // else
                    
                } // VStack
                .navigationTitle("VINOBLE")
                .navigationBarTitleDisplayMode(.inline)
                
            } // VStack
            .onAppear(perform: {
                store.send(.fetchKeywords)
            })
        } // NavigationView
        
    } // body
} // RecommendView
    
#Preview {
    RecommendView(store: Store(initialState: RecommendDomain.State()){
        RecommendDomain()
    })
}
