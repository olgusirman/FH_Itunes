//
//  BaseView.swift
//  FinancialHouse
//
//  Created by Olgu on 20.10.2020.
//

import UIKit

class BaseView: UIView {
    func resign() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
