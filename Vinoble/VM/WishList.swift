//
//  WishList.swift
//  Vinoble
//
//  Created by Woody on 6/13/24.
//

import SQLite3
import SwiftUI

// ObservableObject 프로토콜을 채택한 클래스
class WishList: ObservableObject {
    // SQLite3 데이터베이스 포인터
    var db: OpaquePointer?
    var wishlist: [WishListModel] = []
    let table_name : String = "wishlist"
    
    // 생성자
    init() {
        // 데이터베이스 파일 URL 생성
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("wineWishlist.sqlite")
        
        // 파일 경로 출력
        print("Database file path: \(fileURL.path)")
        
        // 데이터베이스 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // 테이블 생성
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(table_name) (id INTEGER PRIMARY KEY AUTOINCREMENT, productID INTEGER, isWish INTEGER, userEmail TEXT)", nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errMsg)")
        }
    }
    
    // search Query
    // SwiftUI에서는 Protocol 사용 대신에 SearchQuery에서 [Student] type으로 바로 return 해준다.
    // 작업처리가 몇번 덜 움직이기 때문에 효율적이다.
    func queryDB() async -> [WishListModel]{
        var stmt: OpaquePointer?
        
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "SELECT * FROM \(table_name)"
//        var result: Bool = false
        
        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing statement: \(errMsg)")
        }
        
//        sqlite3_bind_text(stmt, 1, userEmail, -1, SQLITE_TRANSIENT)
        
        // 조건 검색이 실행 됬는지 확인하기 위해서
//        if sqlite3_step(stmt) == SQLITE_DONE {
//            result = true
//        } else {
//            result = false
//        }
        // 불러올 데이터가 있다면 불러온다.
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let productID = Int(sqlite3_column_int(stmt, 1))
            let isWish = Int(sqlite3_column_int(stmt, 2))
            let userEmail = String(cString: sqlite3_column_text(stmt, 3))
            
            wishlist.append(WishListModel(id: id, productID: productID, isWish: isWish, userEmail: userEmail))
        }
        
//        if result {
//            print("succesfully searched in queryDB")
//        } else {
//            print("failed searched in queryDB....")
//        }

    
        sqlite3_finalize(stmt)
        
        return wishlist
    }

    // insert
    func insertDB(productID: Int, isWish: Int, userEmail: String) async -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO \(table_name) (productID, isWish, userEmail) VALUES (?, ?, ?)"

//        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        // preprae with error 체크
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert:v1 \(errMsg)")
        }
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
//        sqlite3_bind_int64(stmt, 1, sqlite3_int64(isWish))
        if sqlite3_bind_int64(stmt, 1, sqlite3_int64(productID)) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture productID: \(errMsg)")
        }
        
//        sqlite3_bind_int64(stmt, 2, sqlite3_int64(isWish))
        if sqlite3_bind_int64(stmt, 2, sqlite3_int64(isWish)) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture isWish: \(errMsg)")
        }
//        sqlite3_bind_text(stmt, 3, userEmail, -1, SQLITE_TRANSIENT)
        if sqlite3_bind_text(stmt, 3, userEmail, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture userEmail: \(errMsg)")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("succesfully insert in insertDB")
            return true
        } else {
            print("실패")
            return false
        }
    }
    
    // update query
    func updateDB(productID: Int, isWish: Int, userEmail: String) async -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "UPDATE wishlist SET isWish = ? WHERE userEmail = ? and productID = ?"
        
//        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        // error 체크
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
        }
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
//        sqlite3_bind_int64(stmt, 1, sqlite3_int64(isWish))
        if sqlite3_bind_int64(stmt, 1, sqlite3_int64(isWish)) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture isWish: \(errMsg)")
        }
        
        //        sqlite3_bind_text(stmt, 3, userEmail, -1, SQLITE_TRANSIENT)
//        sqlite3_bind_text(stmt, 2, userEmail, -1, SQLITE_TRANSIENT)
        if sqlite3_bind_text(stmt, 2, userEmail, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture userEmail: \(errMsg)")
        }
        
//        sqlite3_bind_int64(stmt, 3, sqlite3_int64(productID))
        if sqlite3_bind_int64(stmt, 3, sqlite3_int64(productID)) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture isWish: \(errMsg)")
        }

        if sqlite3_step(stmt) == SQLITE_DONE {
//            print("successfully updated DB!")
            sqlite3_finalize(stmt)
            print("update success")
            return true
        } else {
            print("실패")
            return false
        }
    }
}




