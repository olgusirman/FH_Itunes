//
//  CustomStringConvertible+.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import Foundation

extension CustomStringConvertible {
    var description : String {
        var description: String = ""
        description = "***** \(type(of: self)) *****\n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        return description
    }
}
