//
//  UserInsert.swift
//  Vinoble
//
//  Created by won on 6/12/24.
//

import SwiftUI
import Firebase

struct UserInsert{
    let db = Firestore.firestore()
    @Binding var userid: String
    @Binding var userpw: String
    @Binding var result: Bool

    
}
