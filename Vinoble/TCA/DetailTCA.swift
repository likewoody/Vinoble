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
        var detailProduct: [Detailproduct] = []
        var isLoading: Bool = true
        
        var foodArray = [["",""]]
        
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
        case fetchDetailProducts
        case fetchResponse([Detailproduct])
        
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce{ state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .fetchDetailProducts:
                return .run { send in
                    let detailProduct = await tryHttpSession(httpURL: "http://192.168.10.15:5000/detailview")
                    await send(.fetchResponse(detailProduct))
                }
                
            case let .fetchResponse(detailProduct):
                state.detailProduct = detailProduct
                                
                state.foodArray = [
                    [detailProduct[0].food1, detailProduct[0].foodname1],
                    [detailProduct[0].food2, detailProduct[0].foodname2],
                    [detailProduct[0].food3, detailProduct[0].foodname3],
                    [detailProduct[0].food4, detailProduct[0].foodname4],
                    [detailProduct[0].food5, detailProduct[0].foodname5]
                ]
                
                state.isLoading = false
                return .none
            }
        }
    } // Body
    
    // --- Fucntions ----
    func tryHttpSession(httpURL: String) async -> [Detailproduct] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: httpURL)!)
            let detailProducts = try JSONDecoder().decode([Detailproduct].self, from: data)
            
            return detailProducts
//            await send(.sendProducts(products))
            
        } catch {
            print("JSON 디코딩 오류:", error)
            // 오류를 적절하게 처리합니다 (예: 사용자에게 오류 메시지 표시)
            return []
            
        } // catch

    }
    
} // DetailFeature
