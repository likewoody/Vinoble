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
    
    // 생성자
    init() {
        // 데이터베이스 파일 URL 생성
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("newWine.sqlite")
        
        // 파일 경로 출력
        print("Database file path: \(fileURL.path)")
        
        // 데이터베이스 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // 테이블 생성
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS wishlist(id INTEGER PRIMARY KEY AUTOINCREMENT, isWish INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errMsg)")
        }
    }
    
    // search Query
    // SwiftUI에서는 Protocol 사용 대신에 SearchQuery에서 [Student] type으로 바로 return 해준다.
    // 작업처리가 몇번 덜 움직이기 때문에 효율적이다.
    func queryDB() -> [WishListModel]{
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM wishlist"
        
        // 에러가 발생하는지 확인하기 위해서 if문 사용
        // -1 unlimit length 데이터 크기를 의미한다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table\ncode : \(errMsg)")
        }
        
        // 불러올 데이터가 있다면 불러온다.
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let isWish = Int(sqlite3_column_int(stmt, 1))
            
            wishlist.append(WishListModel(id: id, wishlist: isWish))
        }
        
        print("succesfully searched in queryDB")
        return wishlist
    }

    // insert
    func insertDB(wishlist: Int) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let queryString = "INSERT INTO wishlist (isWish) VALUES (?)"

        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_int64(stmt, 1, sqlite3_int64(wishlist))
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("succesfully insert in insertDB")
            return true
        } else {
            print("실패")
            return false
        }
    }
    
    // update query
    func updateDB(wishlist: Int, id: Int) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let queryString = "UPDATE wishlist SET isWish = ? WHERE id = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_int64(stmt, 1, sqlite3_int64(wishlist))
        sqlite3_bind_int64(stmt, 2, sqlite3_int64(id))
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            print("실패")
            return false
        }
    }
}




