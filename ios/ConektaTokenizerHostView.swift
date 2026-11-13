import UIKit
import React
import composeKit

class ConektaTokenizerHostView: UIView {
    @objc var publicKey: String = "" { didSet { updateIfReady() } }
    @objc var merchantName: String = "Demo Store" { didSet { updateIfReady() } }
    /// The form's language (`es`, `en`); `nil` follows the device's.
    @objc var locale: String? { didSet { updateIfReady() } }
    /// The card networks the form refuses (`amex`, `visa_master_card`).
    @objc var excludeCardNetworks: [String]? { didSet { updateIfReady() } }
    @objc var onSuccess: RCTBubblingEventBlock?
    @objc var onError: RCTBubblingEventBlock?

    private var hostedVC: UIViewController?
    private var needsUpdate = false

    private func updateIfReady() {
        if findParentViewController() != nil {
            update()
        } else {
            needsUpdate = true
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil && needsUpdate {
            needsUpdate = false
            update()
        }
    }

    private func update() {
        hostedVC?.view.removeFromSuperview()
        hostedVC?.removeFromParent()

        let vc = ConektaTokenizerViewControllerKt.ConektaTokenizerViewController(
            config: makeConfig(),
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

    private func makeConfig() -> TokenizerConfig {
        let networks = (excludeCardNetworks ?? []).map { CardNetwork.companion.fromSerialName(value: $0) }
        let config = TokenizerConfig(
            publicKey: publicKey,
            merchantName: merchantName,
            collectCardholderName: true
        ).withExcludedCardNetworks(networks: networks)
        guard let locale else { return config }
        return config.withLocale(locale: ComponentsLocale.companion.of(tag: locale))
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
