//
//  ClassIdentifiable.swift
//  FinancialHouse
//
//  Created by Olgu SIRMAN on 22.07.18.
//  Copyright © 2018 Olgu SIRMAN. All rights reserved.
//

import UIKit

protocol ClassIdentifiable: class {
    static var reuseId: String { get }
}

extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}
