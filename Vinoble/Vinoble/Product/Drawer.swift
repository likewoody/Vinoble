//
//  Drawer.swift
//  Vinoble
//
//  Created by Woody on 6/12/24.
//

import SwiftUI
import ComposableArchitecture

struct Drawer: View {
    @Bindable var store: StoreOf<ProductFeature>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.2) // Drawer 배경
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        store.send(.dismissPaging)
                    }
                VStack(content: {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color.white) // 색상 지정
                        .frame(width: 310, height: .infinity) // 높이 지정
                        .padding(.leading, 120)
                        .ignoresSafeArea(.all)
                        .overlay {
                            VStack(content: {
                                HStack(content: {
                                    Spacer()
                                    Image(systemName: "person.circle")
                                        .font(.title)
                                        .foregroundStyle(.gray)
                                    
                                    Text(store.userEmail)
                                        .frame(maxWidth: 210)
                                    Spacer()
                                })
                                .padding(.leading, 140)
                                .padding(.top, 60)
                                
                                Spacer()
                                
                                NavigationLink(destination: LoginView()) {
                                    Text("Log Out")
                                }
                                .padding(.bottom, 60)
                                .padding(.leading, 240)
                                
                            }) // VStack
                            
                        }  // overlay
                }) // RoundedRectangle
            } // ZStack
            .onAppear(perform: {
                store.send(.fetchUserInfo)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } // Navigation Stack
    } // body
} // Drawer

#Preview {
    Drawer(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}

