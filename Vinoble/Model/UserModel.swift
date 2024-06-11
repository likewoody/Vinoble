//
//  UserModel.swift
//  Vinoble
//
//  Created by won on 6/11/24.
//

import Foundation

struct UserModel{
    var documentId: String
    var userid: String
    var userpw: String
    var userjoindate: String
    var userdeldate: String
    
    init(documentId: String, userid: String, userpw: String, userjoindate: String, userdeldate: String) {
        self.documentId = documentId
        self.userid = userid
        self.userpw = userpw
        self.userjoindate = userjoindate
        self.userdeldate = userdeldate
    }
}
