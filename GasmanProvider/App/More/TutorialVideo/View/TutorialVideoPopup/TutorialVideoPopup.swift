//
//  TutorialVideoPopup.swift
//  GasmanProvider
//

import UIKit
import AVKit

class TutorialVideoPopup: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var closeButton: UIButton!

    // MARK: - Properties -

    var onClose: (() -> Void)?
    private var playerVC: AVPlayerViewController?
    private let videoURL: URL
    private let title_: String

    // MARK: - Initializer -

    init(videoURL: URL, title: String) {
        self.videoURL = videoURL
        self.title_ = title
        super.init(nibName: "TutorialVideoPopup", bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupVideo()
    }

    // MARK: - Setup -

    private func configView() {
        view.backgroundColor = .clear
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        titleLabel.text = title_
    }

    private func setupVideo() {
        videoContainerView.layer.cornerRadius = 12
        videoContainerView.clipsToBounds = true

        let playerVC = AVPlayerViewController()
        playerVC.showsPlaybackControls = true
        addChild(playerVC)
        playerVC.view.frame = videoContainerView.bounds
        playerVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoContainerView.addSubview(playerVC.view)
        playerVC.didMove(toParent: self)
        playerVC.player = AVPlayer(url: videoURL)
        self.playerVC = playerVC
    }

    // MARK: - Appearance -

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { [weak self] in
            self?.show()
        }
    }

    private func show() {
        UIView.animate(withDuration: 0.3, delay: 0.1) { [weak self] in
            self?.backView.alpha = 1
            self?.contentView.alpha = 1
        } completion: { [weak self] _ in
            self?.playerVC?.player?.play()
        }
    }

    private func hide() {
        playerVC?.player?.pause()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.backView.alpha = 0
            self?.contentView.alpha = 0
        } completion: { [weak self] _ in
            guard let self else { return }
            dismiss(animated: false) { [weak self] in
                self?.onClose?()
            }
        }
    }

    // MARK: - Actions -

    @IBAction func didTapClose(_ sender: UIButton) {
        hide()
    }

    @IBAction func didTapBackground(_ sender: UITapGestureRecognizer) {
        hide()
    }
}
