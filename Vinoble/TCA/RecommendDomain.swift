//
//  Recommend.swift
//  Vinoble
//
//  Created by Woody on 6/11/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct RecommendDomain{
    
    @ObservableState
    struct State: Equatable{
        var keywords: [Keyword] = []
        var newKeywords: [String:Bool] = [:]
        var searchRecommend: String = ""
        var isLoading: Bool = false
        var recommendProducts: [Recommend] = []
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
        case fetchRecommend
        case fetchResponse([Recommend])
        case keywordButtonTapped(String)
        case fetchKeywords
        case fetchResponseKeywords([Keyword])
        case sqliteInsertTest
    }
    
    var body: some Reducer<State, Action>{
        
        BindingReducer()
        
        Reduce { state, action in
            switch action{
            case .binding(_):
                return .none
                
            case .fetchRecommend:
                //                let startCount = state.startCount
                //                let lastCount = state.lastCount
                let searchRecommend = state.searchRecommend
                
                state.isLoading = true
                return .run { send in
                    let recommendations = await tryHttpAccessRecommend(httpURL: "http://192.168.10.15:5000/recommend?searchRecommend=\(searchRecommend)")
                    
                    
                    await send(.fetchResponse(recommendations))
                    //                    "http://127.0.0.1:5000/selectVinoble?startCount=\(startCount)&lastCount=\(lastCount)&region=\(region)&wineType=\(wineType)"
                    
                    
                } // return
                
            case let .fetchResponse(recommendations):
                state.recommendProducts = recommendations
                state.isLoading = false
                
                return .run{ send in
                    await send(.sqliteInsertTest)
                }
                
            case .fetchKeywords:
                return .run { send in
                    
                    let keywords = await tryHttpAccessKeyword(httpURL: "http://192.168.10.15:5000/topKeyowrds")
                    await send(.fetchResponseKeywords(keywords))
                } // return
            case let .fetchResponseKeywords(keywords):
                
                state.keywords = keywords
                for i in state.keywords{
                    state.newKeywords[i.keyword] = false
                }
                print(state.newKeywords)
                return .none
                
            case let .keywordButtonTapped(tappedKeyword):
//                state.newKeywords[tappedKeyword].toggle()
                if state.newKeywords[tappedKeyword]!{
                    state.newKeywords[tappedKeyword] = false
                    state.searchRecommend = state.searchRecommend.replacingOccurrences(of: "\(tappedKeyword) ", with: "")
                }else {
                    state.newKeywords[tappedKeyword] = true
                    state.searchRecommend += tappedKeyword + " "
                }
                 
                return .none

            case .sqliteInsertTest:
                let sqliteModel = KeywordDB()
                let searchRecommend = state.searchRecommend
                return .run{ send in
                    if searchRecommend != ""{
                        let test = sqliteModel.queryDB()
                        print(test)
                        let result = sqliteModel.insertDB(searchKeyword: searchRecommend)
                        print(result ? "successfully inserted" : "insert failed...")
                    }
                    
                }
            } // Switch
        } // Reduce

    } // body
    
    // ---- Function ----
    func tryHttpAccessRecommend(httpURL: String) async -> [Recommend] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: httpURL)!)
            let recommendations = try JSONDecoder().decode([Recommend].self, from: data)
            
            return recommendations
//            await send(.sendProducts(products))
            
        } catch {
            print("JSON 디코딩 오류:", error)
            // 오류를 적절하게 처리합니다 (예: 사용자에게 오류 메시지 표시)
            return []
            
        } // catch

    } // Recommend
    
    
    func tryHttpAccessKeyword(httpURL: String) async -> [Keyword] {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: httpURL)!)
            let keywords = try JSONDecoder().decode([Keyword].self, from: data)
            
            return keywords
//            await send(.sendProducts(products))
            
        } catch {
            print("JSON 디코딩 오류:", error)
            // 오류를 적절하게 처리합니다 (예: 사용자에게 오류 메시지 표시)
            return []
            
        } // catch

    }
    
} // RecommendDomain

