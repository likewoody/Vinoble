//
//  DetailTCA.swift
//  Vinoble
//
//  Created by 이대근 on 6/10/24.
//

import ComposableArchitecture

@Reducer
struct DetailFeature {
    
    @ObservableState
    struct State: Equatable{
        var selectedWineInfo: Int = 0
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce{ state, action in
            switch action {
                
            case .binding(_):
                return .none
                
                
            
            }
        }
    }
}
