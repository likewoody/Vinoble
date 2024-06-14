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
        var userEmail: String = ""
        var firebaseResult: Bool = false
        
        
        // products load
//        var lastCount: Int = 6
        
        // wish
        var wishlist: [WishListModel] = []
        var likeState: [Int:Int] = [:]
        
        // drag
        var offset: CGSize = CGSize()
        var isDrag: Bool = false
        
//        @Presents var detail: DetailFeature.State?
        
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
        case searchWishlist
        case searchedResultWish([WishListModel])
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
                let region = state.selectedRegion
                let wineType = state.selectedWineType
                
                state.userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
                
                print(state.userEmail)
                
                return .run { send in
                    
                    let products = await tryHttpSession(httpURL: "http://127.0.0.1:5000/selectVinoble?region=\(region)&wineType=\(wineType)")
                    
                    await send(.fetchResponse(products))
                } // return
                
            case let .fetchResponse(products):
                state.minIndex = products[0].index
                state.products = products
                state.isLoading = false
                
                return .run { send in
                    await send(.searchWishlist)
                }
                
            case .searchProductTapped:
                let searchProduct = state.searchProduct
                
                return .run { send in
                    let products = await tryHttpSession(httpURL: "http://127.0.0.1:5000/searchProduct?searchProduct=\(searchProduct)")
                    
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
                let userEmail = state.userEmail
                
                return .run { send in
                    let datas = await query.queryDB()
                    
                    if datas.isEmpty{
                        _ = await query.insertDB(productID: id, isWish: 1, userEmail: userEmail)
                    } else {
                        if datas[id].productID == 1 {
                            _ = await query.updateDB(productID: id, isWish: 0, userEmail: userEmail)
                        }else {
                            _ = await query.updateDB(productID: id, isWish: 1, userEmail: userEmail)
                        }
                    }
                    
                    await send(.searchWishlist)
                }
            case .searchWishlist:
                let query = WishList()
                
                return .run { send in
                    let datas = await query.queryDB()
                    await send(.searchedResultWish(datas))
                }
            case let .searchedResultWish(searchedResultWish):
                if state.userEmail == searchedResultWish[0].userEmail {
                    print("\(searchedResultWish) searchResult SQLite")
                    for i in 0..<searchedResultWish.count {
                        state.likeState[i] = searchedResultWish[i].isWish
                    }
//                    state.wishlist = searchedResultWish
                }
                return .none

//            case .addPageLoading:
//                state.lastCount += 2
//                state.isLoading = true
//
//                return .run { send in
//                    await send(.fetchProducts)
//                }
        
            
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
                              
                              

