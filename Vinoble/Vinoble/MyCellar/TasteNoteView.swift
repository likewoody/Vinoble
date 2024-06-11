//  TasteNoteView.swift
//  Vinoble
//
//  Created by Diana Kim on 6/9/24.
//

/*
 Author : Diana
 Date : 2024.06.10 Monday
 Description : 1차 UI frame 작업
 */

import SwiftUI
import ComposableArchitecture

struct TasteNoteView: View {
    
    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    @State var winename: String = ""
    @State var wineprice: String = ""
    @State var wineNote: String = ""
    @State var wineyear: String = ""
    @State var winetype: String?
    @State var sugar: Double = 0
    @State var wineBody: Double = 0
    @State var tannin: Double = 0
    @State var alcohol: String = ""
    @State var ph: String = ""
    
    let store: StoreOf<ProductFeature>
    
    // color
    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
    
    // MARK: Title format
    init(store: StoreOf<ProductFeature>) {
        self.store = store
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: shareColor.initColorWithAlpha(),
            .font: UIFont.boldSystemFont(ofSize: 24.0)
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 130, height: 160)
                            .overlay {
                                if let selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 130, height: 160)
                                        .cornerRadius(10)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                            }
                            .onTapGesture {
                                isShowingImagePicker = true
                            }
                        
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            Text("Choose Image")
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color(shareColor.mainColor()))
                                .cornerRadius(10)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        TextField("Wine Name",text: $winename)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))
                        
                        TextField("Wine Price",text: $wineprice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))
                        
                        TextField("Wine Year",text: $wineyear)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))
                        
                        HStack {
                            Picker("Wine Type", selection: $winetype) {
                                Text("Red")
                                Text("White")
                                
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 190)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                             SlidersField(value: $sugar, label: "Sugar")
                             SlidersField(value: $wineBody, label: "Body")
                             SlidersField(value: $tannin, label: "Tannin")
                             
//                             TextField("Alcohol", text: $alcohol)
//                                 .textFieldStyle(RoundedBorderTextFieldStyle())
//                                 .font(.system(size: 16))
//                             
//                             TextField("pH Level(%)", text: $ph)
//                                 .textFieldStyle(RoundedBorderTextFieldStyle())
//                                 .font(.system(size: 16))
                         }
                         .padding(.horizontal, 20)
                         .padding(.top, 20)

                // NOTE
                VStack(alignment: .leading, spacing: 13) {
                    Text("Note:")
                        .font(.system(size: 16, design: .serif))
                    TextEditor(text: $wineNote)
                        .frame(minHeight: 150)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    HStack {
                        Spacer()
                        Button(action: {
                            // Update ACTION
                           
                        }) {
                            Text("Update")
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color(shareColor.mainColor()))
                                .cornerRadius(10)
                        }
                        Spacer()

                        Button(action: {
                            // Delete ACTION
                           
                        }) {
                            Text("Delete")
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Color(shareColor.mainColor()))
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 30)
          
            }
            .navigationTitle("Taste Note")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
} // tastingnote view


struct SlidersField: View {
    @Binding var value: Double
    let label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label): \(Int(value))%")
                .font(.system(size: 15, design: .serif))
                .bold()
            Slider(value: $value, in: 0...100)
        }
    }
}

#Preview {
    TasteNoteView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}

