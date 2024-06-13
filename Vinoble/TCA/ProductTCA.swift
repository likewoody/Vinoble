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
        var isLike: Bool = false
//        var currentID: Int = 0
//        var wishlist: [WishListModel] = []
        var likeState: [Int:Int] = [:]
        
        // drag
        var offset: CGSize = CGSize()
        var isDrag: Bool = false
        
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
//        case likeButtonTapped(Int)
//        case sqliteWishList
        case addPageLoading
    }
    
    @Dependency(\.dismiss) var dismiss
    
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
                let lastCount = state.lastCount
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
                
//            case .sqliteWishList:
//                let query = WishList()
//                state.wishlist = query.queryDB()
//                
//                if state.wishlist.isEmpty && state.userEmail == "aaa" {
//                    for i in 0..<1082{
//                        _ = query.insertDB(wishlist: 0)
//                        state.likeState[i] = 0
//                    }
//                }
//                return .none
//            case .initLikeCondition:
//                for i in 0..<1085{
//                    state.likeState[i] = false
//                }
//                    
//                return .none

            case .addPageLoading:
                state.lastCount += 2
                state.isLoading = true

                return .run { send in
                    await send(.fetchProducts)
                }
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
