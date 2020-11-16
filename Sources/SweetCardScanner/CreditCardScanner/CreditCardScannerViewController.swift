//  Created by josh on 2020/07/23.

import AVFoundation
import UIKit

public protocol CreditCardScannerViewControllerDelegate: AnyObject {
    /// Called user taps the cancel button. Comes with a default implementation for UIViewControllers.
    /// - Warning: The viewController does not auto-dismiss. You must dismiss the viewController
    func creditCardScannerViewControllerDidCancel(_ viewController: CreditCardScannerViewController)
    /// Called when an error is encountered
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didErrorWith error: CreditCardScannerError)
    /// Called when finished successfully
    /// - Note: successful finish does not guarentee that all credit card info can be extracted
    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didFinishWith card: CreditCard)
}

public extension CreditCardScannerViewControllerDelegate where Self: UIViewController {
    func creditCardScannerViewControllerDidCancel(_ viewController: CreditCardScannerViewController) {
        viewController.dismiss(animated: true)
    }
}

open class CreditCardScannerViewController: UIViewController {
    /// public propaties
    
    // MARK: - Subviews and layers
    
    /// View representing live camera
    private lazy var cameraView: CameraView = CameraView(delegate: self)
    
    /// Analyzes text data for credit card info
    private lazy var analyzer = ImageAnalyzer(delegate: self)
    
    private weak var delegate: CreditCardScannerViewControllerDelegate?
    
    // MARK: - Vision-related
    
    public init(delegate: CreditCardScannerViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.analyzer = ImageAnalyzer(delegate: self)
        layoutSubviews()
        AVCaptureDevice.authorize { [weak self] authoriazed in
            // This is on the main thread.
            guard let strongSelf = self else {
                return
            }
            guard authoriazed else {
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: CreditCardScannerError(kind: .authorizationDenied, underlyingError: nil))
                return
            }
            strongSelf.cameraView.setupCamera()
        }
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.setupRegionOfInterest()
    }
}

private extension CreditCardScannerViewController {
    @objc func cancel(_ sender: UIButton) {
        delegate?.creditCardScannerViewControllerDidCancel(self)
    }
    
    func layoutSubviews() {
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        cameraView.frame = view.frame
    }
    
}

extension CreditCardScannerViewController: CameraViewDelegate {
    internal func didCapture(image: CGImage) {
        analyzer.analyze(image: image)
    }
    
    internal func didError(with error: CreditCardScannerError) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            strongSelf.cameraView.stopSession()
        }
    }
}

extension CreditCardScannerViewController: ImageAnalyzerProtocol {
    internal func didFinishAnalyzation(with result: Result<CreditCard, CreditCardScannerError>) {
        switch result {
        case let .success(creditCard):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didFinishWith: creditCard)
            }
            
        case let .failure(error):
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.cameraView.stopSession()
                strongSelf.delegate?.creditCardScannerViewController(strongSelf, didErrorWith: error)
            }
        }
    }
}

extension AVCaptureDevice {
    static func authorize(authorizedHandler: @escaping ((Bool) -> Void)) {
        let mainThreadHandler: ((Bool) -> Void) = { isAuthorized in
            DispatchQueue.main.async {
                authorizedHandler(isAuthorized)
            }
        }
        
        switch authorizationStatus(for: .video) {
        case .authorized:
            mainThreadHandler(true)
        case .notDetermined:
            requestAccess(for: .video, completionHandler: { granted in
                mainThreadHandler(granted)
            })
        default:
            mainThreadHandler(false)
        }
    }
}
