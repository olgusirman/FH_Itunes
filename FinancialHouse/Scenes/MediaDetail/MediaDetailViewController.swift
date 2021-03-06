//
//  MediaDetailViewController.swift
//  FinancialHouse
//
//  Created by Olgu on 18.10.2020.
//

import UIKit

protocol MediaDetailDisplayLogic: AnyObject {
    func displayMedia(viewModel: MediaDetail.ShowMedia.ViewModel)
}

final class MediaDetailViewController: BaseViewController, MediaDetailDisplayLogic {
    
    // MARK: - IBOutlet
    
    @IBOutlet fileprivate weak var mediaImageView: MediaArtworkImageView!
    @IBOutlet fileprivate weak var mediaTitle: UILabel!
    
    var interactor: MediaDetailBusinessLogic?
    var router: (NSObjectProtocol & MediaDetailRoutingLogic & MediaDetailDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MediaDetailInteractor()
        let presenter = MediaDetailPresenter()
        let router = MediaDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePassedDataItemWorker()
        configureNavigationBarItem()
        configureMediaTitle()
    }
    
    private func configurePassedDataItemWorker() {
        let request = MediaDetail.ShowMedia.Request()
        interactor?.getItem(request: request)
    }
    
    // MARK: MediaDetailDisplayLogic
    
    func displayMedia(viewModel: MediaDetail.ShowMedia.ViewModel) {
        self.navigationItem.title = viewModel.displayedMedia.mediaName
        mediaTitle.text = viewModel.displayedMedia.mediaName
        mediaImageView.setImage(urlString: viewModel.displayedMedia.mediaArtworkUrl)
    }
    
    // MARK: - Configure
    private func configureNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(selectDeleteBarButtonPressed))
    }
    
    private func configureMediaTitle() {
        if #available(iOS 11.0, *) {
            mediaTitle.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        }
    }
    
    // MARK: - Actions
    @objc
    func selectDeleteBarButtonPressed() {
        
        let controller = interactor?.presentDeleteItemPopUp { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        if let controller = controller {
            present(controller, animated: true)
        }
    }
    
    override func networkConnectionIsChanged(isOffline: Bool) {
        super.networkConnectionIsChanged(isOffline: isOffline)
        
        navigationItem.rightBarButtonItem?.isEnabled = !isOffline
    }
    
}
