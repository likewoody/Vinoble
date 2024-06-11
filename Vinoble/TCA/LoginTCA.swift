//
//  LoginTCA.swift
//  Vinoble
//
//  Created by won on 6/11/24.
//

import ComposableArchitecture

@Reducer
struct LoginTCA {
    
    @ObservableState
    struct state: Equatable{
        var userid: String = ""
        var userpw: String = ""
        
        enum Action: BindableAction {
            case binding(BindingAction<State>)
            case insertNewTasteNote
        }

        
    } // struct state
    
} // struct LoginTCA
