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
 Description : CRUD function implementation day 1
 
 Author : Diana
 Date : 2024.06.12 Wed
 Description : CRUD function implementation day 2
 
 Author : Diana
 Date : 2024.06.13 Thurs
 Description : CRUD function implementation day 3
 - insert function complete
 
 Author : Diana
 Date : 2024.06.13 Fri
 Description : finishing up
 - passing on values from detail view
 - navigation complete
 */


import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct TastingNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    @State var showingAlert = false
    
    let userid = UserDefaults.standard.string(forKey: "userEmail") ?? "qwe@qwe.qwe"

    // Receive the wine details
    let wineName: String
    let wineYear: String
    let winePrice: String
    let wineType: String
    let wineSugar: Double
    let wineBody: Double
    let wineTannin: Double
    let winepH: Double
    let wineAlcohol: String
    let wineImage: String

    // Use @Bindable to make the noteStore mutable
    @Bindable var noteStore: StoreOf<TastingNoteFeature>

    // Example stores for navigation
    let productStore: StoreOf<ProductFeature> = Store(
        initialState: ProductFeature.State(),
        reducer: { ProductFeature() }
    )

    // init
    init(noteStore: StoreOf<TastingNoteFeature>, wineName: String, wineYear: String, winePrice: String, wineType: String, wineSugar: Double, wineBody: Double, wineTannin: Double, winepH: Double, wineAlcohol: String, wineImage: String) {
        self.noteStore = noteStore
        self.wineName = wineName
        self.wineYear = wineYear
        self.winePrice = winePrice
        self.wineType = wineType
        self.wineSugar = wineSugar
        self.wineBody = wineBody
        self.wineTannin = wineTannin
        self.winepH = winepH
        self.wineAlcohol = wineAlcohol
        self.wineImage = wineImage

        // Update the noteStore values IMMEDIATELY in the init() method
        self.noteStore.wineName = wineName
        self.noteStore.wineYear = wineYear
        self.noteStore.winePrice = winePrice
        self.noteStore.wineType = wineType
        self.noteStore.wineSugar = wineSugar
        self.noteStore.wineBody = wineBody
        self.noteStore.wineTannin = wineTannin
        self.noteStore.winepH = winepH
        self.noteStore.wineAlcohol = wineAlcohol
        self.noteStore.wineImage = wineImage
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0))
                                .frame(width: 110, height: 215)
                                .overlay {
                                    WebImage(url: URL(string: noteStore.wineImage))
                                        .resizable()
                                        .indicator(.activity)
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                }
                                .onTapGesture {
                                    isShowingImagePicker = true
                                }
                        }
                        
                        // Info TextField (Name, Price, Type)
                        VStack(alignment: .leading, spacing: 20) {
                            TextField("Wine Name", text: $noteStore.wineName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                                .bold()
                            
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
                                    Text("Red").tag("red")
                                    Text("White").tag("white")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 220)
                                .background(
                                    Color(noteStore.wineType == "red" ? .theme : .white)
                                        .opacity(0.1)
                                        .cornerRadius(8)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 35)
                    
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
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.theme.opacity(0.5)))
                            
                        HStack {
                            Spacer()
                            Button(action: {
                                // ADD TO CELLAR ACTION
                                noteStore.send(.insertCellar(userid))
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
        .onChange(of: noteStore.state.insertSuccess) { newValue in
            if newValue {
                noteStore.send(.selectCellar(userid))
                showingAlert = true
            }
        }
        .alert("Added to My Cellar!", isPresented: $showingAlert) {
            Button("OK", action: {
                presentationMode.wrappedValue.dismiss()
            })
        }
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

// Preview with sample data
#Preview {
    TastingNoteView(
        noteStore: Store(
            initialState: TastingNoteFeature.State(seq: 1),
            reducer: { TastingNoteFeature() }
        ),
        wineName: "Example Wine",
        wineYear: "2020",
        winePrice: "$25.99",
        wineType: "red",
        wineSugar: 50.0,
        wineBody: 60.0,
        wineTannin: 40.0,
        winepH: 3.5,
        wineAlcohol: "13.5%",
        wineImage: "https://images.vivino.com/thumbs/BrbHdEB8TqK2N61pvLoQeQ_pb_x600.png"
    )
}
