//  Vinoble
//
//  Created by Diana Kim on 6/9/24.
//

/*
 Author : Diana
 Date : 2024.06.11 Tues
 Description : TCA testing, binding textfields
  
 Author : Diana
 Date : 2024.06.12 Wed
 Description : .insert, .delete function
 
 */

import ComposableArchitecture
import Foundation

@Reducer
struct TastingNoteFeature {
    
    @ObservableState
    struct State: Equatable {
        var seq: Int = 0
        var wineName: String = ""
        var wineYear: String = ""
        var winePrice: String = ""
        var wineNote: String = ""
        var wineSugar: Double = 0.0
        var wineBody: Double = 0.0
        var wineTannin: Double = 0.0
        var wineType: String = ""
        var wineAlcohol: String = ""
        var winepH: Double = 0.0
        var result: String = ""
        var cellarList: [Wine] = []
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case insertCellar
        case selectCellar
        case deleteCellar(Wine)
        case cellarResponse(Result<String, NSError>)
        case fetchCellarListResponse(Result<[Wine], NSError>)
        case setSelectedWine(Wine)
        case updateCellar(Wine)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            // QUERY
            case .selectCellar:
                return .run { send in
                    let url = URL(string: "http://192.168.10.15:5000/select")!
                    do {
                        let (data, response) = try await URLSession.shared.data(from: url)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let cellarList = try JSONDecoder().decode([Wine].self, from: data)
                            await send(.fetchCellarListResponse(.success(cellarList)))
                        } else {
                            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                            await send(.fetchCellarListResponse(.failure(error)))
                        }
                    } catch {
                        let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                        await send(.fetchCellarListResponse(.failure(error)))
                        
                        print(error)
                    }
                }
                
            // INSERT
            case .insertCellar:
                
                state.result = "Wine Name: \(state.wineName), Wine Year: \(state.wineYear), Wine Price: \(state.winePrice), Wine Alcohol: \(state.wineAlcohol), Wine Note: \(state.wineNote), Sugar: \(state.wineSugar), Body: \(state.wineBody), Tannin: \(state.wineTannin), pH: \(state.winepH), Type: \(state.wineType)"
                
                print(state.result)
                
                let wine = Wine( wineindex: state.seq, name: state.wineName, year: state.wineYear, price: state.winePrice, sugar: state.wineSugar, body: state.wineBody, tannin: state.wineTannin, type: state.wineType, note: state.wineNote, pH: state.winepH, alcohol: state.wineAlcohol)
                
                return .run { send in
                    var components = URLComponents(string: "http://192.168.10.15:5000/insert")!
                    components.queryItems = [
                        URLQueryItem(name: "wineName", value: wine.name),
                        URLQueryItem(name: "wineYear", value: wine.year),
                        URLQueryItem(name: "winePrice", value: wine.price),
                        URLQueryItem(name: "wineSugar", value: String(wine.sugar)),
                        URLQueryItem(name: "wineBody", value: String(wine.body)),
                        URLQueryItem(name: "wineTannin", value: String(wine.tannin)),
                        URLQueryItem(name: "wineType", value: wine.type),
                        URLQueryItem(name: "wineNote", value: wine.note),
                        URLQueryItem(name: "winepH", value: String(wine.pH)),
                        URLQueryItem(name: "wineAlcohol", value: wine.alcohol),
                    ]
                    var request = URLRequest(url: components.url!)
                    request.httpMethod = "GET"
                    
                    do {
                        let (data, response) = try await URLSession.shared.data(for: request)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let result = String(data: data, encoding: .utf8) ?? "Success"
                            await send(.cellarResponse(.success(result)))
                        } else {
                            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                            await send(.cellarResponse(.failure(error)))
                        }
                    } catch {
                        let nsError = error as NSError
                        await send(.cellarResponse(.failure(nsError)))
                    }
                }
                
        
            // DELETE
            case let .deleteCellar(wine):
                if let index = state.cellarList.firstIndex(of: wine) {
                    state.cellarList.remove(at: index)
                }
                return .run { send in
                    let url = URL(string: "http://192.168.10.15:5000/delete?wineindex=\(wine.wineindex)")!
                    print("delete finished")
                    URLSession.shared.dataTask(with: url) { _, _, error in
                        if let error = error {
                            print(error)
                        } else {
                            print("successfully deleted")
                        }
                    }.resume()
                }
                
            // SELECTED WINE
            case let .setSelectedWine(wine):
                state.wineName = wine.name
                state.wineYear = wine.year
                state.winePrice = wine.price
                state.wineType = wine.type
                state.wineNote = wine.note
                state.wineSugar = wine.sugar
                state.wineBody = wine.body
                state.wineTannin = wine.tannin
                state.wineAlcohol = wine.alcohol
                state.winepH = wine.pH
                return .none

                
            // UPDATE 
            case let .updateCellar(wine):
                return .run { send in
                    var components = URLComponents(string: "http://127.0.0.1:5000/update")!
                    components.queryItems = [
                        URLQueryItem(name: "wineindex", value: String(wine.wineindex)),
                        URLQueryItem(name: "wineName", value: wine.name),
                        URLQueryItem(name: "wineYear", value: wine.year),
                        URLQueryItem(name: "winePrice", value: wine.price),
                        URLQueryItem(name: "wineSugar", value: String(wine.sugar)),
                        URLQueryItem(name: "wineBody", value: String(wine.body)),
                        URLQueryItem(name: "wineTannin", value: String(wine.tannin)),
                        URLQueryItem(name: "wineType", value: wine.type),
                        URLQueryItem(name: "wineNote", value: wine.note),
                        URLQueryItem(name: "winepH", value: String(wine.pH)),
                        URLQueryItem(name: "wineAlcohol", value: wine.alcohol),
                    ]
                    var request = URLRequest(url: components.url!)
                    request.httpMethod = "GET"

                    do {
                        let (data, response) = try await URLSession.shared.data(for: request)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let result = String(data: data, encoding: .utf8) ?? "Success"
                            await send(.cellarResponse(.success(result)))
                            print(result)
                            print("Updated sucessfully!")
                        } else {
                            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                            await send(.cellarResponse(.failure(error)))
                        }
                    } catch {
                        let nsError = error as NSError
                        await send(.cellarResponse(.failure(nsError)))
                    }
                }
                
           
            case let .cellarResponse(.success(response)):
                state.result = response
                return .none
                
            case let .cellarResponse(.failure(error)):
                state.result = "Error: \(error.localizedDescription)"
                return .none
                
            case let .fetchCellarListResponse(.success(cellarList)):
                state.cellarList = cellarList
                return .none
                
            case let .fetchCellarListResponse(.failure(error)):
                state.result = "Error: \(error.localizedDescription)"
                return .none
            }
        }
    }
}
