//  NewTasteNoteView.swift
//  Vinoble
//
//  Created by Diana Kim on 6/9/24.
//

/*
 Author : Diana
 Date : 2024.06.09 Sun
 Description : 1차 UI frame 작업
 */

import SwiftUI
import ComposableArchitecture

struct NewTasteNoteView: View {

    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    
    @Bindable var noteStore: StoreOf<NewTastingNoteFeature>

    let store: StoreOf<ProductFeature>
    
    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()) {
        ProductFeature()
    })

    init(store: StoreOf<ProductFeature>, noteStore: StoreOf<NewTastingNoteFeature>) {
        self.noteStore = noteStore
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
                                .font(.system(size: 15, design: .serif))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(shareColor.mainColor()))
                                .cornerRadius(10)
                        }
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        TextField("Wine Name", text: $noteStore.wineName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))

                        TextField("Wine Price", text: $noteStore.winePrice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))

                        TextField("Wine Year", text: $noteStore.wineYear)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))
                        
                        TextField("Wine Type", text: $noteStore.wineType)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 15, design: .serif))

                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 13) {
                    SliderField(value: $noteStore.wineSugar, label: "Sugar")
                    SliderField(value: $noteStore.wineBody, label: "Body")
                    SliderField(value: $noteStore.wineTannin, label: "Tannin")
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Note:")
                        .font(.system(size: 15, design: .serif))
                    TextEditor(text: $noteStore.wineNote)
                        .frame(minHeight: 150)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    HStack {
                        Spacer()
                        Button(action: {
                            
                            noteStore.send(.insertNewTasteNote)
                            
                        }) {
                            Text("Add")
                                .font(.system(size: 15, design: .serif))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
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
            .navigationTitle("New Tasting Note")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SliderField: View {
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
    NewTasteNoteView(store: Store(initialState: ProductFeature.State()) {
        ProductFeature()
    }, noteStore: Store(initialState: NewTastingNoteFeature.State()) {
        NewTastingNoteFeature()
    })
}
