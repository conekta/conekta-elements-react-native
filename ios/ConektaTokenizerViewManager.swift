import React

@objc(ConektaTokenizerView)
class ConektaTokenizerViewManager: RCTViewManager {

    override func view() -> UIView! {
        return ConektaTokenizerHostView()
    }

    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
