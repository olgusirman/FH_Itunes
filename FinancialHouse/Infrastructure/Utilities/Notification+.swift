//
//  Notification+.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import Foundation

extension Notification.Name {
    static let itemDeleted = Notification.Name("itemDeleted")
}

@objc extension NSNotification {
    public static let itemDeleted = Notification.Name.itemDeleted
}
