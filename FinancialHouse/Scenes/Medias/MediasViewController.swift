//
//  MediasViewController.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

protocol MediasDisplayLogic: AnyObject {
    func displayItems(viewModel: Medias.FetchMedias.ViewModel)
    func configureSearchBarPlaceholder(placeholder: String)
    func deleteMedia(viewModel: Medias.DeleteMedia.ViewModel)
    func updateMedia(viewModel: Medias.UpdateMedia.ViewModel)
}

final class MediasViewController: BaseViewController, MediasDisplayLogic {
    
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var emptyView: EmptyView!
    
    fileprivate var interactor: MediasBusinessLogic?
    fileprivate var router: (NSObjectProtocol & MediasRoutingLogic & MediasDataPassing)?
    fileprivate var viewModel: Medias.FetchMedias.ViewModel?
    
    // MARK: Setup
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = MediasInteractor()
        let presenter = MediasPresenter()
        let router = MediasRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchMedias()
        configureUI()
        configureNavigationBarItem()
        configureDeleteNotificationCenter()
        
        networkConnectionHandler = { [weak self] isOffline in
            self?.navigationItem.rightBarButtonItem?.isEnabled = !isOffline
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureUI() {
        collectionView.register(cellType: MediaCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }
    
    private func configureNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .done, target: self, action: #selector(selectTypeBarButtonPressed))
    }
    
    // MARK: - Actions
    @objc
    func selectTypeBarButtonPressed() {
        
        if let controller = interactor?.showMediaTypePopUp(typeSelectionHandler: { [weak self] type in
            self?.selectType(type: type)
        }) {
            self.present(controller, animated: true)
        }
    }
    
    private func selectType(type: Medias.FetchMedias.MediaType) {
        
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        fetchMedias(query: query, type: type, isThrottleActive: false)
    }
    
    // MARK: - Interactor
        
    private func fetchMedias(query: String = "", type: Medias.FetchMedias.MediaType? = nil, isThrottleActive: Bool = true) {
        
        let request: Medias.FetchMedias.Request
        
        /// Check the type situation, always response the latest selected one when searching
        if let type = type {
            request = Medias.FetchMedias.Request(term: query, media: type)
        } else if let latestSelectedType = interactor?.latestSelectedType {
            request = Medias.FetchMedias.Request(term: query, media: latestSelectedType)
        } else {
            request = Medias.FetchMedias.Request(term: query, media: .all)
        }
        
        if isThrottleActive {
            /// Improve the performance and searching user experience
            interactor?.fetchMediasWithThrottle(request: request)
        } else {
            interactor?.fetchMedias(request: request)
        }
        
    }
    
    // MARK: - MediasDisplayLogic
    
    func displayItems(viewModel: Medias.FetchMedias.ViewModel) {
        self.viewModel = viewModel
        configureEmptyViewIfNeeded(itemCount: viewModel.displayedMedias.count)
        collectionView.reloadData()
    }
    
    func configureEmptyViewIfNeeded(itemCount: Int) {
        emptyView.isHidden = itemCount != 0
    }
    
    func configureSearchBarPlaceholder(placeholder: String) {
        self.searchBar.placeholder = placeholder
    }
    
    private func configureDeleteNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(itemDeletedObserver(notification:)), name: .itemDeleted, object: nil)
    }
    
    @objc func itemDeletedObserver(notification: Notification) {
        guard let item = notification.object as? ItunesItem else { return }
        interactor?.deleteItem(request: Medias.DeleteMedia.Request(item: item))
    }
    
    func deleteMedia(viewModel: Medias.DeleteMedia.ViewModel) {
        collectionView.reloadData()
    }
    
    func updateMedia(viewModel: Medias.UpdateMedia.ViewModel) {
        collectionView.performBatchUpdates {
            if let indexPath = viewModel.updatedIndexPath {
                collectionView.reloadItems(at: [indexPath])
            }
        } completion: { finished in
            if finished {
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            }
        }
    }
}

extension MediasViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.displayedMedias.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withCellType: MediaCell.self, forIndexPath: indexPath)
        let item = viewModel?.displayedMedias[indexPath.item]
        if let item = item {
            cell.configure(item: item)
        }
        return cell
    }
    
}

extension MediasViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update the data store first
        interactor?.selectedItem(with: indexPath)
        // After then navigate
        router?.routeToMediaDetail()
    }
    
}

extension MediasViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchMedias(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            return
        }
        self.searchBar.resignFirstResponder()
        fetchMedias(query: query)
    }
}
