//  NewTasteNoteView.swift
//  Vinoble
//
//  Created by Diana Kim on 6/9/24.
//

/*
 Author : Diana
 Date : 2024.06.09 Sunday
 Description : 1차 UI frame 작업
 */

import SwiftUI
import ComposableArchitecture

struct NewTasteNoteView: View {
    
    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    @State var winename: String = ""
    @State var wineprice: String = ""
    @State var wineNote: String = ""
    @State var wineyear : String = ""
    @State var winetype : String?
    
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
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(shareColor.mainColor()))
                                .cornerRadius(10)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        TextField("Wine Name",text: $winename)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                        
                        TextField("Wine Price",text: $wineprice)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                        
                        TextField("Wine Year",text: $wineyear)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                        
                        HStack {
                            Picker("Wine Type", selection: $winetype) {
                                Text("Red")
                                Text("White")
                                Text("Rose")
                                
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 190)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                // NOTE
                VStack(alignment: .leading, spacing: 10) {
                    Text("Note:")
                        .font(.system(size: 16, weight: .bold))
                    TextEditor(text: $wineNote)
                        .frame(minHeight: 150) 
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                    HStack {
                        Spacer()
                        Button(action: {
                            // ADD ACTION
                            print("Tasting note saved!")
                        }) {
                            Text("Add")
                                .font(.system(size: 16, weight: .semibold))
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
} // tastingnote view

#Preview {
    NewTasteNoteView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}

