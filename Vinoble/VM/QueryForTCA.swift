//
//  QueryForTCA.swift
//  Vinoble
//
//  Created by Woody on 6/12/24.
//

import SwiftUI
import Firebase
import ComposableArchitecture

struct QueryForTCA{
    let db = Firestore.firestore()
    @Bindable var store: StoreOf<ProductFeature>
    
    func fetchUserInfo(userid : String, userpw: String) async throws -> UserModel { // async throws 추가
        var userInfo: UserModel?
        store.firebaseResult = false

        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // await 추가
                .whereField("userid", isEqualTo: userid)
                .whereField("userpw", isEqualTo: userpw)
                .getDocuments() // 에러 발생 가능성 추가 (throws)

            store.firebaseResult = true // 데이터 가져오기 성공 시 true 설정

            for document in querySnapshot.documents {
                
                userInfo = UserModel(
                    documentId: document.documentID,
                    userid: document.data()["userid"] as! String,
                    userpw: document.data()["userpw"] as! String,
                    userjoindate: document.data()["userjoindate"] as! String,
                    userdeldate: document.data()["userdeldate"] as! String
                )
            }
        } catch {
            print("Error getting documents: \(error)") // 에러 처리
        }

        return userInfo ?? UserModel(documentId: "", userid: "", userpw: "", userjoindate: "", userdeldate: "")
    }
    
    func checkUserEmail(userid : String) async throws -> Bool {
        var isSameEmail: Bool = true
        store.firebaseResult = false
        
        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // await 추가
                .whereField("userid", isEqualTo: userid)
                .getDocuments() // 에러 발생 가능성 추가 (throws)
            
            if querySnapshot.documents.isEmpty{
                isSameEmail = false  // 같은 이메일이 없음
            }else{
                isSameEmail = true // 같은 이메일이 있음
            }

        } catch {
            print("Error getting documents: \(error)") // 에러 처리
        }

        return isSameEmail
    }
    
} // struct UserQuery
