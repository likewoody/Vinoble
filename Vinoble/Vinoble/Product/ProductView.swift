//
//  ProductView.swift
//  Vinoble
//
//  Created by Woody on 6/7/24.
//

/*
 Author : Woody
 
 1차
 Date : 2024.06.07 Friday
 Description : 1차 UI frame 작업 (2024.06.08 Saturday 10:30)
 
 2차
 Data : 2024.06.08 Saturday
 Description : TCA connect (2024.06.09 TextField binding 완료)
 
 */


import SwiftUI
import ComposableArchitecture

struct ProductView: View {
    
    @Bindable var store: StoreOf<ProductFeature>
    
    // 다른 곳에서도 사용할 수 있게끔 Color를 func으로 만든 것을 불러온다.
    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
    
    // MARK: if start view, change navigation title
    init(store: StoreOf<ProductFeature>) {
        // store 속성을 초기화합니다. 예를 들어, 기본값을 사용하거나 인자를 받을 수 있습니다.
        self.store = store

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: shareColor.initColorWithAlpha(), // Title color
                                                            
            .font: UIFont.boldSystemFont(ofSize: 24.0) // Title font size
        ]
    }
    
    // MARK: For test
    @State private var wineList: [[String]] = [
        ["Concha Y Toro", "flower_01"],
        ["Merlot", "flower_02"],
        ["Cabernet sauvignon", "flower_03"],
        ["Pinot noir", "flower_04"],
        ["Pinot grigio", "flower_05"],
        ["Riesling", "flower_06"],
        ["Zinfandel", "flower_01"],
    ]
    
    var body: some View{
        NavigationView(content: {
            VStack(content: {
                // MARK: Search Product
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 300, height: 35)
                    .overlay {
                        HStack(content: {
                            Button("", systemImage: "magnifyingglass") {
                                // ****** DB를 불러와 search가 필요함 ******
                                // ****** DB를 불러와 search가 필요함 ******
                                // ****** DB를 불러와 search가 필요함 ******
                                // ****** DB를 불러와 search가 필요함 ******
                                
                            }
                            .foregroundStyle(shareColor.mainColor())
                            .padding(.leading,12)
                            

                            TextField("Search Product", text: $store.searchProduct)

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
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(shareColor.mainColor())], for: .selected)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(Color(.gray).opacity(0.8))], for: .normal)
                    })
                    

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
                                     ? shareColor.mainColor()
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    Button("Bordeaux") {
                        // Bordeaux
                        store.selectedRegion = 1
                    }
                    .foregroundStyle(store.selectedRegion == 1
                                     ? shareColor.mainColor()
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    Button("Bourgogne") {
                        // Bourgogne
                        store.selectedRegion = 2
                    }
                    .foregroundStyle(store.selectedRegion == 2
                                     ? shareColor.mainColor()
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    Button("Rhone Valley") {
                        // Bourgogne
                        store.selectedRegion = 3
                    }
                    .foregroundStyle(store.selectedRegion == 3
                                     ? shareColor.mainColor()
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    
                }) // HStack
                .onChange(of: store.selectedWineType) {
                    // if select wine type region will be reseted
                    store.selectedRegion = 0
                } // onChange
                .padding(.bottom,20)
                
                
                Spacer()
                
                // MARK: Product list
                
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                            ForEach(wineList, id:\.self) { wine in
                                NavigationLink(destination: MainView()) {
                                    VStack(content: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(shareColor.productBackGroundColor())
                                            .frame(width: 100, height: 100)
                                            .overlay {
                                                Image(wine[1])
                                                    .resizable()
                                                    .frame(width: 50, height: 100)
                                                    .padding(.bottom, 30)

                                            }
                                            
                                        
                                        Text(wine[0])
                                            .foregroundStyle(.black)
                                            .padding(.bottom, 30)
                                        
                                    }) // VStack
                                    
                                } // Link
                                
                            } // ForEach
                            
                        }) // Lazy V Grid
                        
                    } // ScrollView
                
            }) // VStack
            .navigationTitle("VINOBLE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // button action
                    }, label: {
                        Image(systemName: "person.circle")
                    })
                    .foregroundStyle(.gray)
                    // forground 적용하기 위해서 분리해서 사용
                }
                
            }) // toolbar
            
            
        }) // NavigationView
    } // body
    
} // ProductView

#Preview {
    ProductView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}
