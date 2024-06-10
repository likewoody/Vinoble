//
//  MyCellarView.swift
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

struct MyCellarView: View {
    
    // variables
    @State private var showTastingNote = false
    @State private var cellarList: [[String]] = [
        ["Concha", "bor", "2014", "flower_02"],
        ["Merlot", "rhone", "2024", "flower_03"],
        ["Cabernet sauvignon", "misa", "2011", "flower_04"]
    ]
    
    let store: StoreOf<ProductFeature>
    
    // Delete Function
    private func deleteItems(at offsets: IndexSet) {
        cellarList.remove(atOffsets: offsets)
    }
    
    // Color
    let shareColor = ShareColor(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
    
    // MARK: Title format
    init(store: StoreOf<ProductFeature>) {
        self.store = store
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: shareColor.initColorWithAlpha(), // Title color
                                                            
            .font: UIFont.boldSystemFont(ofSize: 24.0) // Title font size
        
        ]
    }
    

    var body: some View {
        NavigationView {
            List {
                ForEach(cellarList.indices, id: \.self) { index in
                    let wine = cellarList[index]
                    VStack {
                        HStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(shareColor.mainColor().opacity(0.2))
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
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My Cellar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showTastingNote = true
                        }) {
                            Image(systemName: "square.and.pencil.circle")
                        }
                        .font(.system(size: 24))
                        .foregroundColor(Color(shareColor.mainColor()))
                    }
                }
            .sheet(isPresented: $showTastingNote) {
                    NewTasteNoteView(store: store)
            }
            
        }
    }
} // MyCellar View

#Preview {
    MyCellarView(store: Store(initialState: ProductFeature.State()){
        ProductFeature()
    })
}
