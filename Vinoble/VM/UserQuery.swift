//
//  UserQuery.swift
//  Vinoble
//
//  Created by won on 6/11/24.
//

import SwiftUI
import Firebase

class UserQueryTest: ObservableObject{
    let db = Firestore.firestore()
}

struct UserQuery{
    let db = Firestore.firestore()
    @Binding var userid: String
    @Binding var userpw: String
    @Binding var result: Bool
    
    func fetchUserInfo() async throws -> UserModel { // async throws 추가
        var userInfo: UserModel?

        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("user") // await 추가
                .whereField("userid", isEqualTo: userid)
                .whereField("userpw", isEqualTo: userpw)
                .getDocuments() // 에러 발생 가능성 추가 (throws)

            result = true // 데이터 가져오기 성공 시 true 설정

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
            result = false // 데이터 가져오기 실패 시 false 설정
            // 추가적인 에러 처리 로직 (필요에 따라)
        }

        return userInfo ?? UserModel(documentId: "", userid: "", userpw: "", userjoindate: "", userdeldate: "")
    }
    
} // struct UserQuery

