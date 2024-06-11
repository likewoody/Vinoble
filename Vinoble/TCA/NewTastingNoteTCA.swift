//
//  NewTastingNoteFeature.swift
//  Vinoble
//
//  Created by Diana Kim on 6/10/24.
//

import ComposableArchitecture

@Reducer
struct NewTastingNoteFeature {
    @ObservableState
    struct State {
        var wineName: String = ""
        var wineYear: String = ""
        var winePrice: String = ""
        var wineNote: String = ""
        var wineSugar: Double = 0.0
        var wineBody: Double = 0.0
        var wineTannin: Double = 0.0
        var wineType: String = "" 
        var result: String = ""
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case insertNewTasteNote
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .insertNewTasteNote:
                state.result = "Wine Name: \(state.wineName), Wine Year: \(state.wineYear), Wine Price: \(state.winePrice), Wine Note: \(state.wineNote), Sugar: \(state.wineSugar), Body: \(state.wineBody), Tannin: \(state.wineTannin), Type: \(state.wineType)"
                print(state.result)
                return .none
            }
        }
    }
}
