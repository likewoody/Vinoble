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
 
 2차
 Date : 2024.06.11 Tuesday
 Description : 2차 UI frame & Segment 분리 작업 (2024.06.11 Tuesday 15:50)
 
 3차
 Date : 2024.06.12 Wednesday
 Description : TCA로 Python Flask 서버로 데이터를 json형태로 받은후 Swift에 연결 (2024.06.12 Wednesday 15:50)
 */


import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct ProductDetail: View {
    
    @Bindable var store: StoreOf<DetailFeature>
    let noteStore: StoreOf<TastingNoteFeature>
    let index: Int
    
//    // 다른 곳에서도 사용할 수 있게끔 Color를 func으로 만든 것을 불러온다.
//    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()){
//        ProductFeature()
//    })

    // MARK: if start view, change navigation title
    init(store: StoreOf<DetailFeature>, noteStore: StoreOf<TastingNoteFeature>, index: Int) {
        // store 속성을 초기화합니다. 예를 들어, 기본값을 사용하거나 인자를 받을 수 있습니다.
        self.store = store
        self.noteStore = noteStore
        self.index = index

//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: shareColor.initColorWithAlpha(), // Title color
//                                                            
//            .font: UIFont.boldSystemFont(ofSize: 24.0)	 // Title font size
//        ]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme), // Title color
            .font: UIFont.boldSystemFont(ofSize: 24.0) // Title font size
        ]
    }
    
    var body: some View{
        NavigationView {

            // TCA를 사용하니 데이터를 늦게 가져와서 ProgressView()로 처리
            if store.isLoading{
                ProgressView()
            }else{
                    VStack {
                        ScrollView(content: {
                            HStack(content: {
                                RoundedRectangle(cornerRadius:10)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width:120, height:470)
                                    .overlay {
                                        AsyncImage(url: URL(string: store.detailProduct[0].wineImage)) { phase in
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
                                    Text(store.detailProduct[0].name)
                                        .bold()
                                        .font(.system(size: 30))
                                        .multilineTextAlignment(.center)
                                    
                                    // rating
                                    HStack(spacing: 2) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: self.starType(for: index))
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .accessibilityElement(children: .combine)
                                    .accessibilityLabel(Text("Rated \(store.detailProduct[0].rating, specifier: "%.1f") stars"))
                                    .foregroundColor(Color(.theme))
                                    
                                    Text(String(format: "%.1f", store.detailProduct[0].rating))
                                        .font(.largeTitle)
                                        .bold()
                                        .padding(.bottom,5)
                                    
                                    HStack(content: {
                                        Spacer()
                                        
                                        Text("ALCOHOL")
                                            .bold()
                                            .foregroundColor(Color(.theme))
                                            .font(.system(size: 17))
                                        
                                        
                                        
                                        Spacer()
                                        
                                        Text("YEAR")
                                            .bold()
                                            .foregroundColor(Color(.theme))
                                            .font(.system(size: 17))
                                            .padding(.trailing)
                                        
                                        Spacer()
                                    })
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom,5)
                                    
                                    HStack(content: {
                                        Spacer()
                                        
                                        Text(store.detailProduct[0].alcohol)
                                            .bold()
                                            .font(.system(size: 17))
                                        
                                        Spacer()
                                        
                                        Text(formatNumberWithoutCommas(store.detailProduct[0].year))
                                            .bold()
                                            .font(.system(size: 17))
                                        
                                        
                                        Spacer()
                                    })
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom)
                                    
                                    HStack(content: {
                                        Spacer()
                                        
                                        Text("REGION")
                                            .bold()
                                            .foregroundColor(Color(.theme))
                                            .font(.system(size: 17))
                                        
                                        Spacer()
                                        
                                        Text("VOLUME")
                                            .bold()
                                            .foregroundColor(Color(.theme))
                                            .font(.system(size: 17))
                                        
                                        Spacer()
                                    })
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom,5)
                                    
                                    HStack(content: {
                                        Spacer()
                                        
                                        Text(store.detailProduct[0].region)
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
                                        .foregroundColor(Color(.theme))
                                        .font(.system(size: 17))
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom,5)
                                    
                                    Text(store.detailProduct[0].price)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                    
                                    
                                    
                                })
                                .padding()
                                
                            })
                            
                            Spacer()
                            
                            // Create Taste Note
                            NavigationLink(destination: TastingNoteView(
                                noteStore: noteStore,
                                wineName: store.detailProduct[0].name,
                                wineYear: formatNumberWithoutCommas(store.detailProduct[0].year),
                                winePrice: store.detailProduct[0].price,
                                wineType: store.detailProduct[0].wineType,
                                wineSugar: store.detailProduct[0].sugar,
                                wineBody: store.detailProduct[0].bodyPercent,
                                wineTannin: store.detailProduct[0].tanning,
                                winepH: store.detailProduct[0].pH,
                                wineAlcohol: store.detailProduct[0].alcohol,
                                wineImage: store.detailProduct[0].wineImage
                            )) {
                                Text("Create Taste Note")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.theme)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .bold()
                            }
                            .padding(.bottom,20)
                            Spacer()
                            
                            Text("ABOUT THE PRODUCT")
                                .bold()
                                .foregroundColor(Color(.theme))
                                .font(.system(size: 24))
                                .padding(.bottom)
                            
                            Text(store.detailProduct[0].description)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 10))
                            
                            HStack(content: {
                            Picker(selection: $store.selectedWineInfo, label: Text("Wine Info")) {
                                Text("Food Pairings").tag(0)
                                Text("Flavor Profile").tag(1)
                                Text("Description").tag(2)
                                
                            } // Picker
                            .pickerStyle(.segmented)
                            .onAppear(perform: {
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(.theme)], for: .selected)
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(Color(.gray).opacity(0.8))], for: .normal)
                            })
                                

                            }) // HStack
                            .padding(.bottom, 5)
                            
                            if store.selectedWineInfo == 0 {
                                ScrollView(.horizontal, content: {
        //                            LazyHGrid(rows: [GridItem(.adaptive(minimum: 100))], spacing: 10, content: {
                                            
                                        HStack{
                                            ForEach(store.foodArray, id: \.self) { url in
                                                VStack{
                                                    AsyncImage(url: URL(string: url[0])) { phase in
                                                        switch phase {
                                                        case .empty:
                                                            EmptyView() // food가 없을경우 view를 보여주지 않음
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
                                                    Text(url[1])
                                                }
                                        }
                                    }
                                })
                            }
                            
                            if store.selectedWineInfo == 1 {
                             // Sliders (Sugar, Body, Tannin)
                                VStack(alignment: .leading, spacing: 13) {
                                    SlidersField(value: $store.detailProduct[0].sugar, label: "Sugar")
                                        .disabled(true) // Sugar 슬라이더를 비활성화
                                    SlidersField(value: $store.detailProduct[0].bodyPercent, label: "Body")
                                        .disabled(true) // Body 슬라이더를 비활성화
                                    SlidersField(value: $store.detailProduct[0].tanning, label: "Tannin")
                                        .disabled(true) // Tannin 슬라이더를 비활성화
                                    SlidersField(value: $store.detailProduct[0].pH, label: "pH")
                                        .disabled(true) // pH 슬라이더를 비활성화
                                        }
                                         .padding(.horizontal, 20)
                                         .padding(.top, 20)
                                         
                            }
                           
                            if store.selectedWineInfo == 2 {
                                VStack(spacing: 10) {
                                    HStack(content: {
                                        Image(systemName: "bolt.shield")
                                        Text("Winery")
                                        Spacer()
                                        Text(store.detailProduct[0].winery)
                                        Spacer()
                                    })
                                }
                                Divider()
                                    .background(Color(.black))
                                
                                HStack(content: {
                                    Image(systemName: "wineglass")
                                    Text("Grapes")
                                    Spacer()
                                    Text(store.detailProduct[0].grapeTypes)
                                    Spacer()
                                })
                                Divider()
                                    .background(Color(.black))
                                
                                HStack(content: {
                                    Image(systemName: "location")
                                    Text("Region")
                                    Spacer()
                                    Text(store.detailProduct[0].region)
                                    Spacer()
                                })
                                Divider()
                                    .background(Color(.black))
                                
                                HStack(content: {
                                    Image(systemName: "flame")
                                    Text("Wine Type")
                                    Spacer()
                                    Text(store.detailProduct[0].wineType)
                                    Spacer()
                                })
                                Divider()
                                    .background(Color(.black))
                                
                                HStack(content: {
                                    Image(systemName: "eyes")
                                    Text("Allergens")
                                    Spacer()
                                    Text("Contains sulfites")
                                    Spacer()
                                })
                                Divider()
                                    .background(Color(.black))
                            }
                            
                            Text("ABOUT WINERY")
                                .bold()
                                .foregroundColor(Color(.theme))
                                .font(.system(size: 24))
                                .padding()
                            
                            HStack(alignment: .center, content: {
                                AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/197/197560.png")) { phase in
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
                                    .frame(width: 30, height: 30) // 원하는 크기로 프레임 설정
                                
                                Text("\(store.detailProduct[0].winery), France")
                                
                                Spacer()
                            })
                            
                        })
                        .padding()
                    }
                    .navigationTitle("Detail View")
                    .navigationBarTitleDisplayMode(.inline)
            }
        } // NavigationView
        .onAppear(perform: {
            store.send(.fetchDetailProducts(index))
        })

        
        
    } // body
    
    // rating 별점 계산
    private func starType(for index: Int) -> String {
        let fullStarThreshold = index + 1
        let halfStarThreshold = Double(index) + 0.5
        
        if store.detailProduct[0].rating >= Double(fullStarThreshold) {
            return "star.fill"
        } else if store.detailProduct[0].rating >= halfStarThreshold {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
    
    // 년도 컴마 없애주는것
    private func formatNumberWithoutCommas(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
}

//#Preview {
//    ProductDetail(
//        store: Store(initialState:
//                        DetailFeature.State()){
//            DetailFeature()
//        },
//        noteStore: Store(initialState: TastingNoteFeature.State()) {
//            TastingNoteFeature()
//        }
//    )
//}
