//
//  ProductTCA.swift
//  Vinoble
//
//  Created by Woody on 6/8/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ProductFeature{
    
    @ObservableState
    struct State: Equatable{
        var searchProduct: String = ""
        // MARK: 0 or 1 (red or white)
        var selectedWineType: Int = 0
        var selectedRegion: Int = 0
        var isTextFieldFocused: Bool = false
        
        // Products
        var products: [Product] = []
        var isLoading: Bool = true
        
        // products load
//        var startCount: Int = 0
//        var lastCount: Int = 4
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
        case fetchProducts
        case sendProducts([Product])
//        case pageLoading
        case wineTypeButtonTapped(Int)
        case wineRegionButtonTapped(Int)
        case searchProductTapped
    }
    
    var body: some Reducer<State, Action>{
        
        BindingReducer()
        
        Reduce { state, action in
            switch action{
            case .binding(_):
                return .none
                
            case .fetchProducts:
                let searchProduct = state.searchProduct
//                let startCount = state.startCount
//                let lastCount = state.lastCount
                let region = state.selectedRegion
                let wineType = state.selectedWineType
                
                print(searchProduct)
                return .run { send in
                    
                    let products = await tryHttpSession(httpURL: "http://127.0.0.1:5000/selectVinoble?region=\(region)&wineType=\(wineType)")
//                    "http://127.0.0.1:5000/selectVinoble?startCount=\(startCount)&lastCount=\(lastCount)&region=\(region)&wineType=\(wineType)"
                    await send(.sendProducts(products))
                } // return
                
            case let .sendProducts(products):
                state.products = products
                state.isLoading = false
                
                return .none
                
//            case .pageLoading:
//                state.startCount += 4
//                state.lastCount += 4
//                return .none
                
            case let .wineTypeButtonTapped(wineType):
                state.selectedWineType = wineType
                return .none
                
            case let .wineRegionButtonTapped(region):
                state.selectedRegion = region
                return .none
                

            case .searchProductTapped:
//                let startCount = state.startCount
//                let lastCount = state.lastCount
                let searchProduct = state.searchProduct
                
                return .run { send in
                    
                    let products = await tryHttpSession(httpURL: "http://127.0.0.1:5000/searchProduct?searchProduct=\(searchProduct)")
//                    "http://127.0.0.1:5000/searchProduct?searchProduct=\(searchProduct)&startCount=\(startCount)&lastCount=\(lastCount)"
                    
                    await send(.sendProducts(products))
                } // return
            }

        }

    } // body
    
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
    
} // ProductFeature
