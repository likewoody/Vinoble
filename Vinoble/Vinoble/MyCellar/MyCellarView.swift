
//  Vinoble
//
//  Created by Diana Kim on 6/9/24.
//

/*
 Author : Diana
 Date : 2024.06.09 Sun
 Description : 1차 UI frame Design
 
 Author : Diana
 Date : 2024.06.11 Tues
 Description : core function implementation day 1
 
 */

import SwiftUI
import ComposableArchitecture

struct MyCellarView: View {
    
    // test variables
    @State private var showUpdateTastingNote = false
    @State private var selectedWine : [String]?
    
    let store: StoreOf<ProductFeature>
    
    @Bindable var noteStore: StoreOf<TastingNoteFeature>
    
    // Delete Function
    private func deleteItems(at offsets: IndexSet) {
//        cellarList.remove(atOffsets: offsets)
    }
    
    // Color
//    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()){
//        ProductFeature()
//    })
    
    // init
    init(store: StoreOf<ProductFeature>,noteStore: StoreOf<TastingNoteFeature>) {
        self.store = store
        self.noteStore = noteStore
        self.noteStore.send(.selectCellar)
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(noteStore.cellarList.indices, id: \.self) { index in
                    let wine = noteStore.cellarList[index]
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.theme.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay {
                                    Image(wine[3])
                                        .resizable()
                                        .frame(width: 50, height: 100)
                                }
                                .padding(.trailing, 40)
                            VStack(alignment: .leading, spacing: 10) {
                                Text(wine[0])
                                    .bold()
                                Text(wine[1])
                                Text(wine[2])
                            }
                        }
                    }
                    .font(.system(size: 15, design: .serif))
                    .onTapGesture(perform: {
                        selectedWine = wine
                        showUpdateTastingNote = true
                    })
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                 ToolbarItem(placement: .principal) {
                     Text("My Cellar")
                         .font(.system(size: 23, design: .serif))
                         .padding(.top, 20)
                         .foregroundColor(.theme)
                         .bold()
                 }
             }
            .sheet(isPresented: $showUpdateTastingNote) {
                UpdateTastingNoteView(store: store, noteStore: noteStore)
            }
        } // navigation view
    } // body
} // myCellar view



#Preview {
    MyCellarView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    },noteStore: Store(initialState: TastingNoteFeature.State()) {
        TastingNoteFeature()
    })
}
