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
 Description : CRUD function implementation day 1
 
 Author : Diana
 Date : 2024.06.12 Wed
 Description : CRUD function implementation day 2
 */

// MyCellarView.swift
import SwiftUI
import ComposableArchitecture

struct MyCellarView: View {
    @State private var showUpdateTastingNote = false
    @State private var selectedWine: Wine?
    let store: StoreOf<ProductFeature>
    @Bindable var noteStore: StoreOf<TastingNoteFeature>
    @State private var isDeleteConfirmationShown = false
    @State private var deletionIndex: Int?
    
    private func deleteItems(at offsets: IndexSet) {
        deletionIndex = offsets.first
        isDeleteConfirmationShown = true
    }
    
    init(store: StoreOf<ProductFeature>, noteStore: StoreOf<TastingNoteFeature>) {
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
                                .padding(.trailing, 40)
                            VStack(alignment: .leading, spacing: 10) {
                                Text(wine.name)
                                    .bold()
                                Text(wine.year)
                                Text(wine.type)
                            }
                        }
                    }
                    .font(.system(size: 15, design: .serif))
                    .onTapGesture {
                        noteStore.send(.setSelectedWine(wine))
                        selectedWine = wine
                        showUpdateTastingNote = true
                    }
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
            .actionSheet(isPresented: $isDeleteConfirmationShown) {
                ActionSheet(
                    title: Text("Delete Wine"),
                    message: Text("Are you sure you want to delete this wine?"),
                    buttons: [
                        .destructive(Text("Delete")) {
                            if let index = deletionIndex {
                                noteStore.send(.deleteCellar(noteStore.cellarList[index]))
                                deletionIndex = nil
                            }
                        },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showUpdateTastingNote) {
                UpdateTastingNoteView(store: store, noteStore: noteStore)
            }
        }
    }
}
    
    #Preview {
        MyCellarView(store: Store(initialState: ProductFeature.State()) {
            ProductFeature()
        }, noteStore: Store(initialState: TastingNoteFeature.State(seq: 1)) {
            TastingNoteFeature()
        })
    }

