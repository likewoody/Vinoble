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
 Description : core function implementation day 1
 
 Author : Diana
 Date : 2024.06.12 Wed
 Description : core function implementation day 2
 - querying pressed item's information complete
 
 Author : Diana
 Date : 2024.06.13 Thurs
 Description : core function implementation day 3
 - update function complete
 - calling image from cellarlist complete
 
 Author : Diana
 Date : 2024.06.13 Fri
 Description : finishing up
 */

import SwiftUI
import ComposableArchitecture
import SDWebImageSwiftUI

struct UpdateTastingNoteView: View {
    
    @State var selectedImage: UIImage?
    @State var isShowingImagePicker = false
    let store: StoreOf<ProductFeature>
    @Bindable var noteStore: StoreOf<TastingNoteFeature>
    @Binding var isPresented : Bool
    
    // Init
    init(store: StoreOf<ProductFeature>, noteStore: StoreOf<TastingNoteFeature>, isPresented: Binding<Bool>) {
        self.noteStore = noteStore
        self.store = store
        self._isPresented = isPresented
       
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack(alignment: .top, spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0))
                                .frame(width: 130, height: 205)
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
                            
                            Button(action: {
                                isShowingImagePicker = true
                            }) {
                                Text("Choose Image")
                                    .font(.system(size: 15, design: .serif))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.gray)
                                    .bold()
                                    .cornerRadius(10)
                            }
                            .disabled(true)
                        }
                        // Info TextField (Name, Price, Type)
                        VStack(alignment: .leading, spacing: 20) {
                            TextField("Wine Name",text: $noteStore.wineName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                                .bold()
                            
                            TextField("Wine Year",text: $noteStore.wineYear)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            TextField("Wine Price",text: $noteStore.winePrice)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            TextField("Alcohol %",text: $noteStore.wineAlcohol)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.system(size: 15, design: .serif))
                            
                            HStack {
                                Picker("Wine Type", selection: $noteStore.wineType) {
                                    Text("Red").tag("red")
                                    Text("White").tag("white")
                                    
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .frame(width: 200)
                                .background(
                                    Color(noteStore.wineType == "red" ? .theme : .white)
                                        .opacity(0.1)
                                        .cornerRadius(8)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    // Sliders (Sugar, Body, Tannin)
                    VStack(alignment: .leading, spacing: 13) {
                            SlidersField(value: $noteStore.wineSugar, label: "Sugar")
                            SlidersField(value: $noteStore.wineBody, label: "Body")
                            SlidersField(value: $noteStore.wineTannin, label: "Tannin")
                            SlidersField(value: $noteStore.winepH, label: "pH")
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
                                 // update action
                                let updatedWine = Wine(
                                    wineindex: noteStore.state.wineindex,
                                    name: noteStore.state.wineName,
                                    year: noteStore.state.wineYear,
                                    price: noteStore.state.winePrice,
                                    sugar: noteStore.state.wineSugar,
                                    body: noteStore.state.wineBody,
                                    tannin: noteStore.state.wineTannin,
                                    type: noteStore.state.wineType,
                                    note: noteStore.state.wineNote,
                                    pH: noteStore.state.winepH,
                                    alcohol: noteStore.state.wineAlcohol,
                                    image: noteStore.state.wineImage
                               )
                               noteStore.send(.updateCellar(updatedWine))
                            }) {
                                Text("Update Note")
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
                         Text("Update Tasting Note")
                             .padding(.top, 15)
                             .font(.system(size: 25, design: .serif))
                             .foregroundColor(.theme)
                             .bold()
                     }
                }
            }
        } // navigation view
        .onChange(of: noteStore.state.updateSuccess){
            isPresented = false
        }
    } // body
} // updatetastingnote view



// Slider Function + design
struct SlidersField: View {
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
    UpdateTastingNoteView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    }, noteStore: Store(initialState: TastingNoteFeature.State(seq: 1)) {
        TastingNoteFeature()
    },
    isPresented: .constant(true)
    )
}
