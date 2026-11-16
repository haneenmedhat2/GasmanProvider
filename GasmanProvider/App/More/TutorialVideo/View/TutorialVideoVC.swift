//
//  TutorialVideoVC.swift
//  GasmanProvider
//

import UIKit
import Combine
import AVKit

class TutorialVideoVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoContainerView: UIView!

    // MARK: - Properties -

    var viewModel: TutorialVideoVM
    private var playerVC: AVPlayerViewController?

    // MARK: - Initializer -

    init(viewModel: TutorialVideoVM) {
        self.viewModel = viewModel
        super.init(nibName: "TutorialVideoVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        self.title = "intro_video".localized
        setupVideoContainer()
        bindViewModel()
        viewModel.fetchTutorialVideo()
    }

    private func setupVideoContainer() {
        videoContainerView.layer.cornerRadius = 12
        videoContainerView.clipsToBounds = true

        let playerVC = AVPlayerViewController()
        playerVC.showsPlaybackControls = true
        addChild(playerVC)
        playerVC.view.frame = videoContainerView.bounds
        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoContainerView.addSubview(playerVC.view)
        playerVC.didMove(toParent: self)
        self.playerVC = playerVC
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$tutorialVideo
            .compactMap { $0 }
            .sinkOnMain { [weak self] data in
                guard let self else { return }
                titleLabel.text = data.title
                if let urlString = data.tutorialVideo,
                   let url = URL(string: urlString) {
                    playerVC?.player = AVPlayer(url: url)
                }
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
}
