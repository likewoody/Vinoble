//
//  SQLite.swift
//  Vinoble
//
//  Created by Woody on 6/12/24.
//

import SQLite3
import SwiftUI

// ObservableObject 프로토콜을 채택한 클래스
class KeywordDB: ObservableObject {
    // SQLite3 데이터베이스 포인터
    var db: OpaquePointer?
    var searchKeywords: [Keyword] = []
    
    // 생성자
    init() {
        // 데이터베이스 파일 URL 생성
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("keywords.sqlite")
        
        // 파일 경로 출력
        print("Database file path: \(fileURL.path)")
        
        // 데이터베이스 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // 테이블 생성
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS keywords(id INTEGER PRIMARY KEY AUTOINCREMENT, searchKeyword TEXT)", nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db))
            print("error creating table: \(errMsg)")
        }
    }
    
    // search Query
    // SwiftUI에서는 Protocol 사용 대신에 SearchQuery에서 [Student] type으로 바로 return 해준다.
    // 작업처리가 몇번 덜 움직이기 때문에 효율적이다.
    func queryDB() -> [Keyword]{
        var stmt: OpaquePointer?
        let queryString = "SELECT * FROM keywords"
        
        // 에러가 발생하는지 확인하기 위해서 if문 사용
        // -1 unlimit length 데이터 크기를 의미한다
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table\ncode : \(errMsg)")
        }
        
        // 불러올 데이터가 있다면 불러온다.
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(stmt, 0))
            let searchKeyword = String(cString: sqlite3_column_text(stmt, 1))
            
            searchKeywords.append(Keyword(keyword: searchKeyword))
        }
        
        print("succesfully searched in queryDB")
        return searchKeywords
    }
    

    // insert
    func insertDB(searchKeyword: String) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "INSERT INTO keywords (searchKeyword) VALUES (?)"

        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_text(stmt, 1, searchKeywords, -1, SQLITE_TRANSIENT)
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("succesfully insert in insertDB")
            return true
        } else {
            print("실패")
            return false
        }
    }
    
    // delete query
    func deleteDB(id: Int) -> Bool{
        var stmt: OpaquePointer?
        
        // 2 bytes의 코드를 쓰는 곳에서 사용함 (한글)
        // -1 unlimit length 데이터 크기를 의미한다
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let queryString = "DELETE FROM keywords WHERE id = ?"
        
        sqlite3_prepare(db, queryString, -1, &stmt, nil)
        
        // insert 실행
        // type이 text이기 때문에 bind_text 타입 잘 확인
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            return true
        } else {
            print("실패")
            return false
        }
    }
}



