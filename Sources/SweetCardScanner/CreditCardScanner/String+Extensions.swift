//
//  String+Extensions.swift
//  SweetCardScanner
//
//  Created by Aaron Lee on 2020-11-30.
//

import Foundation

extension String {
    
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex...endIndex])
    }
    
}
