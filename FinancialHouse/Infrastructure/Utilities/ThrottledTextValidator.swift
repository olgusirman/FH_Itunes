//
//  ThrottledTextValidator.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import Foundation

final class ThrottledTextValidator {
    private var lastQuery: String?
    private let throttle: Throttle
    private let validationRule: ((String) -> Bool)
    
    init(throttle: Throttle = Throttle(minimumDelay: 0.7),
         validationRule: @escaping ((String) -> Bool) = { query in return query.count > 2 }) {
        self.throttle = throttle
        self.validationRule = validationRule
    }
    
    func validate(query: String,
                  completion: @escaping ((String?) -> ())) {
        guard validationRule(query),
            distinctUntilChanged(query) else {
                completion(nil)
                return
        }
        throttle.throttle {
            completion(query)
        }
    }
    
    private func distinctUntilChanged(_ query: String) -> Bool {
        let valid = lastQuery != query
        lastQuery = query
        return valid
    }
}
