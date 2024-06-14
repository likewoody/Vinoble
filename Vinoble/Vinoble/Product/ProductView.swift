/*
 Author : Woody
 
 1차
 Date : 2024.06.07 Friday
 Description : 1차 UI frame 작업 (2024.06.08 Saturday 10:30)
 
 2차
 Data : 2024.06.08 Saturday
 Description : TCA connect (2024.06.09 TextField binding 완료)
 
 3차
 Data : 2024.06.10 Monday
 Description : Python Server를 이용한 MySQL DB 불러오기 (2024.06.11 완료)

 4차
 Data : 2024.06.10 Tuesday
 Description : Type button click시 scroll 초기화, 그리고 4개씩 loading 해서 보여주려고 했는데 실패.
 (1차 top으로 이동)
 
 5차
 Data : 2024.06.11 Wednesday
 Description : Finished Profile button
 
 6차
 Data : 2024.06.12 Thursday
 Description : adding like button & draggesture
 
 7차
 Data : 2024.06.13 Friday
 Description : wishlist button and navigation with others
 
 */


import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductView: View {
    
    @Bindable var store: StoreOf<ProductFeature>
    
    var body: some View{
        NavigationStack{
            VStack(content: {
                if store.showDrawer{
                    Drawer(store: store)
                } else {
                    
                    HStack {
                        Spacer(minLength: 150)
                        Text("VINOBLE")
                            .bold()
                            .foregroundStyle(.theme)
                            
                        
                        Spacer()
                        Button(action: {
                            // button action
                            store.showDrawer.toggle()

                        }, label: {
                            Image(systemName: "person.circle")
                        })
                        .foregroundStyle(.gray)
                        .padding(.trailing, 30)
                        // forground 적용하기 위해서 분리해서 사용
                    }
                    .font(.system(size: 24))
                    .padding(.top, 15)
                    
                    
                    // MARK: Search Product
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 300, height: 35)
                        .overlay {
                            HStack(content: {
                                Button("", systemImage: "magnifyingglass") {
                                    store.send(.searchProductTapped)
                                }
                                .foregroundStyle(.theme)
                                .padding(.leading,12)
                                

                                TextField("Search Product", text: $store.searchProduct)
                                
                                Button("Search") {
                                    store.send(.searchProductTapped)
                                }
                                .padding()
                                .foregroundStyle(.theme)

                            }) // HStack
                        } // overlay
                        .padding([.top, .bottom],15)
                    
                    // MARK: Select type of wine
                    HStack(content: {
                        Picker(selection: $store.selectedWineType, label: Text("Wine Type")) {
                            Text("Red").tag(0)
                            Text("White").tag(1)
                            
                        } // Picker
                        .pickerStyle(.segmented)
                        .onAppear(perform: {
                            
                            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(.theme)], for: .selected)
                            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(Color(.gray).opacity(0.8))], for: .normal)}
                                  
                        )
                        .onChange(of: store.selectedWineType) {
                            store.selectedRegion = 0
                            store.send(.wineTypeButtonTapped(store.selectedWineType))
                            store.send(.fetchProducts)
                        }
                        

                    }) // HStack
                    .padding(.bottom, 5)
                    
                    // MARK: Select region
                    HStack(content: {
                        Spacer()
                        Button("All", action: {
                            // All
                            store.selectedRegion = 0
                        })
                        .foregroundStyle(store.selectedRegion == 0
                                         ? .theme
                                         : .gray.opacity(0.8)
                        )
                        Spacer()
                        Button("Bordeaux") {
                            // Bordeaux
                            store.selectedRegion = 1
                        }
                        .foregroundStyle(store.selectedRegion == 1
                                         ? .theme
                                         : .gray.opacity(0.8)
                        )
                        Spacer()
                        Button("Bourgogne") {
                            // Bourgogne
                            store.selectedRegion = 2
                        }
                        .foregroundStyle(store.selectedRegion == 2
                                         ? .theme
                                         : .gray.opacity(0.8)
                        )
                        Spacer()
                        Button("Rhone Valley") {
                            // Bourgogne
                            store.selectedRegion = 3
                        }
                        .foregroundStyle(store.selectedRegion == 3
                                         ? .theme
                                         : .gray.opacity(0.8)
                        )
                        Spacer()
                        
                    }) // HStack
                    .onChange(of: store.selectedRegion) {
                        // if select wine type region will be reseted
                        store.send(.wineRegionButtonTapped(store.selectedRegion))
                        store.send(.fetchProducts)
                    } // onChange
                    .padding(.bottom,20)
                    
                    
                    Spacer()
                    
                    // MARK: Product list
                    if store.isLoading{
                        GeometryReader(content: { geometry in
                            ProgressView()
                                .offset(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }) // GeometryReader
                    }else{
                        ScrollViewReader(content: { proxy in
                            ScrollView {
                                LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                                    ForEach(store.products, id:\.index) { product in
                                        NavigationLink(destination:
//                                                        MainTabView()
                                                        ProductDetail(
                                            store: Store(initialState: DetailFeature.State()){
                                                DetailFeature()
                                            },
                                            noteStore: Store(initialState: TastingNoteFeature.State()){
                                                TastingNoteFeature()
                                            }, index: product.index)
                                        ) {
                                            VStack(content: {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .id(product.index)
                                                    .foregroundStyle(.theme.opacity(0.2))
                                                    .frame(width: 120, height: 150)
                                                    .padding(.top, 30)
                                                    .overlay {
                                                        ZStack {
                                                            let url = URL(string: product.wineImage)
                                                            WebImage(url: url)
                                                                .resizable()
                                                                .frame(width: 50, height: 200)
                                                                .padding(.bottom, 50)
                                                            
                                                            Button {
                                                                // action
                                                                store.send(.likeButtonTapped(product.index))
                                                            } label: {
                                                                ZStack {
                                                                    Circle()
                                                                        .foregroundColor(.clear)
                                                                        .frame(width: 40, height: 40)
                                                                    Image(systemName: store.likeState[product.index] == 1 ? "heart.fill" : "heart")
                                                                        .foregroundColor(.theme)
                                                                        .font(.system(size: 24))
                                                                }
                                                            } // Button
                                                            .offset(x: 40, y: 70)
                                                        } // ZStack
                                                    } // overlay
                                                    .padding(.bottom, 5)
                                                
                                                Text(product.name)
                                                    .foregroundStyle(.black)
                                                    .padding(.bottom, 30)
                                            }) // VStack
//                                            .gesture(
//                                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
//                                                    .onChanged({ gesture in
//                                                        store.offset = gesture.translation
//                                                    })
//                                                    .onEnded({ gesture in
//                                                        if gesture.translation.height < -50 {
//                                                            store.send(.addPageLoading)
//                                                            
//                                                        }
//                                                    })
//                                            ) // gesture

                                        } // NavigationLink

                                        
                                    } // ForEach
    
                                }) // Lazy V Grid
                                .padding(.top, 50)
                                
    
                            } // ScrollView
                            .overlay(
                                Button(action: {
                                    // 10. withAnimation 과함께 함수 작성
                                    withAnimation(.default) {
                                        // ScrollViewReader의 proxyReader을 넣어줌
                                        proxy.scrollTo(store.minIndex, anchor: .top)
                                    }
                                }, label: {
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.theme)
                                        .clipShape(Circle())
                                })
                                .padding(.trailing)
                                .padding(.bottom)
    
                                //오른쪽 하단에 버튼 고정
                                ,alignment: .bottomTrailing
                                
                                    
                            ) // overlay
//                            .onChange(of: store.lastCount) {
//                                if store.lastCount > 6 {
//                                    withAnimation(.default) {
//                                        print("get in ")
//                                        // ScrollViewReader의 proxyReader을 넣어줌
//                                        proxy.scrollTo(store.lastCount, anchor: .bottom)
//                                    }
//                                }
//                                print(store.lastCount)
//                            }
                            
    
                        }) // ScrollViewReader
                        
    
                    } // else
                }

            }) // VStack
            .animation(.easeIn(duration: 0.1))
            
        } // NavigationStack
        .onAppear(perform: {
            store.send(.fetchProducts)
        })
        
        
    } // body
    
} // ProductView



#Preview {
    ProductView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}
