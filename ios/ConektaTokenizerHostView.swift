import UIKit
import React
import composeKit

class ConektaTokenizerHostView: UIView {
    @objc var publicKey: String = "" { didSet { update() } }
    @objc var merchantName: String = "Demo Store" { didSet { update() } }
    @objc var onSuccess: RCTBubblingEventBlock?
    @objc var onError: RCTBubblingEventBlock?

    private var hostedVC: UIViewController?

    private func update() {
        guard !publicKey.isEmpty else { return }

        hostedVC?.view.removeFromSuperview()
        hostedVC?.removeFromParent()

        let config = TokenizerConfig(
            publicKey: publicKey,
            merchantName: merchantName,
            collectCardholderName: true
        )

        let vc = ConektaTokenizerViewControllerKt.ConektaTokenizerViewController(
            config: config,
            onSuccess: { [weak self] (result: TokenizerResult) in
                self?.onSuccess?(["token": result.token, "lastFour": result.lastFour])
            },
            onError: { [weak self] (error: TokenizerError) in
                var map: [String: Any] = [:]
                if let e = error as? TokenizerError.TokenizerValidationError {
                    map = ["type": "ValidationError", "message": e.message ?? ""]
                } else if let e = error as? TokenizerError.TokenizerNetworkError {
                    map = ["type": "NetworkError", "message": e.message ?? ""]
                } else if let e = error as? TokenizerError.TokenizerApiError {
                    map = ["type": "ApiError", "code": e.code, "message": e.message ?? ""]
                }
                self?.onError?(map)
            }
        )

        if let parentVC = findParentViewController() {
            parentVC.addChild(vc)
            vc.view.frame = bounds
            vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(vc.view)
            vc.didMove(toParent: parentVC)
            hostedVC = vc
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hostedVC?.view.frame = bounds
    }
}

private extension UIView {
    func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController { return vc }
            responder = r.next
        }
        return nil
    }
}
