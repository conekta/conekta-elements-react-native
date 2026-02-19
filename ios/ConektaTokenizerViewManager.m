#import <React/RCTViewManager.h>

RCT_EXPORT_MODULE(ConektaTokenizerView)

RCT_EXPORT_VIEW_PROPERTY(publicKey,    NSString)
RCT_EXPORT_VIEW_PROPERTY(merchantName, NSString)
RCT_EXPORT_VIEW_PROPERTY(onSuccess,    RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError,      RCTBubblingEventBlock)
