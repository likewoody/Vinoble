//
//  MainTabView.swift
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

struct MainTabView: View {
    
    @State var selection: Int = 0
    
    let store: StoreOf<ProductFeature>
    
    
    // 다른 곳에서도 사용할 수 있게끔 Color를 func으로 만든 것을 불러온다.
    var body: some View {
        
        NavigationView(content: {
            
            ZStack(content: {
                
                TabView(selection: $selection,
                        content:  {
                    Group{
                        ProductView(store: Store(initialState: ProductFeature.State()){
                            ProductFeature()
                        })
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .tag(0)

                        ProfileView()
                            .tabItem {
                                Image(systemName: "person")
                                Text("Profile")
                            }
                            .tag(1)

                        // for making empty space
                        Circle()
                            .frame(width: 30, height: 30)


                        Second4Test()
                            .tabItem {
                                Image(systemName: "bookmark.fill")
                                Text("Wish List")
                            }
                            .tag(3)

                        Second4Test()
                            .tabItem {
                                Image(systemName: "tablecells")
                                Text("My Celler")
                            }
                            .tag(4)
                    } // Group
                    .toolbarBackground(.theme, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarColorScheme(.dark, for: .tabBar)
                    
                }) // TabView
                
                GeometryReader(content: { geometry in
                    
                    HStack(content: {
                        
                        Button{
                            selection = 2
                            
                        }label: {
                            Circle()
                                .foregroundStyle(.theme)
                                .frame(width: 60, height: 60)
                                .overlay {
                                    Circle()
                                        .frame(width: 42, height: 42)
                                        .foregroundStyle(.white)
                                        .overlay {
                                            NavigationLink(destination:
                                                RecommendView(store: Store(initialState: RecommendDomain.State()){
                                                    RecommendDomain()
                                            })) {
                                                Image("grape")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                            }

                                        } // inside overlay
                                } // outside overlay
                                
                        } // Button
                        .offset(y: geometry.size.height / 2.2)

                    }) // HStack
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
                    // Button을 offset 설정하고
                    // HStack의 frame 사이즈를 설정하니
                    // iPhone의 version이 바뀌어도 잘실행된다.
                    
                }) // GeometryReader for offset


            }) // ZStack
            
        }) // NavigationView
        
    } // body
} // MainTabView

#Preview {
    MainTabView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}
