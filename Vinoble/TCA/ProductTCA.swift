//
//  ProductTCA.swift
//  Vinoble
//
//  Created by Woody on 6/8/24.
//

import ComposableArchitecture

@Reducer
struct ProductFeature{
    
    @ObservableState
    struct State: Equatable{
        var searchProduct: String = ""
        // MARK: 0 or 1 (red or white)
        var selectedWineType: Int = 0
        var selectedRegion: Int = 0
        var isTextFieldFocused: Bool = false
        
        // Color 설정
        var burgundyR: Double = 139 / 255.0
        var burgundyG: Double = 17 / 255.0
        var burgundyB: Double = 46 / 255.0
        
        // product background color
        var productR: Double = 255 / 255.0
        var productG: Double = 240 / 255.0
        var productB: Double = 243 / 255.0
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action>{
        
        BindingReducer()
        
        Reduce { state, action in
            switch action{
            case .binding(_):
                return .none
            
                
            }
        }

    }
    
}
