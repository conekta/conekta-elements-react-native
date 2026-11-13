#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(ConektaTokenizerView, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(publicKey,    NSString)
RCT_EXPORT_VIEW_PROPERTY(merchantName, NSString)
RCT_EXPORT_VIEW_PROPERTY(locale,       NSString)
RCT_EXPORT_VIEW_PROPERTY(excludeCardNetworks, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onSuccess,    RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onError,      RCTBubblingEventBlock)

@end
