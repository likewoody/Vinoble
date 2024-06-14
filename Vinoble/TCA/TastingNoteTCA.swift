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
 Description : .select, .insert, .delete, .getselectedewine added
 
 Author : Diana
 Date : 2024.06.13 Thurs
 Description : .update function complete
 
 Author : Diana
 Date : 2024.06.14 Fri
 Description : finishing up 
 - userid value received
 */

import ComposableArchitecture
import Foundation

@Reducer
struct TastingNoteFeature {
    
    @ObservableState
    struct State: Equatable {
        var seq: Int = 0
        var wineindex : Int = 0
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
        var wineImage : String = ""
        var result: String = ""
        var cellarList: [Wine] = []
        // screen navigation
        var updateSuccess : Bool = false
        var insertSuccess : Bool = false
        
        
        // reset the state to initial values
       mutating func reset() {
           wineindex = 0
           wineName = ""
           wineYear = ""
           winePrice = ""
           wineNote = ""
           wineSugar = 0.0
           wineBody = 0.0
           wineTannin = 0.0
           wineType = ""
           wineAlcohol = ""
           winepH = 0.0
           wineImage = ""
           updateSuccess = false
           insertSuccess = false
       }
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case insertCellar(String)
        case selectCellar(String)
        case deleteCellar(Wine)
        case updatecellarResponse(Result<String, NSError>)
        case insertcellarResponse(Result<String, NSError>)
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
            case let .selectCellar(userid):
                return .run { send in
                    let url = URL(string: "http://192.168.10.15:5000/select?userid=\(userid)")!
                    do {
                        let (data, response) = try await URLSession.shared.data(from: url)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let cellarList = try JSONDecoder().decode([Wine].self, from: data)
                            await send(.fetchCellarListResponse(.success(cellarList)))
                            print(cellarList)
                        } else {
                            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                            await send(.fetchCellarListResponse(.failure(error)))
                            print(error)
                        }
                    } catch {
                        let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
                        await send(.fetchCellarListResponse(.failure(error)))
                        
                        print(error)
                    }
                }
                
            // INSERT
            case let .insertCellar(userid):
                
                state.result = "Wine Name: \(state.wineName), Wine Year: \(state.wineYear), Wine Price: \(state.winePrice), Wine Alcohol: \(state.wineAlcohol), Wine Note: \(state.wineNote), Sugar: \(state.wineSugar), Body: \(state.wineBody), Tannin: \(state.wineTannin), pH: \(state.winepH), Type: \(state.wineType), Image: \(state.wineImage)"
                
                print(state.result)
                
                let wine = Wine(wineindex: state.seq, name: state.wineName, year: state.wineYear, price: state.winePrice, sugar: state.wineSugar, body: state.wineBody, tannin: state.wineTannin, type: state.wineType, note: state.wineNote, pH: state.winepH, alcohol: state.wineAlcohol, image: state.wineImage)
                
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
                        URLQueryItem(name: "wineImage", value: wine.image),
                        URLQueryItem(name: "userid", value: userid)

                    ]
                    var request = URLRequest(url: components.url!)
                    request.httpMethod = "GET"
                    
                    do {
                        let (data, response) = try await URLSession.shared.data(for: request)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let result = String(data: data, encoding: .utf8) ?? "Success"
                            await send(.insertcellarResponse(.success(result)))
                        } else {
                            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                            await send(.insertcellarResponse(.failure(error)))
                        }
                    } catch {
                        let nsError = error as NSError
                        await send(.insertcellarResponse(.failure(nsError)))
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
                state.wineindex = wine.wineindex
                state.wineName = wine.name
                state.wineYear = wine.year
                state.winePrice = wine.price
                state.wineType = wine.type
                state.wineNote = wine.note
                state.wineSugar = wine.sugar
                state.wineBody = wine.body
                state.wineTannin = wine.tannin
                state.wineAlcohol = wine.alcohol
                state.wineImage = wine.image
                state.winepH = wine.pH
                
                return .none

                
            // UPDATE 
            case let .updateCellar(wine):
                return .run { send in
                    var components = URLComponents(string: "http://192.168.10.15:5000/update")!
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
                        URLQueryItem(name: "wineImage", value: wine.image),
                        URLQueryItem(name: "wineindex", value: String(wine.wineindex))
                    ]
                    var request = URLRequest(url: components.url!)
                    request.httpMethod = "GET"

                    do {
                        let (data, response) = try await URLSession.shared.data(for: request)
                        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                            let result = String(data: data, encoding: .utf8) ?? "Success"
                            await send(.updatecellarResponse(.success(result)))
                            print(data)
                            print("Updated sucessfully!")
                        } else {
                            let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                            await send(.updatecellarResponse(.failure(error)))
                            print(error)
                        }
                    } catch {
                        let nsError = error as NSError
                        await send(.updatecellarResponse(.failure(nsError)))
                    }
                }
                
            
            // update cellar
            case let .updatecellarResponse(result):
                switch result {
                case.success:
                    state.updateSuccess = true
                    return .none
                case.failure:
                    state.updateSuccess = false
                    return .none
                }
    
                
            // insert cellar
            case let .insertcellarResponse(result):
                switch result {
                case.success:
                    state.insertSuccess = true
                    return .none
                case.failure:
                    state.insertSuccess = false
                    return .none
                }
                
            
                
            // fetch cellar
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
