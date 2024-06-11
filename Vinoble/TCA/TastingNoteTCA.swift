import ComposableArchitecture
import Foundation

@Reducer
struct TastingNoteFeature {
    
    @ObservableState
    struct State: Equatable {
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
        var cellarList: [[String]] = []
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case insertCellar
        case selectCellar
        case cellarResponse(Result<String, NSError>)
        case fetchCellarListResponse(Result<[[String]], NSError>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .selectCellar:
                return .run { send in
                    let url = URL(string: "http://127.0.0.1:5000/select")!
                    let (data, response) = try await URLSession.shared.data(from: url)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        let cellarList = try JSONDecoder().decode([[String]].self, from: data)
                        await send(.fetchCellarListResponse(.success(cellarList)))
                    } else {
                        let error = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: nil)
                        await send(.fetchCellarListResponse(.failure(error)))
                    }
                }
                
            case .insertCellar:
                state.result = "Wine Name: \(state.wineName), Wine Year: \(state.wineYear), Wine Price: \(state.winePrice),Wine Alcohol: \(state.wineAlcohol), Wine Note: \(state.wineNote), Sugar: \(state.wineSugar), Body: \(state.wineBody), Tannin: \(state.wineTannin), pH: \(state.winepH), Type: \(state.wineType)"
                print(state.result)
                
                let wineName = state.wineName
                let wineYear = state.wineYear
                let winePrice = state.winePrice
                let wineSugar = state.wineSugar
                let wineBody = state.wineBody
                let wineTannin = state.wineTannin
                let wineType = state.wineType
                let wineNote = state.wineNote
                let winepH = state.winepH
                let wineAlcohol = state.wineAlcohol

                return .run { send in
                    var components = URLComponents(string: "http://127.0.0.1:5000/insert")!
                    components.queryItems = [
                        URLQueryItem(name: "wineName", value: wineName),
                        URLQueryItem(name: "wineYear", value: wineYear),
                        URLQueryItem(name: "winePrice", value: winePrice),
                        URLQueryItem(name: "wineSugar", value: String(wineSugar)),
                        URLQueryItem(name: "wineBody", value: String(wineBody)),
                        URLQueryItem(name: "wineTannin", value: String(wineTannin)),
                        URLQueryItem(name: "wineType", value: wineType),
                        URLQueryItem(name: "wineNote", value: wineNote),
                        URLQueryItem(name: "winepH", value: String(winepH)),
                        URLQueryItem(name: "wineAlcohol", value: wineAlcohol),
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
