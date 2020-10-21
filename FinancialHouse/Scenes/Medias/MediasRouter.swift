//
//  MediasRouter.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

@objc protocol MediasRoutingLogic {
    func routeToMediaDetail()
}

protocol MediasDataPassing {
    var dataStore: MediasDataStore? { get }
}

final class MediasRouter: NSObject, MediasRoutingLogic, MediasDataPassing {
    
    weak var viewController: MediasViewController?
    var dataStore: MediasDataStore?
    
    // MARK: Routing
    
    func routeToMediaDetail() {
        let storyboard = UIStoryboard(name: "MediaDetail", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(ofType: MediaDetailViewController.self)
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS)
        navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToSomewhere(source: MediasViewController, destination: MediaDetailViewController){
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToSomewhere(source: MediasDataStore, destination: inout MediaDetailDataStore) {
        destination.item = source.selectedItem
    }
}
