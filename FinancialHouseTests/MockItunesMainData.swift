//
//  MockItunesMainData.swift
//  FinancialHouseTests
//
//  Created by Olgu on 21.10.2020.
//

@testable import FinancialHouse
import Foundation

func configureMockItems(T: AnyObject.Type) -> ItunesMainData? {
    
    if let path = Bundle(for: T.self).path(forResource: "itunesItems", ofType: "json") {
        do {
            let fileUrl = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            
            let apiResponse = try newJSONDecoder().decode(ItunesMainData.self, from: data)
            return apiResponse
        } catch {
            // Handle error here
            return nil
        }
    }
    return nil
}
