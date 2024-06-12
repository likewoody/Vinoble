//
//  DetailTCA.swift
//  Vinoble
//
//  Created by 이대근 on 6/10/24.
//

import ComposableArchitecture
import Foundation


@Reducer
struct DetailFeature {
    
    @ObservableState
    struct State: Equatable{
//        var searchProduct: String = ""
        var selectedWineInfo: Int = 0

        
        // Products
        var products: [Product] = []
        var isLoading: Bool = true
        
//        var index: Int
//        var wineImage: String = ""
//        var name: String = ""
//        var rating: Double
//        var winery: String = ""
//        var wineType: String = ""
//        var alcohol: String = ""
//        var year: Int
//        var price: String = ""
//        var bodyPercent: Double
//        var tanning = Double
        
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
        case fetchProducts
        case sendProducts([Product])
        
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce{ state, action in
            switch action {
                
            case .binding(_):
                return .none
                
                
            
            case .fetchProducts:

                return .run { send in
                    
                    let products = await tryHttpSession(httpURL: "http://127.0.0.1:5000/detailview")
                    await send(.sendProducts(products))
                }
                
            case .sendProducts(let products):
                state.products = products
                state.isLoading = false
                
                return .none
            }
        }
    } // Body
    
    // --- Fucntions ----
    func tryHttpSession(httpURL: String) async -> [Product] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: httpURL)!)
            let products = try JSONDecoder().decode([Product].self, from: data)
            
            return products
//            await send(.sendProducts(products))
            
        } catch {
            print("JSON 디코딩 오류:", error)
            // 오류를 적절하게 처리합니다 (예: 사용자에게 오류 메시지 표시)
            return []
            
        } // catch

    }
    
} // DetailFeature
