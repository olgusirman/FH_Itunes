//
//  EmptyView.swift
//  FinancialHouse
//
//  Created by Olgu on 20.10.2020.
//

import UIKit

final class EmptyView: BaseView {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        resign()
    }
    
}
