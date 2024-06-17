//
//  TEST.swift
//  Vinoble
//
//  Created by won on 6/11/24.
//

import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var isLoading = false
    @Published var data: String = ""

    func fetchData() {
        isLoading = true
        Task {
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3초 대기
            data = "로딩완료"
            isLoading = false
        }
    }
}

struct ContentView: View {
    @ObservedObject var networkManager = NetworkManager()

    var body: some View {
        
        VStack {
            if networkManager.isLoading {
                ProgressView()
            } else {
                Text(networkManager.data)
            }
        }
        .onAppear(perform: {
            networkManager.fetchData()
            networkManager.data = "123"
        })
    }
}

#Preview {
    ContentView()
}
