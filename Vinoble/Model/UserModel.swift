//
//  UserModel.swift
//  Vinoble
//
//  Created by won on 6/11/24.
//

import Foundation

struct UserModel{
    var userid: String
    var userpw: String
    var userjoindate: String
    var userdeldate: String
    
    init(userid: String, userpw: String, userjoindate: String, userdeldate: String) {
        self.userid = userid
        self.userpw = userpw
        self.userjoindate = userjoindate
        self.userdeldate = userdeldate
    }
}
