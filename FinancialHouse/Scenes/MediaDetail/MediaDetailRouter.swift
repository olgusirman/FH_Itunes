//
//  MediaDetailRouter.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
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
