//
//  ContentView.swift
//  Vinoble
//
//  Created by Woody on 6/4/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @State private var isActive = false

        var body: some View {
            VStack {
                if isActive {
                    ProductView(store: Store(initialState: ProductFeature.State()){
                        ProductFeature()
                    })
                } else {
                    SplashView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
}

#Preview {
    MainView()
}
