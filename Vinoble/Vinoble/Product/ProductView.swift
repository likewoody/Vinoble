//
//  ProductView.swift
//  Vinoble
//
//  Created by Woody on 6/7/24.
//

/*
 Author : Woody
 Date : 2024.06.07 Friday
 Description : 1차 UI frame 작업
 */


import SwiftUI

struct ProductView: View {
    
    let shareColor = ShareColor()
    
    @State private var searchProduct: String = ""
    // MARK: 0 or 1 (red or white)
    @State private var selectedWineType: Int = 0
    @State private var selectedRegion: Int = 0
    @FocusState private var isTextFieldFocused: Bool
    
    
    // MARK: if start view, change navigation color
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB, alpha: 1)]
        
        UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
//        UINavigationBar.appearance().titleTextAttributes; : [UIFont.systemFontOfSize(19.0)]
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
//                HStack(content: {
//                    
//                    Spacer(minLength: 140)
//    //                VStack(alignment: .center,content: {
//    //                    Text("VINOBLE")
//    //                        .bold()
//    //                        .foregroundStyle(Color(red: red, green: green, blue: blue))
//    //                })
//                    Text("VINOBLE")
//                        .bold()
//                        .foregroundStyle(Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB))
//                        .multilineTextAlignment(.leading)
//                        .focused($isTextFieldFocused)
//                    
//                    Spacer()
//                    
//                    
//                    
//    //                Spacer()
//                    
//                }) // HStack
//                .padding([.top, .bottom],15)
//                .font(.title)
                
                
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
                            .foregroundStyle(Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB))
                            .padding(.leading,12)
                            
                            TextField("Search Product", text: $searchProduct)

                        }) // HStack
                    } // overlay
                    .padding([.top, .bottom],15)
                
                // MARK: Select type of wine
                HStack(content: {
                    Picker(selection: $selectedWineType, label: Text("Wine Type")) {
                        Text("Red").tag(0)
                        Text("White").tag(1)
                        
                    } // Picker
                    .pickerStyle(.segmented)
                    .onAppear(perform: {
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB))], for: .selected)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(Color(.gray).opacity(0.8))], for: .normal)
                    })
                    

                }) // HStack
                .padding(.bottom, 5)
                
                // MARK: Select region
                HStack(content: {
                    Spacer()
                    Button("All", action: {
                        // All
                        selectedRegion = 0
                    })
                    .foregroundStyle(selectedRegion == 0
                                     ? Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB)
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    Button("Bordeaux") {
                        // Bordeaux
                        selectedRegion = 1
                    }
                    .foregroundStyle(selectedRegion == 1
                                     ? Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB)
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    Button("Bourgogne") {
                        // Bourgogne
                        selectedRegion = 2
                    }
                    .foregroundStyle(selectedRegion == 2
                                     ? Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB)
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    Button("Rhone Valley") {
                        // Bourgogne
                        selectedRegion = 3
                    }
                    .foregroundStyle(selectedRegion == 3
                                     ? Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB)
                                     : .gray.opacity(0.8)
                    )
                    Spacer()
                    
                }) // HStack
                .onChange(of: selectedWineType) {
                    // if select wine type region will be reseted
                    selectedRegion = 0
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
                                            .foregroundStyle(Color(red: shareColor.productR, green: shareColor.productG, blue: shareColor.productB))
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
                    Button("", systemImage: "person.circle") {
                        
                    }
                    .foregroundStyle(.red)
//                    .foregroundStyle(Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB))
                }
                
                
            }) // toolbar

//            .toolbarBackground(Color(red: shareColor.burgundyR, green: shareColor.burgundyG, blue: shareColor.burgundyB), for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
            
            
        }) // NavigationView
        

        
//        NavigationView(content: {
//            
//            .navigationTitle("VINOBLE")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar(content: {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("", systemImage: "person.circle") {
//                        
//                    }
//                    .foregroundStyle(Color(red: red, green: green, blue: blue))
//                } // ToolbarItem
//            }) // toolbar
//        }) // NaviView
        
        
    } // body
} // ProductView

#Preview {
    ProductView()
}
