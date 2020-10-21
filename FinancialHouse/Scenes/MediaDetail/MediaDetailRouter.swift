//
//  MediaDetailRouter.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import UIKit

@objc protocol MediaDetailRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MediaDetailDataPassing {
    var dataStore: MediaDetailDataStore? { get }
}

class MediaDetailRouter: NSObject, MediaDetailRoutingLogic, MediaDetailDataPassing {
    
    weak var viewController: MediaDetailViewController?
    var dataStore: MediaDetailDataStore?
    
}
