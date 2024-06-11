//
//  ProductDetail.swift
//  Vinoble
//
//  Created by 이대근 on 6/10/24.
//

/*
 Author : Gerrard
 
 1차
 Date : 2024.06.10 Monday
 Description : 1차 UI frame 작업 (2024.06.10 Monday 15:50)
 
 */


import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductDetail: View {
    
    @Bindable var store: StoreOf<ProductFeature>
    @Bindable var store2: StoreOf<DetailFeature>
    
    // 다른 곳에서도 사용할 수 있게끔 Color를 func으로 만든 것을 불러온다.
    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
    
    // MARK: For test
    @State private var foodPairings: [String] = ["https://images.vivino.com/backgrounds/foods/thumbs/4_beef_932x810.png", "https://images.vivino.com/backgrounds/foods/thumbs/8_lamb_932x810.png", "https://images.vivino.com/backgrounds/foods/thumbs/20_chicken_932x810.png", "https://images.vivino.com/backgrounds/foods/thumbs/11_venison_932x810.png"]
    
    
    @State var pH: Double = 0.5
    @State var sweet: Double = 0.5
    @State var bodies: Double = 0.5
    @State var tannin: Double = 0.5
    @State var alcohol: Double = 0.5
    @State var rating: Double = 4.7
    
    // MARK: if start view, change navigation title
    init(store: StoreOf<ProductFeature>, store2: StoreOf<DetailFeature>) {
        // store 속성을 초기화합니다. 예를 들어, 기본값을 사용하거나 인자를 받을 수 있습니다.
        self.store = store
        self.store2 = store2
        

        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: shareColor.initColorWithAlpha(), // Title color
                                                            
            .font: UIFont.boldSystemFont(ofSize: 24.0)	 // Title font size
        ]
    }
    
    var body: some View{
        NavigationView {
            VStack {
                ScrollView(content: {
                    HStack(content: {
                        RoundedRectangle(cornerRadius:10)
                            .fill(Color.white.opacity(0.3))
                            .frame(width:120, height:470)
                            .overlay {
                                AsyncImage(url: URL(string: "https://images.vivino.com/thumbs/BrbHdEB8TqK2N61pvLoQeQ_pb_x600.png")) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView() // 로딩 중 표시
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                        case .failure:
                                            Color.red // 오류 발생 시 표시
                                        @unknown default:
                                            Color.gray
                                        }
                                    }
                                    .frame(width: 150, height: 400) // 원하는 크기로 프레임 설정
                            }
                        
                        
                        
                        VStack(content: {
                            Text("Château Gazin Pomerol 2018")
                                .bold()
                                .font(.system(size: 30))
                                .multilineTextAlignment(.center)
                            
//                            HStack {
//                                
//                                RatingView(rating: 4.7)
//                                    .padding(.bottom,5)
//                                    .foregroundColor(Color(shareColor.mainColor()))
//                            }
                            
                            // rating
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: self.starType(for: index))
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(Text("Rated \(rating, specifier: "%.1f") stars"))
                            .foregroundColor(Color(shareColor.mainColor()))
                            
                            Text(String(format: "%.1f", rating))
                                .font(.largeTitle)
                                .bold()
                                .padding(.bottom,5)
                            
                            HStack(content: {
                                Spacer()
                                
                                Text("ALCOHOL")
                                    .bold()
                                    .foregroundColor(Color(shareColor.mainColor()))
                                    .font(.system(size: 17))
                                
                                
                                
                                Spacer()
                                
                                Text("YEAR")
                                    .bold()
                                    .foregroundColor(Color(shareColor.mainColor()))
                                    .font(.system(size: 17))
                                    .padding(.trailing)
                                
                                Spacer()
                            })
                            .multilineTextAlignment(.center)
                            .padding(.bottom,5)
                            
                            HStack(content: {
                                Spacer()
                                
                                Text("13.5%")
                                    .bold()
                                    .font(.system(size: 17))
                                
                                Spacer()
                                
                                Text("2014")
                                    .bold()
                                    .font(.system(size: 17))
                                
                                
                                Spacer()
                            })
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            
//                            Spacer()
                            
                            HStack(content: {
                                Spacer()
                                
                                Text("REGION")
                                    .bold()
                                    .foregroundColor(Color(shareColor.mainColor()))
                                    .font(.system(size: 17))
                                
                                Spacer()
                                
                                Text("VOLUME")
                                    .bold()
                                    .foregroundColor(Color(shareColor.mainColor()))
                                    .font(.system(size: 17))
                                
                                Spacer()
                            })
                            .multilineTextAlignment(.center)
                            .padding(.bottom,5)
                            
                            HStack(content: {
                                Spacer()
                                
                                Text("Mendoza")
                                    .bold()
                                    .font(.system(size: 15))
                                
                                Spacer()
                                
                                Text("750ml")
                                    .bold()
                                    .font(.system(size: 15))
                                
                                Spacer()
                            })
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            
                            Text("PRICE")
                                .bold()
                                .foregroundColor(Color(shareColor.mainColor()))
                                .font(.system(size: 17))
                                .multilineTextAlignment(.center)
                                .padding(.bottom,5)
                            
                            Text("$84.95")
                                .bold()
                                .multilineTextAlignment(.center)
                            
                        })
                        .padding()
                        
                    })
                    
                    Spacer()
                    
                    Text("ABOUT THE PRODUCT")
                        .bold()
                        .foregroundColor(Color(shareColor.mainColor()))
                        .font(.system(size: 24))
                        .padding(.bottom)
                    
                    Text("Argento Reserva Malbec is dark violet and offers concentrated aromas of black plums, cherries, and blackberries. These vibrant black fruit flavors please the palate, and the predominant French oak characters coming from its aging in barrels for six to nine months blend perfectly.")
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10))
                    
                    HStack(content: {
                        Picker(selection: $store2.selectedWineInfo, label: Text("Wine Info")) {
                            Text("Food Pairings").tag(0)
                            Text("Flavor Profile").tag(1)
                            Text("Description").tag(2)
                            
                        } // Picker
                        .pickerStyle(.segmented)
                        .onAppear(perform: {
                            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(shareColor.mainColor())], for: .selected)
                            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(Color(.gray).opacity(0.8))], for: .normal)
                        })
                        

                    }) // HStack
                    .padding(.bottom, 5)
                    
                    if store2.selectedWineInfo == 0 {
                        ScrollView(.horizontal, content: {
//                            LazyHGrid(rows: [GridItem(.adaptive(minimum: 100))], spacing: 10, content: {
                            HStack{
                                ForEach(foodPairings, id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView() // 로딩 중 표시
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                        case .failure:
                                            Color.red // 오류 발생 시 표시
                                        @unknown default:
                                            Color.gray
                                        }
                                    }
                                }
                            }
                        })
                    }
                    
                    if store2.selectedWineInfo == 1 {
//                        // Pentagon Graph
//                        WithViewStore(self.store2) { viewStore2 in
//                            PentagonGraphShape(
//                                pH: viewStore2.pH,
//                                sweet: viewStore2.sweet,
//                                body: viewStore2.body,
//                                tannin: viewStore2.tannin,
//                                alcohol: viewStore2.alcohol
//                            )
//                            .stroke(Color.blue, lineWidth: 2)
//                            .frame(width: 200, height: 200)
//                        }
                    }
                   
                    if store2.selectedWineInfo == 2 {
                        HStack(content: {

                            Spacer()
                            
                            Image(systemName: "bolt.shield")
                                                    
                            Text("Winery")
                            
                            Spacer()
                            
                            Text("Screaming Eagle")
                                
                            Spacer()
                        })
                        
                        Divider()
                            .background(Color(.black))
                        
                        HStack(content: {
                            Spacer()
                            
                            Image(systemName: "wineglass")
                            
                            Text("Grapes")
                            
                            Spacer()
                            
                            Text("Cabernet Sauvignon")
                                
                            Spacer()
                        })
                        
                        Divider()
                            .background(Color(.black))
                        
                        HStack(content: {
                            Spacer()
                            
                            Image(systemName: "location")
                            
                            Text("Region")
                            
                            Spacer()
                            
                            Text("United States / California / North Coast")
                                
                            Spacer()
                        })
                        
                        Divider()
                            .background(Color(.black))
                        
                        HStack(content: {
                            Spacer()
                            
                            Image(systemName: "flame")
                            
                            Text("Wine Style")
                            
                            Spacer()
                            
                            Text("Red")
                                
                            Spacer()
                        })
                        
                        Divider()
                            .background(Color(.black))
                        
                        HStack(content: {
                            Spacer()
                            
                            Image(systemName: "eyes")
                            
                            Text("Allergens")
                            
                            Spacer()
                            
                            Text("Contains sulfites")
                                
                            Spacer()
                        })
                        
                        Divider()
                            .background(Color(.black))
                    }
                })
                .padding()
            }
            .navigationTitle("Detail View")
            .navigationBarTitleDisplayMode(.inline)
            
        } // NavigationView
        
        
    } // body
    
    private func starType(for index: Int) -> String {
        let fullStarThreshold = index + 1
        let halfStarThreshold = Double(index) + 0.5
        
        if rating >= Double(fullStarThreshold) {
            return "star.fill"
        } else if rating >= halfStarThreshold {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
    
}

#Preview {
    ProductDetail(
        store: Store(initialState:
            ProductFeature.State()){
            ProductFeature()
        },
        store2: Store(initialState:
            DetailFeature.State()){
            DetailFeature()
        }
    )
}
