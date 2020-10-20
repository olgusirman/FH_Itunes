//
//  BaseViewController.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

class BaseViewController: UIViewController {
    
    let reachability = try! Reachability()
    var networkConnectionHandler: ((_ isOffline: Bool) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureReachability()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    private func configureReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    var cachedTitle: String?
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            debugPrint("Reachable via WiFi")
            if let cachedTitle = cachedTitle {
                self.navigationItem.title = cachedTitle
            }
            networkConnectionIsChanged(isOffline: false)
            networkConnectionHandler?(false)
        case .cellular:
            debugPrint("Reachable via Cellular")
            if let cachedTitle = cachedTitle {
                self.navigationItem.title = cachedTitle
            }
            networkConnectionIsChanged(isOffline: false)
            networkConnectionHandler?(false)
        case .unavailable:
            debugPrint("Network not reachable")
            self.cachedTitle = navigationItem.title
            self.navigationItem.title = "Your Internet Connection is offline..!"
            networkConnectionIsChanged(isOffline: true)
            networkConnectionHandler?(true)
        case .none:
            print("....")
        }
    }
    
    func networkConnectionIsChanged(isOffline: Bool) {
        
    }
    
    func resign() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
