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
    let date = Date()
    let formatter = DateFormatter()
    @Binding var result: Bool

    func insertUser(userid: String, userpw: String) async throws -> Bool{
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 형식 설정
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 및 한국 시간대 설정
        
        result = false

        let formattedDate = formatter.string(from: date)
        
        do{
//            try await Task.sleep(nanoseconds: 5 * 1_000_000_000) // 3초 동안 대기

            try await db.collection("user")
                .addDocument(data: [
                "userid" : userid,
                "userpw" : userpw,
                "userjoindate" : formattedDate,
                "userdeldate" : "",
            ])
                .getDocument()
            
            result = true
            
        }catch{
            result = false
        }
        return result
        
    } // func insertUser
    
    func updatePw(documentId: String, userpw: String) async throws -> Bool{
        result = false
        
        do{
//            try await Task.sleep(nanoseconds: 5 * 1_000_000_000) // 3초 동안 대기

            try await db.collection("user").document(documentId)
                .updateData([
                "userpw" : userpw,
            ])
            
            result = true
            
        }catch{
            result = false
        }
        return result

    } // func updatePw
    
}
