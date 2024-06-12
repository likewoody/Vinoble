//
//  RegularExpression.swift
//  Vinoble
//
//  Created by won on 6/12/24.
//

import Foundation

struct RegularExpression{
    
    let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
    let passwordRegex = #"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"#

    func isValidEmailFunc(_ email: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: emailRegex) else { return false }
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex.firstMatch(in: email, options: [], range: range) != nil
    }
    
    func isValidPwFunc(_ password: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: passwordRegex) else { return false }
        let range = NSRange(location: 0, length: password.utf16.count)
        return regex.firstMatch(in: password, options: [], range: range) != nil
    }

}
