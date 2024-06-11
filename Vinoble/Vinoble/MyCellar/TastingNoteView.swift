//  TasteNoteView.swift
//  Vinoble
//
//  Created by Diana Kim on 6/9/24.
//

/*
 Author : Diana
 Date : 2024.06.09 Sun
 Description : UI frame design
  
 Author : Diana
 Date : 2024.06.11 Tues
 Description : core function implementation day 1 (db insert)
 */

import SwiftUI
import ComposableArchitecture

struct TastingNoteView: View {

    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    
    @Bindable var noteStore: StoreOf<TastingNoteFeature>

    let store: StoreOf<ProductFeature>
    
    // color
//    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()) {
//        ProductFeature()
//    })
    
    // init
    init(store: StoreOf<ProductFeature>, noteStore: StoreOf<TastingNoteFeature>) {
        self.noteStore = noteStore
        self.store = store
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 130, height: 205)
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
                                    .font(.system(size: 15, design: .serif))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.theme)
                                    .bold()
                                    .cornerRadius(10)
                            }
                        }
                        
                        // Info TextField (Name, Price, Type)
                        VStack(alignment: .leading, spacing: 20) {
                            TextField("Wine Name", text: $noteStore.wineName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            TextField("Wine Year", text: $noteStore.wineYear)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            TextField("Wine Price", text: $noteStore.winePrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            TextField("Alcohol %", text: $noteStore.wineAlcohol)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            HStack {
                                Picker("Wine Type", selection: $noteStore.wineType) {
                                    Text("Red").tag("Red")
                                    Text("White").tag("White")
                                    
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 190)
                                .background(
                                    Color(noteStore.wineType == "Red" ? .theme : .white)
                                        .opacity(0.1)
                                        .cornerRadius(8)
                                )
                            }
                            
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Sliders (Sugar, Body, Tannin)
                    VStack(alignment: .leading, spacing: 13) {
                        SliderField(value: $noteStore.wineSugar, label: "Sugar")
                        SliderField(value: $noteStore.wineBody, label: "Body")
                        SliderField(value: $noteStore.wineTannin, label: "Tannin")
                        SliderField(value: $noteStore.winepH, label: "pH")
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    
                    // Note
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Note:")
                            .font(.system(size: 15, design: .serif))
                            .bold()
                        TextEditor(text: $noteStore.wineNote)
                            .frame(minHeight: 150)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                        HStack {
                            Spacer()
                            Button(action: {
                                // ADD TO CELLAR ACTION
                                noteStore.send(.insertCellar)
                                
                            }) {
                                Text("Add to My Cellar")
                                    .font(.system(size: 15, design: .serif))
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.theme)
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                     ToolbarItem(placement: .principal) {
                         Text("Tasting Note")
                             .padding(.top, 15)
                             .font(.system(size: 25, design: .serif))
                             .foregroundColor(.theme)
                             .bold()
                     }
                }
            }
        } // navigation view
    } // body
} // tastingnote view



// Slider Function + design
struct SliderField: View {
    @Binding var value: Double
    let label: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label): \(Int(value))%")
                .font(.system(size: 15, design: .serif))
                .bold()
            Slider(value: $value, in: 0...100)
                .accentColor(.theme)
        }
    }
}

#Preview {
    TastingNoteView(store: Store(initialState: ProductFeature.State()) {
        ProductFeature()
    }, noteStore: Store(initialState: TastingNoteFeature.State()) {
        TastingNoteFeature()
    })
}
