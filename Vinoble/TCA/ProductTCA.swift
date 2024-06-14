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
        var minIndex: Int = 0
        
        
        // Drawer
        var showDrawer: Bool = false
        var userEmail: String = "aaa"
        var userPassword: String = "aaa"
        var firebaseResult: Bool = false
        
        
        // products load
        var lastCount: Int = 6
        
        // wish
        var wishlist: [WishListModel] = []
        var likeState: [Int:Int] = [:]
        
        // drag
        var offset: CGSize = CGSize()
        var isDrag: Bool = false
        
//        var path = StackState<DetailFeature.State>()
    }
    
    enum Action: BindableAction{
        case binding(BindingAction<State>)
        case fetchProducts
        case fetchResponse([Product])
        case wineTypeButtonTapped(Int)
        case wineRegionButtonTapped(Int)
        case searchProductTapped
        case fetchUserInfo
        case fetchResponseUserInfo(String)
        case dismissPaging
        case likeButtonTapped(Int)
        case sqliteWishList
        case addPageLoading
        

        // for test
//        case path(StackAction<DetailFeature.State, DetailFeature.Action>)
    }
    
    @Dependency(\.dismiss) var dismiss
//    @Environment(\.presentActions)
    
    var body: some Reducer<State, Action>{
        
        BindingReducer()
        
        Reduce { state, action in
            switch action{
            case .binding(_):
                return .none
                
            case .fetchProducts:
                let lastCount = state.lastCount
                let region = state.selectedRegion
                let wineType = state.selectedWineType
                state.userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                
                return .run { send in
                    
                    let products = await tryHttpSession(httpURL: "http://192.168.10.15:5000/selectVinoble?lastCount=\(lastCount)&region=\(region)&wineType=\(wineType)")
                    
                    await send(.fetchResponse(products))
                } // return
                
            case let .fetchResponse(products):
                state.minIndex = products[0].index
                state.products = products
                state.isLoading = false
                
                return .none
                
            case .searchProductTapped:
                let lastCount = 0
                state.lastCount = 6
                let searchProduct = state.searchProduct
                
                
                return .run { send in
                    let products = await tryHttpSession(httpURL: "http://192.168.10.15:5000/searchProduct?lastCount=\(lastCount)&searchProduct=\(searchProduct)")
                    
                    await send(.fetchResponse(products))
                } // return
                
            case let .wineTypeButtonTapped(wineType):
                state.selectedWineType = wineType
                return .none
                
            case let .wineRegionButtonTapped(region):
                state.selectedRegion = region
                return .none
                
            case .fetchUserInfo:
                let firebaseModel = QueryForTCA(store: Store(initialState: ProductFeature.State()){
                    ProductFeature()
                })
                let userEmail = state.userEmail
                return .run { send in
                    let result = try await firebaseModel.checkUserEmail(userid: userEmail)
                    
                    if result {
                        await send(.fetchResponseUserInfo(userEmail))
                    }
                }
            case let .fetchResponseUserInfo(userEmail):
                state.userEmail = userEmail
                
                return .none
                
            case .dismissPaging:
                state.showDrawer = false
                return .run {_ in await self.dismiss()}
                
            case let .likeButtonTapped(id):
                let query = WishList()
                
                if let _ = state.likeState[id] {
                    _ = query.updateDB(wishlist: 0, id: id+1)
                    state.likeState[id] = 0
                } else{
                    _ = query.updateDB(wishlist: 1, id: id+1)
                    state.likeState[id] = 1
                }
                return .none
                
            case .sqliteWishList:
                let query = WishList()
                state.wishlist = query.queryDB()
                
                if state.wishlist.isEmpty && state.userEmail == "aaa" {
                    // 처음 들어오는 데이터라면 데이터의 갯수만큼 데이터를 넣어준다.
                    for i in 0..<state.products.count{
                        _ = query.insertDB(wishlist: 0)
                        state.likeState[i] = 0
                    }
                }
                
                for i in 0..<state.products.count{
                    if state.likeState[i] == 1 {
                        state.likeState[i] = 0
                    } else {
                        state.likeState[i] = 1
                    }
                }
                return .none

            case .addPageLoading:
                state.lastCount += 2
                state.isLoading = true

                return .run { send in
                    await send(.fetchProducts)
                }
                
            // as navigaion link
//            case let .path(action):
//                case .element(action:
////                    .(.moveToNextButtonDidTap)):
////                    state.path.append(.captureImageScene())
//                    return .none
//                case .element(id: _, action: .captureImage(.recognizeDidEnd(let data))):
//                    state.path.append(.listOfRecognizedMedicinesScene(.init(dataPassed: data)))
//                    return .none
//                   default:
//                     return .none
            
            } // Switch
        
        } // Reduce

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
                              
                              
//extension ProductFeature {
//  @Reducer
//  struct Path {
//      @ObservableState
//      enum State: Equatable {
//          case registerNewMedicationScene(RegisterNewMedicationReducer.State = .init())
//          case captureImageScene(CaptureMedicinesReducer.State = .init())
//      }
//  
//      enum Action {
//          case registerNewMedication(RegisterNewMedicationReducer.Action)
//          case captureImage(CaptureMedicinesReducer.Action)
//          ...
//         }
//  
//      var body: some ReducerOf<Self> {
//          Scope(state: \.registerNewMedicationScene, action: \.registerNewMedication) {
//              RegisterNewMedicationReducer()
//          }
//          Scope(state: \.captureImageScene, action: \.captureImage) {
//              CaptureMedicinesReducer()
//          }
//          ...
//      }
//  }
//}
