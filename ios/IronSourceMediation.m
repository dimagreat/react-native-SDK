#import "IronSourceMediation.h"
#import <IronSource/IronSource.h>
#import "Constants.h"
#import "RCTLevelPlayRVDelegateWrapper.h"
#import "RCTLevelPlayISDelegateWrapper.h"
#import "RCTLevelPlayBNDelegateWrapper.h"

/// Constants
#pragma mark - Ad Units
static NSString *const REWARDED_VIDEO = @"REWARDED_VIDEO";
static NSString *const INTERSTITIAL = @"INTERSTITIAL";
static NSString *const OFFERWALL = @"OFFERWALL";
static NSString *const BANNER = @"BANNER";
#pragma mark - RV Event Name Constants
static NSString *const ON_RV_AD_OPENED = @"onRewardedVideoAdOpened";
static NSString *const ON_RV_AD_CLOSED = @"onRewardedVideoAdClosed";
static NSString *const ON_RV_AVAILABILITY_CHANGED = @"onRewardedVideoAvailabilityChanged";
static NSString *const ON_RV_AD_REWARDED = @"onRewardedVideoAdRewarded";
static NSString *const ON_RV_AD_SHOW_FAILED = @"onRewardedVideoAdShowFailed";
static NSString *const ON_RV_AD_CLICKED = @"onRewardedVideoAdClicked";
static NSString *const ON_RV_AD_STARTED = @"onRewardedVideoAdStarted";
static NSString *const ON_RV_AD_ENDED = @"onRewardedVideoAdEnded";
#pragma mark - Manual Load RV Event Name Constants
static NSString *const ON_RV_AD_READY = @"onRewardedVideoAdReady";
static NSString *const ON_RV_AD_LOAD_FAILED = @"onRewardedVideoAdLoadFailed";
#pragma mark - IS Event Name Constants
static NSString *const ON_IS_AD_READY = @"onInterstitialAdReady";
static NSString *const ON_IS_AD_LOAD_FAILED = @"onInterstitialAdLoadFailed";
static NSString *const ON_IS_AD_OPENED = @"onInterstitialAdOpened";
static NSString *const ON_IS_AD_CLOSED = @"onInterstitialAdClosed";
static NSString *const ON_IS_AD_SHOW_SUCCEEDED = @"onInterstitialAdShowSucceeded";
static NSString *const ON_IS_AD_SHOW_FAILED = @"onInterstitialAdShowFailed";
static NSString *const ON_IS_AD_CLICKED = @"onInterstitialAdClicked";
#pragma mark - BN Event Name Constants
static NSString *const ON_BN_AD_LOADED = @"onBannerAdLoaded";
static NSString *const ON_BN_AD_LOAD_FAILED = @"onBannerAdLoadFailed";
static NSString *const ON_BN_AD_CLICKED = @"onBannerAdClicked";
static NSString *const ON_BN_AD_SCREEN_PRESENTED = @"onBannerAdScreenPresented";
static NSString *const ON_BN_AD_SCREEN_DISMISSED = @"onBannerAdScreenDismissed";
static NSString *const ON_BN_AD_LEFT_APPLICATION = @"onBannerAdLeftApplication";
#pragma mark - OW Event Name Constants
static NSString *const ON_OW_AVAILABILITY_CHANGED = @"onOfferwallAvailabilityChanged";
static NSString *const ON_OW_OPENED = @"onOfferwallOpened";
static NSString *const ON_OW_SHOW_FAILED = @"onOfferwallShowFailed";
static NSString *const ON_OW_AD_CREDITED = @"onOfferwallAdCredited";
static NSString *const ON_OW_CREDITS_FAILED = @"onGetOfferwallCreditsFailed";
static NSString *const ON_OW_CLOSED = @"onOfferwallClosed";
#pragma mark - ARM ImpressionDataDelegate Constant
static NSString *const ON_IMPRESSION_SUCCESS = @"onImpressionSuccess";
#pragma mark - ISConsentViewDelegate Constants
static NSString *const CONSENT_VIEW_DID_LOAD_SUCCESS = @"consentViewDidLoadSuccess";
static NSString *const CONSENT_VIEW_DID_FAIL_TO_LOAD = @"consentViewDidFailToLoad";
static NSString *const CONSENT_VIEW_DID_SHOW_SUCCESS = @"consentViewDidShowSuccess";
static NSString *const CONSENT_VIEW_DID_FAIL_TO_SHOW = @"consentViewDidFailToShow";
static NSString *const CONSENT_VIEW_DID_ACCEPT = @"consentViewDidAccept";
#pragma mark - ISInitializationDelegate Constant
static NSString *const ON_INITIALIZATION_COMPLETE = @"initializationDidComplete";
#pragma mark - LevelPlayListener Constants
#pragma mark - LevelPlay RV
static NSString *const LP_RV_ON_AD_AVAILABLE   = @"LevelPlay:RV:onAdAvailable";
static NSString *const LP_RV_ON_AD_UNAVAILABLE = @"LevelPlay:RV:onAdUnavailable";
static NSString *const LP_RV_ON_AD_OPENED      = @"LevelPlay:RV:onAdOpened";
static NSString *const LP_RV_ON_AD_CLOSED      = @"LevelPlay:RV:onAdClosed";
static NSString *const LP_RV_ON_AD_REWARDED    = @"LevelPlay:RV:onAdRewarded";
static NSString *const LP_RV_ON_AD_SHOW_FAILED = @"LevelPlay:RV:onAdShowFailed";
static NSString *const LP_RV_ON_AD_CLICKED     = @"LevelPlay:RV:onAdClicked";
#pragma mark - LevelPlay Manual RV
static NSString *const LP_MANUAL_RV_ON_AD_READY       = @"LevelPlay:ManualRV:onAdReady";
static NSString *const LP_MANUAL_RV_ON_AD_LOAD_FAILED = @"LevelPlay:ManualRV:onAdLoadFailed";
#pragma mark - LevelPlay IS
static NSString *const LP_IS_ON_AD_READY          = @"LevelPlay:IS:onAdReady";
static NSString *const LP_IS_ON_AD_LOAD_FAILED    = @"LevelPlay:IS:onAdLoadFailed";
static NSString *const LP_IS_ON_AD_OPENED         = @"LevelPlay:IS:onAdOpened";
static NSString *const LP_IS_ON_AD_CLOSED         = @"LevelPlay:IS:onAdClosed";
static NSString *const LP_IS_ON_AD_SHOW_FAILED    = @"LevelPlay:IS:onAdShowFailed";
static NSString *const LP_IS_ON_AD_CLICKED        = @"LevelPlay:IS:onAdClicked";
static NSString *const LP_IS_ON_AD_SHOW_SUCCEEDED = @"LevelPlay:IS:onAdShowSucceeded";
#pragma mark - LevelPlay BN
static NSString *const LP_BN_ON_AD_LOADED           = @"LevelPlay:BN:onAdLoaded";
static NSString *const LP_BN_ON_AD_LOAD_FAILED      = @"LevelPlay:BN:onAdLoadFailed";
static NSString *const LP_BN_ON_AD_CLICKED          = @"LevelPlay:BN:onAdClicked";
static NSString *const LP_BN_ON_AD_SCREEN_PRESENTED = @"LevelPlay:BN:onAdScreenPresented";
static NSString *const LP_BN_ON_AD_SCREEN_DISMISSED = @"LevelPlay:BN:onAdScreenDismissed";
static NSString *const LP_BN_ON_AD_LEFT_APPLICATION = @"LevelPlay:BN:onAdLeftApplication";



@interface IronSourceMediation() <
    ISRewardedVideoDelegate,
    ISInterstitialDelegate,
    ISOfferwallDelegate,
    ISBannerDelegate,
    ISImpressionDataDelegate,
    ISConsentViewDelegate,
    ISRewardedVideoManualDelegate,
    ISInitializationDelegate,
    RCTLevelPlayRVDelegate,
    RCTLevelPlayISDelegate,
    RCTLevelPlayBNDelegate
>
@property (nonatomic) BOOL hasEventListeners;
@property (nonatomic,weak) ISBannerView* bannerView;
@property (nonatomic,strong) NSNumber* bannerVerticalOffset;
@property (nonatomic,strong) NSString* bannerPosition;
@property (nonatomic,strong) UIViewController* bannerViewController;
@property (nonatomic) BOOL shouldHideBanner;

// LevelPlay Delegates
@property (nonatomic, strong) RCTLevelPlayRVDelegateWrapper *rvLevelPlayDelegateWrapper;
@property (nonatomic, strong) RCTLevelPlayISDelegateWrapper *istLevelPlayDelegateWrapper;
@property (nonatomic, strong) RCTLevelPlayBNDelegateWrapper *bnLevelPlayDelegateWrapper;
@end

@implementation IronSourceMediation

/**
 Suppress warning below:
   "Module IronSourceMediation requires main queue setup since it overrides `constantsToExport` but doesn't implement `requiresMainQueueSetup`.
   In a future release React Native will default to initializing all native modules on a background thread unless explicitly opted-out of."
*/
+ (BOOL)requiresMainQueueSetup
{
    return YES;
}


RCT_EXPORT_MODULE()

- (id)init {
    if (self = [super init]) {
        self.rvLevelPlayDelegateWrapper = [[RCTLevelPlayRVDelegateWrapper alloc]initWithDelegate:(id)self];
        self.istLevelPlayDelegateWrapper = [[RCTLevelPlayISDelegateWrapper alloc]initWithDelegate:(id)self];
        self.bnLevelPlayDelegateWrapper = [[RCTLevelPlayBNDelegateWrapper alloc]initWithDelegate:(id)self];
        
        // set ironSource Listeners
        [IronSource setRewardedVideoDelegate:self];
        [IronSource setInterstitialDelegate:self];
        [IronSource setBannerDelegate:self];
        [IronSource setOfferwallDelegate:self];
        [IronSource addImpressionDataDelegate:self];
        [IronSource setConsentViewWithDelegate:self];
        
        //set level play listeneres
        [IronSource setLevelPlayRewardedVideoDelegate:self.rvLevelPlayDelegateWrapper];
        [IronSource setLevelPlayInterstitialDelegate:self.istLevelPlayDelegateWrapper];
        [IronSource setLevelPlayBannerDelegate:self.bnLevelPlayDelegateWrapper];
        
        // observe device orientation changes
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeOrientation:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        self.shouldHideBanner = NO;
    }
    return self;
}

#pragma mark - Base API =========================================================================

/**
 @name getAdvertiserId
 @return IDFA in NSString | nil
 */
RCT_EXPORT_METHOD(getAdvertiserId:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    NSString *advertiserId = [IronSource advertiserId];
    return resolve(advertiserId);
}

/**
 @name validateIntegration
 @return nil
 */
RCT_EXPORT_METHOD(validateIntegration:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [ISIntegrationHelper validateIntegration];
    return resolve(nil);
}

/**
 @name shouldTrackNetworkState
 @param isEnabled
 @return nil
 */
RCT_EXPORT_METHOD(shouldTrackNetworkState:(BOOL) isEnabled
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)  {
    [IronSource shouldTrackReachability:isEnabled];
    return resolve(nil);
}

/**
 @name setDynamicUserId
 @param userId
 @return nil
 */
RCT_EXPORT_METHOD(setDynamicUserId:(nonnull NSString *) userId
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource setDynamicUserId:userId];
    return resolve(nil);
}

/**
 @name setAdaptersDebug
 @param isEnabled
 @return nil
 */
RCT_EXPORT_METHOD(setAdaptersDebug:(BOOL) isEnabled
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)  {
    [IronSource setAdaptersDebug:isEnabled];
    return resolve(nil);
}

/**
 @name setConsent
 @param isConsent
 @return nil
 */
RCT_EXPORT_METHOD(setConsent:(BOOL) isConsent
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)  {
    [IronSource setConsent:isConsent];
    return resolve(nil);
}

/**
 @name setSegment
 @param segmentDict NSDictionary
    segmentName? : NSString
    gender? : NSString ("female" | "male")
    age? : NSNumber
    level? : NSNumber
    isPaying? : BOOL in NSNumber
    userCreationDateInMillis? : NSNumber
    iapTotal?: NSNumber
    customParameters? : NSDictionary<NSString, NSString>
 @return nil
 */
RCT_EXPORT_METHOD(setSegment:(nonnull NSDictionary *) segmentDict
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    ISSegment *segment = [[ISSegment alloc] init];
    NSMutableArray<NSString*> *allKeys = [[segmentDict allKeys] mutableCopy];
    
    for (NSString *key in allKeys)
    {
        if ([key isEqualToString:@"segmentName"]){
            NSString *segmentName = [segmentDict objectForKey:key];
            if(segmentName != nil && ![[NSNull null] isEqual:segmentName]){
                segment.segmentName = segmentName;
            }
        } else if ([key isEqualToString:@"age"]){
            NSNumber *age = [segmentDict objectForKey:key];
            if(age != nil && ![[NSNull null] isEqual:age]){
                segment.age = [age intValue];
            }
        } else if([key isEqualToString:@"gender"]){
            NSString *gender = [segmentDict objectForKey:key];
            if(gender != nil && ![[NSNull null] isEqual:gender]){
                if([gender isEqualToString:@"male"]){
                    segment.gender = IRONSOURCE_USER_MALE;
                } else if([gender isEqualToString:@"female"]){
                    segment.gender = IRONSOURCE_USER_FEMALE;
                }
            }
        } else if ([key isEqualToString:@"level"]){
            NSNumber *level = [segmentDict objectForKey:key];
            if(level != nil && ![[NSNull null] isEqual:level]){
                segment.level = [level intValue];
            }
        } else if ([key isEqualToString:@"isPaying"]){
            NSNumber *isPayingNum = [segmentDict objectForKey:key];
            if(isPayingNum != nil && ![[NSNull null] isEqual:isPayingNum]){
                segment.paying = [isPayingNum boolValue];
            }
        } else if ([key isEqualToString:@"userCreationDateInMillis"]){
            NSNumber *ucd = [segmentDict objectForKey:key];
            if(ucd != nil && ![[NSNull null] isEqual:ucd]){
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [ucd doubleValue]/1000];
                segment.userCreationDate = date;
            }
        }  else if ([key isEqualToString:@"iapTotal"]){
            NSNumber *iapTotalNum = [segmentDict objectForKey:key];
            if(iapTotalNum != nil && ![[NSNull null] isEqual:iapTotalNum]){
                segment.iapTotal = [iapTotalNum doubleValue];
            }
        } else if ([key isEqualToString:@"customParameters"]){
            NSDictionary *customParams = [segmentDict objectForKey:key];
            if(customParams != nil && ![[NSNull null] isEqual:customParams]){
                // set custom values
                NSMutableArray<NSString*> *customKeys = [[customParams allKeys] mutableCopy];
                for (NSString *customKey in customKeys) {
                    NSString *customValue = [customParams objectForKey:customKey];
                    if(customValue != nil && ![[NSNull null] isEqual:customValue]){
                        [segment setCustomValue:customValue forKey:customKey];
                    }
                }
            }
        } else {
            return reject(E_ILLEGAL_ARGUMENT, [NSString stringWithFormat: @"Invalid parameter. param: %@", key], nil);
        }
    }
    
    [IronSource setSegment:segment];
    return resolve(nil);
}

/**
 @name setMetaData
 @param key cannot be an empty string
 @param values NSArray<NSString>
 @return nil
 */
RCT_EXPORT_METHOD(setMetaData:(nonnull NSString *) key
                  withValues: (nonnull NSArray<NSString*> *) values
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)  {
    [IronSource setMetaDataWithKey:key values:[values mutableCopy]];
    return resolve(nil);
}

#pragma mark - Init API =========================================================================

/**
 @name setUserId
 @param userId
 @return nil
 
 The SDK falls back to the default if userId is an empty string.
 */
RCT_EXPORT_METHOD(setUserId:(nonnull NSString *) userId
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource setUserId:userId];
    return resolve(nil);
}

/**
 @name init
 @param appKey
 @return nil
 */
RCT_EXPORT_METHOD(init:(nonnull NSString *) appKey
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    if([appKey length] == 0){
        return reject(E_ILLEGAL_ARGUMENT, @"appKey must be provided.", nil);
    }
    
    [IronSource initWithAppKey:appKey delegate:self];
    return resolve(nil);
}

/**
 @name initWithAdUnits
 @param appKey cannot be an empty string
 @param adUnits Array<"REWARDED_VIDEO" | "INTERSTITIAL" | "OFFERWALL" | "BANNER">
 @return nil
 */
RCT_EXPORT_METHOD(initWithAdUnits:(nonnull NSString *) appKey
                  adUnits:(nonnull NSArray<NSString*> *) adUnits
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    if([appKey length] == 0){
        return reject(E_ILLEGAL_ARGUMENT, @"appKey must be provided.", nil);
    }
    
    if(adUnits.count){
        NSMutableArray<NSString*> *parsedAdUnits = [[NSMutableArray alloc]init];
        for(NSString *unit in adUnits){
            if([unit isEqualToString:REWARDED_VIDEO]){
                [parsedAdUnits addObject:IS_REWARDED_VIDEO];
            } else if ([unit isEqualToString:INTERSTITIAL]){
                [parsedAdUnits addObject:IS_INTERSTITIAL];
            } else if ([unit isEqualToString:OFFERWALL]){
                [parsedAdUnits addObject:IS_OFFERWALL];
            } else if ([unit isEqualToString:BANNER]){
                [parsedAdUnits addObject:IS_BANNER];
            } else {
                return reject(E_ILLEGAL_ARGUMENT, [NSString stringWithFormat: @"Unsupported ad unit: %@", unit], nil);
            }
        }
    
        [IronSource initWithAppKey:appKey adUnits:parsedAdUnits delegate:self];
    } else {
        [IronSource initWithAppKey:appKey delegate:self];
    }
    return resolve(nil);
}

#pragma mark - RV API ============================================================================

/**
 @name showRewardedVideo
 @return nil
 */
RCT_EXPORT_METHOD(showRewardedVideo:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showRewardedVideoWithViewController:[self getRootViewController]];
        return resolve(nil);
    });
}

/**
 @name showRewardedVideoForPlacement
 @param placementName
 @return nil
 */
RCT_EXPORT_METHOD(showRewardedVideoForPlacement:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showRewardedVideoWithViewController:[self getRootViewController]
                                              placement:placementName];
         return resolve(nil);
     });
}

/**
 @name isRewardedVideoAvailable
 @return boolean in NSNumber
 */
RCT_EXPORT_METHOD(isRewardedVideoAvailable:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isRVAvailable = [IronSource hasRewardedVideo];
    return resolve([NSNumber numberWithBool:isRVAvailable]);
}

/**
 @name isRewardedVideoPlacementCapped
 @param placementName
 @return boolean in NSNumber
 */
RCT_EXPORT_METHOD(isRewardedVideoPlacementCapped:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isCapped = [IronSource isRewardedVideoCappedForPlacement:placementName];
    return resolve([NSNumber numberWithBool:isCapped]);
}

/**
 @name getRewardedVideoPlacementInfo
 @param placementName
 @return ISPlacementInfo in NSDictionary | nil
 
 Returns nil if this is called before init.
 */
RCT_EXPORT_METHOD(getRewardedVideoPlacementInfo:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    ISPlacementInfo *placementInfo = [IronSource rewardedVideoPlacementInfo:placementName];
    return resolve(placementInfo != nil ? [self getDictWithPlacementInfo:placementInfo] : nil);
}

/**
 @name setRewardedVideoServerParams
 @param params in NSDictionary with String values only
 @return nil
 */
RCT_EXPORT_METHOD(setRewardedVideoServerParams:(nonnull NSDictionary *) params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource setRewardedVideoServerParameters:params];
    return resolve(nil);
}

/**
 @name clearRewardedVideoServerParams
 @return nil
 */
RCT_EXPORT_METHOD(clearRewardedVideoServerParams:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource clearRewardedVideoServerParameters];
    return resolve(nil);
}

/**
 @name setManualLoadRewardedVideo
 @return nil
 */
RCT_EXPORT_METHOD(setManualLoadRewardedVideo:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource setRewardedVideoManualDelegate:self];
    return resolve(nil);
}

/**
 Manual Load RV
 @name loadRewardedVideo
 @return nil
 */
RCT_EXPORT_METHOD(loadRewardedVideo:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource loadRewardedVideo];
    return resolve(nil);
}

#pragma mark - IS API ============================================================================

/**
 @name loadInterstitial
 @return nil
 */
RCT_EXPORT_METHOD(loadInterstitial:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource loadInterstitial];
    return resolve(nil);
}

/**
 @name showInterstitial
 @return nil
 */
RCT_EXPORT_METHOD(showInterstitial:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showInterstitialWithViewController:[self getRootViewController]];
        return resolve(nil);
    });
}

/**
 @name showInterstitialForPlacement
 @param placementName
 @return nil
 */
RCT_EXPORT_METHOD(showInterstitialForPlacement:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showInterstitialWithViewController:[self getRootViewController] placement:placementName];
        return resolve(nil);
    });
}

/**
 @name isInterstitialReady
 @return boolean in NSNumber
 */
RCT_EXPORT_METHOD(isInterstitialReady:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isISReady = [IronSource hasInterstitial];
    return resolve([NSNumber numberWithBool:isISReady]);
}

/**
 @name isInterstitialPlacementCapped
 @param placementName
 @return boolean in NSNumber
 */
RCT_EXPORT_METHOD(isInterstitialPlacementCapped:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isCapped = [IronSource isInterstitialCappedForPlacement:placementName];
    return resolve([NSNumber numberWithBool:isCapped]);
}

#pragma mark - BN API ===========================================================================

RCT_EXPORT_METHOD(loadBanner:(nonnull NSDictionary *) options
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            // Required params
            NSString *position = [options valueForKey:@"position"];
            if(position == nil || [[NSNull null] isEqual:position]){
                return reject(E_ILLEGAL_ARGUMENT, @"position is missing", nil);
            }
            NSString *sizeDescription = [options valueForKey:@"sizeDescription"];
            BOOL hasSizeDescripton = sizeDescription != nil || ![[NSNull null] isEqual:sizeDescription];
            NSNumber *width = [options valueForKey:@"width"];
            NSNumber *height = [options valueForKey:@"height"];
            BOOL hasWidth = width != nil || ![[NSNull null] isEqual:width];
            BOOL hasHeight = height != nil || ![[NSNull null] isEqual:height];
            if(!hasSizeDescripton && !(hasWidth && hasHeight)) {
                return reject(E_ILLEGAL_ARGUMENT, @"Banner sizeDescription or width and height must be passed.", nil);
            }
            
            ISBannerSize* size = hasSizeDescripton ? [self getBannerSize:sizeDescription]
                : [[ISBannerSize alloc] initWithWidth:[width integerValue] andHeight:[height integerValue]];
            
            // Optional params
            NSNumber *verticalOffset = [options valueForKey:@"verticalOffset"];
            NSString *placementName = [options valueForKey:@"placementName"];
            NSNumber *isAdaptive =  [options valueForKey:@"isAdaptive"];
            size.adaptive = [isAdaptive boolValue];
            
            self.bannerVerticalOffset = (verticalOffset != nil || [[NSNull null] isEqual:verticalOffset]) ? verticalOffset : [NSNumber numberWithInt:0];
            self.bannerViewController = [self getRootViewController];
            self.bannerPosition = position;
            
            // Load banner view
            // if already loaded, console error would be shown by iS SDK
            if(placementName == nil || [[NSNull null] isEqual:placementName]){
                [IronSource loadBannerWithViewController:self.bannerViewController size:size];
            } else {
                [IronSource loadBannerWithViewController:self.bannerViewController size:size placement:placementName];
            }
            return resolve(nil);
        }
    });
}

/**
 @name destroyBanner
 @return nil
 */
RCT_EXPORT_METHOD(destroyBanner:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (self.bannerView != nil) {
                [IronSource destroyBanner:self.bannerView];
                self.bannerView = nil;
                self.bannerViewController = nil;
                self.bannerVerticalOffset = nil;
                self.shouldHideBanner = NO; // Reset the visibility
            }
            return resolve(nil);
        }
    });
}

/**
 @name displayBanner
 @return nil
 */
RCT_EXPORT_METHOD(displayBanner:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (self.bannerView != nil) {
                self.shouldHideBanner = NO;
                [self.bannerView setHidden:NO];
            }
            return resolve(nil);
        }
    });
}

/**
 @name hideBanner
 @return nil
 */
RCT_EXPORT_METHOD(hideBanner:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    self.shouldHideBanner = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (self.bannerView != nil) {
                [self.bannerView setHidden:YES];
            }
            return resolve(nil);
        }
    });
}

/**
 @name isBannerPlacementCapped
 @param placementName
 @return boolean in NSNumber
 */
RCT_EXPORT_METHOD(isBannerPlacementCapped:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject){
    BOOL isCapped = [IronSource isBannerCappedForPlacement:placementName];
    return resolve([NSNumber numberWithBool:isCapped]);
}

#pragma mark - BN Utils =======================================

/**
 Fallback to BANNER in the case of an illegal description
 @param description size description
 @return ISBannerSize
 */
- (ISBannerSize *)getBannerSize:(NSString *)description {
    if([description isEqualToString:@"SMART"]) {
        return ISBannerSize_SMART;
    } else if ([description isEqualToString:@"BANNER"]) {
        return ISBannerSize_BANNER;
    } else if ([description isEqualToString:@"RECTANGLE"]) {
        return ISBannerSize_RECTANGLE;
    } else if ([description isEqualToString:@"LARGE"]) {
        return ISBannerSize_LARGE;
    } else {
        return ISBannerSize_BANNER;
    }
}

/**
 Fallback to BOTTOM in the case of unsupported position string
 @param position "TOP" "CENTER" "BOTTOM"
 @param rootView viewController rootView
 @param bnView bannerView
 @param verticalOffset offset in point
 @return CGPoint
 */
- (CGPoint)getBannerCenterWithPosition:(NSString *)position
                              rootView:(UIView *)rootView
                            bannerView:(ISBannerView*) bnView
                          bannerOffset:(NSNumber*) verticalOffset {
    //Positions
    NSString * const BANNER_POSITION_TOP = @"TOP";
    NSString * const BANNER_POSITION_CENTER = @"CENTER";
//    const NSString *BANNER_POSITION_BOTTOM = @"BOTTOM";

    CGFloat y;
    if ([position isEqualToString:BANNER_POSITION_TOP]) {
        y = (bnView.frame.size.height / 2);
        // safe area
        if (@available(ios 11.0, *)) {
            y += rootView.safeAreaInsets.top;
        }
        // vertical offset
        if(verticalOffset.intValue > 0){
            y += verticalOffset.floatValue;
        }
    } else if ([position isEqualToString:BANNER_POSITION_CENTER]) {
        y = (rootView.frame.size.height / 2) - (bnView.frame.size.height / 2);
        // vertical offset
        y += verticalOffset.floatValue;
    } else { // BANNER_POSITION_BOTTOM
        y = rootView.frame.size.height - (bnView.frame.size.height / 2);
        // safe area
        if (@available(ios 11.0, *)) {
            y -= rootView.safeAreaInsets.bottom;
        }
        // vertical offset
        if(verticalOffset.intValue < 0){
            y += verticalOffset.floatValue;
        }
    }
    return CGPointMake(rootView.frame.size.width / 2, y);
}

/**
 For banner center recalibration on device orientation changes.
 Called by UIDeviceOrientationDidChangeNotification
 */
- (void)didChangeOrientation:(NSNotification*)notification {
    [self setBannerCenter];
}

/**
 For orientation changes
 */
- (void)setBannerCenter {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            self.bannerView.center = [self getBannerCenterWithPosition:self.bannerPosition
                                                              rootView:self.bannerViewController.view
                                                            bannerView:self.bannerView
                                                          bannerOffset:self.bannerVerticalOffset];
        }
    });
}

#pragma mark - OW API ================================================================================

/**
 @name showOfferwall
 @return nil
 */
RCT_EXPORT_METHOD(showOfferwall:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)  {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showOfferwallWithViewController: [self getRootViewController]];
        return resolve(nil);
    });
}

/**
 @name showOfferwallForPlacement
 @param placementName
 @return nil
 */
RCT_EXPORT_METHOD(showOfferwallForPlacement:(nonnull NSString *) placementName
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showOfferwallWithViewController: [self getRootViewController] placement:placementName];
        return resolve(nil);
    });
}

/**
 @name getOfferwallCredits
 @return nil
 */
RCT_EXPORT_METHOD(getOfferwallCredits:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)  {
    [IronSource offerwallCredits];
    return resolve(nil);
}

/**
 @name isOfferwallAvailable
 @return boolean in NSNumber
 */
RCT_EXPORT_METHOD(isOfferwallAvailable:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isAvailable = [IronSource hasOfferwall];
    return resolve([NSNumber numberWithBool:isAvailable]);
}

/**
 OW Config API
 This must be called before init.
 @name setClientSideCallbacks
 @param isEnabled BOOL
 @return nil
 */
RCT_EXPORT_METHOD(setClientSideCallbacks:(BOOL) isEnabled
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [[ISSupersonicAdsConfiguration configurations] setUseClientSideCallbacks: [NSNumber numberWithBool:isEnabled]];
    return resolve(nil);
}

/**
 This must be called before showOfferwall
 @name setOfferwallCustomParams
 @param params in NSDictionary with String values only
 @return nil
 */
RCT_EXPORT_METHOD(setOfferwallCustomParams:(nonnull NSDictionary *) params
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [[ISConfigurations getConfigurations] setOfferwallCustomParameters:params];
    return resolve(nil);
}

#pragma mark - ConversionValue API ==================================================================

/**
 @name getConversionValue
 @return NSNumber
 */
RCT_EXPORT_METHOD(getConversionValue:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    NSNumber *conversionValue = [IronSource getConversionValue];
    return resolve(conversionValue);
}

#pragma mark - ConsentView API ======================================================================

/**
 @name loadConsentViewWithType
 @param consentViewType cannot be an empty string
 @return nil
 */
RCT_EXPORT_METHOD(loadConsentViewWithType:(nonnull NSString *)consentViewType
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    [IronSource loadConsentViewWithType:consentViewType];
    return resolve(nil);
}

/**
 @name showConsentViewWithType
 @param consentViewType cannot be an empty string
 @return nil
 */
RCT_EXPORT_METHOD(showConsentViewWithType:(nonnull NSString *)consentViewType
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [IronSource showConsentViewWithViewController:[self getRootViewController]
                                              andType:consentViewType];
        return resolve(nil);
    });
}

#pragma mark - ISRewardedVideoDelegate Functions ==================================================

- (void)rewardedVideoHasChangedAvailability:(BOOL)isAvailable {
    NSDictionary *args = @{ @"isAvailable": [NSNumber numberWithBool:isAvailable] };
    [self sendEventWithEventName:ON_RV_AVAILABILITY_CHANGED withArgs:args];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    NSDictionary *args = [self getDictWithPlacementInfo:placementInfo];
    [self sendEventWithEventName:ON_RV_AD_REWARDED withArgs:args];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_RV_AD_SHOW_FAILED withArgs:args];
}

- (void)rewardedVideoDidOpen {
    [self sendEventWithEventName:ON_RV_AD_OPENED withArgs:nil];
}

- (void)rewardedVideoDidClose {
    [self sendEventWithEventName:ON_RV_AD_CLOSED withArgs:nil];
}

- (void)rewardedVideoDidStart {
    [self sendEventWithEventName:ON_RV_AD_STARTED withArgs:nil];
}

- (void)rewardedVideoDidEnd {
    [self sendEventWithEventName:ON_RV_AD_ENDED withArgs:nil];
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
    NSDictionary *args = [self getDictWithPlacementInfo:placementInfo];
    [self sendEventWithEventName:ON_RV_AD_CLICKED withArgs:args];
}

#pragma mark - ISRewardedVideoManualDelegate Functions ==================================================

- (void)rewardedVideoDidLoad {
    [self sendEventWithEventName:ON_RV_AD_READY withArgs:nil];
}

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_RV_AD_LOAD_FAILED withArgs:args];
}

#pragma mark - ISInterstitialDelegate Functions ==================================================

- (void)interstitialDidLoad {
    [self sendEventWithEventName:ON_IS_AD_READY withArgs:nil];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_IS_AD_LOAD_FAILED withArgs:args];
}

- (void)interstitialDidOpen{
    [self sendEventWithEventName:ON_IS_AD_OPENED withArgs:nil];
}

- (void)interstitialDidClose{
    [self sendEventWithEventName:ON_IS_AD_CLOSED withArgs:nil];
}

- (void)interstitialDidShow{
    [self sendEventWithEventName:ON_IS_AD_SHOW_SUCCEEDED withArgs:nil];
}

- (void)interstitialDidFailToShowWithError:(NSError *)error{
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_IS_AD_SHOW_FAILED withArgs:args];
}

- (void)didClickInterstitial{
    [self sendEventWithEventName:ON_IS_AD_CLICKED withArgs:nil];
}

# pragma mark - ISBannerDelegate Functions ===========================================================

- (void)bannerDidLoad:(ISBannerView *)bannerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            self.bannerView = bannerView;
            [self.bannerView setAccessibilityLabel:@"bannerContainer"];
            [self.bannerView setHidden:self.shouldHideBanner];
            self.bannerView.center = [self getBannerCenterWithPosition:self.bannerPosition
                                                              rootView:self.bannerViewController.view
                                                            bannerView:self.bannerView
                                                          bannerOffset:self.bannerVerticalOffset];
            [self.bannerViewController.view addSubview:self.bannerView];
            
            if (self.hasEventListeners) {
                [self sendEventWithName:ON_BN_AD_LOADED body:nil];
            }
        }
    });
}

- (void)bannerDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_BN_AD_LOAD_FAILED withArgs:args];
}

- (void)didClickBanner {
    [self sendEventWithEventName:ON_BN_AD_CLICKED withArgs:nil];
}

- (void)bannerWillPresentScreen {
    // Not called by every network
    [self sendEventWithEventName:ON_BN_AD_SCREEN_PRESENTED withArgs:nil];
}

- (void)bannerDidDismissScreen {
    // Not called by every network
    [self sendEventWithEventName:ON_BN_AD_SCREEN_DISMISSED withArgs:nil];
}

- (void)bannerWillLeaveApplication {
    [self sendEventWithEventName:ON_BN_AD_LEFT_APPLICATION withArgs:nil];
}

#pragma mark - ISOfferwallDelegate Functions ========================================================

- (void)offerwallHasChangedAvailability:(BOOL)available {
    NSDictionary *args = @{ @"isAvailable": [NSNumber numberWithBool:available] };
    [self sendEventWithEventName:ON_OW_AVAILABILITY_CHANGED withArgs:args];
}

- (void)offerwallDidShow {
    [self sendEventWithEventName:ON_OW_OPENED withArgs:nil];
}

- (void)offerwallDidFailToShowWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_OW_SHOW_FAILED withArgs:args];
}

- (BOOL)didReceiveOfferwallCredits:(NSDictionary *)creditInfo {
    // creditInfo should have matching keys: credits, totalCredits, totalCreditsFlag
    NSString *credits = [creditInfo valueForKey:@"credits"]; // implicit cast to NSString
    NSString *totalCredits = [creditInfo valueForKey:@"totalCredits"]; // implicit cast to NSString
    NSString *totalCreditsFlag = [creditInfo valueForKey:@"totalCreditsFlag"]; // implicit cast to NSString
    // creditInfo dictionary values are NSTaggedPointerString,
    //  so they must be cast before being passed
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(credits != nil){
        dict[@"credits"] = [NSNumber numberWithInt:credits.intValue];
    }
    if(totalCredits != nil){
        dict[@"totalCredits"] = [NSNumber numberWithInt:totalCredits.intValue];
    }
    if(totalCreditsFlag != nil){
        dict[@"totalCreditsFlag"] = [NSNumber numberWithBool:totalCreditsFlag.boolValue];
    }
    [self sendEventWithEventName:ON_OW_AD_CREDITED withArgs:dict];
    return YES;
}

- (void)didFailToReceiveOfferwallCreditsWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:ON_OW_CREDITS_FAILED withArgs:args];
}

- (void)offerwallDidClose {
    [self sendEventWithEventName:ON_OW_CLOSED withArgs:nil];
}

#pragma mark - ISImpressionDataDelegate Functions ===================================================

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    if(impressionData == nil){
        [self sendEventWithEventName:ON_IMPRESSION_SUCCESS withArgs:nil];
    } else {
        NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
        if(impressionData.auction_id != nil){
            args[@"auctionId"] = impressionData.auction_id;
        }
        if(impressionData.ad_unit != nil){
            args[@"adUnit"] = impressionData.ad_unit;
        }
        if(impressionData.country != nil){
            args[@"country"] = impressionData.country;
        }
        if(impressionData.ab != nil){
            args[@"ab"] = impressionData.ab;
        }
        if(impressionData.segment_name != nil){
            args[@"segmentName"] = impressionData.segment_name;
        }
        if(impressionData.placement != nil){
            args[@"placement"] = impressionData.placement;
        }
        if(impressionData.ad_network != nil){
            args[@"adNetwork"] = impressionData.ad_network;
        }
        if(impressionData.instance_name != nil){
            args[@"instanceName"] = impressionData.instance_name;
        }
        if(impressionData.ad_unit != nil){
            args[@"instanceId"] = impressionData.instance_id;
        }
        if(impressionData.revenue != nil){
            args[@"revenue"] = impressionData.revenue;
        }
        if(impressionData.precision != nil){
            args[@"precision"] = impressionData.precision;
        }
        if(impressionData.lifetime_revenue != nil){
            args[@"lifetimeRevenue"] = impressionData.lifetime_revenue;
        }
        if(impressionData.encrypted_cpm != nil){
            args[@"encryptedCPM"] = impressionData.encrypted_cpm;
        }
        [self sendEventWithEventName:ON_IMPRESSION_SUCCESS withArgs:args];
    }
}

#pragma mark - ISConsentViewDelegate Functions =======================================================
/**
 Pass arguments in the form of NSDictionary
 */

- (void)consentViewDidLoadSuccess:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType];
    [self sendEventWithEventName:@"consentViewDidLoadSuccess" withArgs:args];
}

- (void)consentViewDidFailToLoadWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:error];
    [self sendEventWithEventName:@"consentViewDidFailToLoad" withArgs:args];
}

- (void)consentViewDidShowSuccess:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType];
    [self sendEventWithEventName:@"consentViewDidShowSuccess" withArgs:args];
}

- (void)consentViewDidFailToShowWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:error];
    [self sendEventWithEventName:@"consentViewDidFailToShow" withArgs:args];
}

- (void)consentViewDidAccept:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType];
    [self sendEventWithEventName:@"consentViewDidAccept" withArgs:args];
}

- (void)consentViewDidDismiss:(NSString *)consentViewType {
    // Deprecated: Will never be called by the SDK.
}

# pragma mark - Initialization Delegate Functions ===================================================

- (void)initializationDidComplete {
    [self sendEventWithEventName:ON_INITIALIZATION_COMPLETE withArgs:nil];
}

#pragma mark - RCTLevelPlayRVDelegate Functions ==================================================

- (void)hasAvailableAdWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_RV_ON_AD_AVAILABLE withArgs:args];
}

- (void)hasNoAvailableAd {
    [self sendEventWithEventName:LP_RV_ON_AD_UNAVAILABLE withArgs:nil];
}

- (void)levelPlayRVDidReceiveRewardForPlacement:(nonnull ISPlacementInfo *)placementInfo withAdInfo:(nonnull ISAdInfo *)adInfo {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    NSDictionary *placmentDict = [self getDictWithPlacementInfo:placementInfo];
    NSDictionary *adInfoDict = [self getDictWithAdInfo:adInfo];
    args[@"placement"] = placmentDict;
    args[@"adInfo"] = adInfoDict;
    [self sendEventWithEventName:LP_RV_ON_AD_REWARDED withArgs:args];
}

- (void)levelPlayRVDidFailToShowWithError:(nonnull NSError *)error
                                andAdInfo:(nonnull ISAdInfo *)adInfo {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    NSDictionary *errorDict = [self getDictWithIronSourceError:error];
    NSDictionary *adInfoDict = [self getDictWithAdInfo:adInfo];
    args[@"error"] = errorDict;
    args[@"adInfo"] = adInfoDict;
    [self sendEventWithEventName:LP_RV_ON_AD_SHOW_FAILED withArgs:args];
}

- (void)levelPlayRVDidOpenWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_RV_ON_AD_OPENED withArgs:args];
}

- (void)levelPlayRVDidCloseWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_RV_ON_AD_CLOSED withArgs:args];
}

- (void)levelPlayRVDidClick:(nonnull ISPlacementInfo *)placementInfo withAdInfo:(nonnull ISAdInfo *)adInfo {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    NSDictionary *placmentDict = [self getDictWithPlacementInfo:placementInfo];
    NSDictionary *adInfoDict = [self getDictWithAdInfo:adInfo];
    args[@"placement"] = placmentDict;
    args[@"adInfo"] = adInfoDict;
    [self sendEventWithEventName:LP_RV_ON_AD_CLICKED withArgs:args];
}

/// Manual RV
- (void)rewardedVideoLevelPlayDidLoadWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_MANUAL_RV_ON_AD_READY withArgs:args];
}

/// Manual RV
- (void)rewardedVideoLevelPlayDidFailToLoadWithError:(nonnull NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:LP_MANUAL_RV_ON_AD_LOAD_FAILED withArgs:args];
}

#pragma mark - RCTLevelPlayISDelegate Functions ==================================================
- (void)levelPlayISDidLoadWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_IS_ON_AD_READY withArgs:args];
}

- (void)levelPlayISDidFailToLoadWithError:(nonnull NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:LP_IS_ON_AD_LOAD_FAILED withArgs:args];
}

- (void)levelPlayISDidOpenWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_IS_ON_AD_OPENED withArgs:args];
}


- (void)levelPlayISDidCloseWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_IS_ON_AD_CLOSED withArgs:args];
}

- (void)levelPlayISDidShowWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_IS_ON_AD_SHOW_SUCCEEDED withArgs:args];
}

- (void)levelPlayISDidFailToShowWithError:(nonnull NSError *)error
                                andAdInfo:(nonnull ISAdInfo *)adInfo {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    NSDictionary *errorDict = [self getDictWithIronSourceError:error];
    NSDictionary *adInfoDict = [self getDictWithAdInfo:adInfo];
    args[@"error"] = errorDict;
    args[@"adInfo"] = adInfoDict;
    [self sendEventWithEventName:LP_IS_ON_AD_SHOW_FAILED withArgs:args];
}

- (void)levelPlayISDidClickWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_IS_ON_AD_CLICKED withArgs:args];
}

#pragma mark - RCTLevelPlayBNDelegate Functions ==================================================
- (void)levelPlayBNDidLoad:(nonnull ISBannerView *)bannerView
                withAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_BN_ON_AD_LOADED withArgs:args];
}

- (void)levelPlayBNDidFailToLoadWithError:(nonnull NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self sendEventWithEventName:LP_BN_ON_AD_LOAD_FAILED withArgs:args];
}

- (void)levelPlayBNDidClickWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_BN_ON_AD_CLICKED withArgs:args];
}

- (void)levelPlayBNDidPresentScreenWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_BN_ON_AD_SCREEN_PRESENTED withArgs:args];
}

- (void)levelPlayBNDidDismissScreenWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_BN_ON_AD_SCREEN_DISMISSED withArgs:args];
}

- (void)levelPlayBNDidLeaveApplicationWithAdInfo:(nonnull ISAdInfo *)adInfo {
    NSDictionary *args = [self getDictWithAdInfo:adInfo];
    [self sendEventWithEventName:LP_BN_ON_AD_LEFT_APPLICATION withArgs:args];
}

#pragma mark - Utils ============================================================================

- (void)sendEventWithEventName:(NSString *) eventName withArgs: (NSDictionary * _Nullable) args {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hasEventListeners) {
            [self sendEventWithName:eventName body:args];
        }
    });
}

- (NSDictionary *)getDictWithPlacementInfo:(ISPlacementInfo *)placementInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(placementInfo.placementName != nil){
        dict[@"placementName"] = placementInfo.placementName;
    }
    if(placementInfo.rewardName != nil){
        dict[@"rewardName"] = placementInfo.rewardName;
    }
    if(placementInfo.rewardAmount != nil){
        dict[@"rewardAmount"] = placementInfo.rewardAmount;
    }
    return dict;
}

- (NSDictionary *)getDictWithIronSourceError:(NSError *)error {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(error != nil){
        dict[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil){
        dict[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

- (NSDictionary *)getDictWithAdInfo:(ISAdInfo *)adInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(adInfo.ad_unit != nil){
        dict[@"adUnit"] = adInfo.ad_unit;
    }
    if(adInfo.auction_id != nil){
        dict[@"auctionId"] = adInfo.auction_id;
    }
    if(adInfo.ad_network != nil){
        dict[@"adNetwork"] = adInfo.ad_network;
    }
    if(adInfo.ab != nil){
        dict[@"ab"] = adInfo.ab;
    }
    if(adInfo.country != nil){
        dict[@"country"] = adInfo.country;
    }
    if(adInfo.instance_id != nil){
        dict[@"instanceId"] = adInfo.instance_id;
    }
    if(adInfo.instance_name != nil){
        dict[@"instanceName"] = adInfo.instance_name;
    }
    if(adInfo.segment_name != nil){
        dict[@"segmentName"] = adInfo.segment_name;
    }
    if(adInfo.revenue != nil){
        dict[@"revenue"] = adInfo.revenue;
    }
    if(adInfo.precision != nil){
        dict[@"precision"] = adInfo.precision;
    }
    if(adInfo.encrypted_cpm != nil){
        dict[@"encryptedCPM"] = adInfo.encrypted_cpm;
    }

    return dict;
}

/// must be called from UI Thread
- (UIViewController *)getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

/**
 ConsentView Delegate utils
 */
- (NSMutableDictionary *)getDictWithConsentViewType:(NSString *)consentViewType {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"consentViewType"] = consentViewType;
    return dict;
}

- (NSMutableDictionary *)getDictWithConsentViewType:(NSString *)consentViewType
                                           andError:(NSError *)error {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"consentViewType"] = consentViewType;
    
    if(error != nil){
        dict[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil){
        dict[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

#pragma mark - RCTEventEmitter Constants ========================================================
- (NSDictionary *)constantsToExport {
    return @{
        // RV Listener Events
        @"ON_RV_AD_OPENED" : ON_RV_AD_OPENED,
        @"ON_RV_AD_CLOSED" : ON_RV_AD_CLOSED,
        @"ON_RV_AVAILABILITY_CHANGED" : ON_RV_AVAILABILITY_CHANGED,
        @"ON_RV_AD_REWARDED" : ON_RV_AD_REWARDED,
        @"ON_RV_AD_SHOW_FAILED" : ON_RV_AD_SHOW_FAILED,
        @"ON_RV_AD_CLICKED" : ON_RV_AD_CLICKED,
        @"ON_RV_AD_STARTED" : ON_RV_AD_STARTED,
        @"ON_RV_AD_ENDED" : ON_RV_AD_ENDED,
        
        // Manual Load RV Listener Events
        @"ON_RV_AD_READY" : ON_RV_AD_READY,
        @"ON_RV_AD_LOAD_FAILED" : ON_RV_AD_LOAD_FAILED,
        
        // IS Listener Events
        @"ON_IS_AD_READY" : ON_IS_AD_READY,
        @"ON_IS_AD_LOAD_FAILED" : ON_IS_AD_LOAD_FAILED,
        @"ON_IS_AD_OPENED" : ON_IS_AD_OPENED,
        @"ON_IS_AD_CLOSED" : ON_IS_AD_CLOSED,
        @"ON_IS_AD_SHOW_SUCCEEDED" : ON_IS_AD_SHOW_SUCCEEDED,
        @"ON_IS_AD_SHOW_FAILED" : ON_IS_AD_SHOW_FAILED,
        @"ON_IS_AD_CLICKED" : ON_IS_AD_CLICKED,
        
        // BN Listener Events
        @"ON_BN_AD_LOADED" : ON_BN_AD_LOADED,
        @"ON_BN_AD_LOAD_FAILED" : ON_BN_AD_LOAD_FAILED,
        @"ON_BN_AD_CLICKED" : ON_BN_AD_CLICKED,
        @"ON_BN_AD_SCREEN_PRESENTED" : ON_BN_AD_SCREEN_PRESENTED,
        @"ON_BN_AD_SCREEN_DISMISSED" : ON_BN_AD_SCREEN_DISMISSED,
        @"ON_BN_AD_LEFT_APPLICATION" : ON_BN_AD_LEFT_APPLICATION,
        
        // OW Listener Events
        @"ON_OW_AVAILABILITY_CHANGED" : ON_OW_AVAILABILITY_CHANGED,
        @"ON_OW_OPENED" : ON_OW_OPENED,
        @"ON_OW_SHOW_FAILED" : ON_OW_SHOW_FAILED,
        @"ON_OW_AD_CREDITED" : ON_OW_AD_CREDITED,
        @"ON_OW_CREDITS_FAILED" : ON_OW_CREDITS_FAILED,
        @"ON_OW_CLOSED" : ON_OW_CLOSED,
        
        // ARM ImpressionData Event
        @"ON_IMPRESSION_SUCCESS" : ON_IMPRESSION_SUCCESS,

        // ConsentView Events
        @"CONSENT_VIEW_DID_LOAD_SUCCESS" : CONSENT_VIEW_DID_LOAD_SUCCESS,
        @"CONSENT_VIEW_DID_FAIL_TO_LOAD" : CONSENT_VIEW_DID_FAIL_TO_LOAD,
        @"CONSENT_VIEW_DID_SHOW_SUCCESS" : CONSENT_VIEW_DID_SHOW_SUCCESS,
        @"CONSENT_VIEW_DID_FAIL_TO_SHOW" : CONSENT_VIEW_DID_FAIL_TO_SHOW,
        @"CONSENT_VIEW_DID_ACCEPT" : CONSENT_VIEW_DID_ACCEPT,
        
        // Init Listener Event
        @"ON_INITIALIZATION_COMPLETE" : ON_INITIALIZATION_COMPLETE,
        
        // LevelPlayListener Events
        // LevelPlay RV
        @"LP_RV_ON_AD_AVAILABLE" : LP_RV_ON_AD_AVAILABLE,
        @"LP_RV_ON_AD_UNAVAILABLE" : LP_RV_ON_AD_UNAVAILABLE,
        @"LP_RV_ON_AD_OPENED" : LP_RV_ON_AD_OPENED,
        @"LP_RV_ON_AD_CLOSED" : LP_RV_ON_AD_CLOSED,
        @"LP_RV_ON_AD_REWARDED" : LP_RV_ON_AD_REWARDED,
        @"LP_RV_ON_AD_SHOW_FAILED" : LP_RV_ON_AD_SHOW_FAILED,
        @"LP_RV_ON_AD_CLICKED" : LP_RV_ON_AD_CLICKED,
        // LevelPlay Manual RV
        @"LP_MANUAL_RV_ON_AD_READY" : LP_MANUAL_RV_ON_AD_READY,
        @"LP_MANUAL_RV_ON_AD_LOAD_FAILED" : LP_MANUAL_RV_ON_AD_LOAD_FAILED,
        
        // LevelPlay IS
        @"LP_IS_ON_AD_READY": LP_IS_ON_AD_READY,
        @"LP_IS_ON_AD_LOAD_FAILED": LP_IS_ON_AD_LOAD_FAILED,
        @"LP_IS_ON_AD_OPENED": LP_IS_ON_AD_OPENED,
        @"LP_IS_ON_AD_CLOSED": LP_IS_ON_AD_CLOSED,
        @"LP_IS_ON_AD_SHOW_FAILED": LP_IS_ON_AD_SHOW_FAILED,
        @"LP_IS_ON_AD_CLICKED": LP_IS_ON_AD_CLICKED,
        @"LP_IS_ON_AD_SHOW_SUCCEEDED": LP_IS_ON_AD_SHOW_SUCCEEDED,
        
        // LevelPlay BN
        @"LP_BN_ON_AD_LOADED" : LP_BN_ON_AD_LOADED,
        @"LP_BN_ON_AD_LOAD_FAILED" : LP_BN_ON_AD_LOAD_FAILED,
        @"LP_BN_ON_AD_CLICKED" : LP_BN_ON_AD_CLICKED,
        @"LP_BN_ON_AD_SCREEN_PRESENTED" : LP_BN_ON_AD_SCREEN_PRESENTED,
        @"LP_BN_ON_AD_SCREEN_DISMISSED" : LP_BN_ON_AD_SCREEN_DISMISSED,
        @"LP_BN_ON_AD_LEFT_APPLICATION" : LP_BN_ON_AD_LEFT_APPLICATION
    };
}

#pragma mark - RCTEventEmitter methods ==========================================================

// All events must be registered here.
- (NSArray<NSString *> *)supportedEvents {
    return @[
        // RV Listener Events
        ON_RV_AD_OPENED,
        ON_RV_AD_CLOSED,
        ON_RV_AVAILABILITY_CHANGED,
        ON_RV_AD_REWARDED,
        ON_RV_AD_SHOW_FAILED,
        ON_RV_AD_CLICKED,
        ON_RV_AD_STARTED,
        ON_RV_AD_ENDED,

        // Manual Load RV Listener Events
        ON_RV_AD_READY,
        ON_RV_AD_LOAD_FAILED,
        
        // IS Listener Events
        ON_IS_AD_READY,
        ON_IS_AD_LOAD_FAILED,
        ON_IS_AD_OPENED,
        ON_IS_AD_CLOSED,
        ON_IS_AD_SHOW_SUCCEEDED,
        ON_IS_AD_SHOW_FAILED,
        ON_IS_AD_CLICKED,
        
        // BN Listener Events
        ON_BN_AD_LOADED,
        ON_BN_AD_LOAD_FAILED,
        ON_BN_AD_CLICKED,
        ON_BN_AD_SCREEN_PRESENTED,
        ON_BN_AD_SCREEN_DISMISSED,
        ON_BN_AD_LEFT_APPLICATION,
        
        // OW Listener Events
        ON_OW_AVAILABILITY_CHANGED,
        ON_OW_OPENED,
        ON_OW_SHOW_FAILED,
        ON_OW_AD_CREDITED,
        ON_OW_CREDITS_FAILED,
        ON_OW_CLOSED,
        
        // ARM ImpressionData Event
        ON_IMPRESSION_SUCCESS,

        // ConsentView Events
        CONSENT_VIEW_DID_LOAD_SUCCESS,
        CONSENT_VIEW_DID_FAIL_TO_LOAD,
        CONSENT_VIEW_DID_SHOW_SUCCESS,
        CONSENT_VIEW_DID_FAIL_TO_SHOW,
        CONSENT_VIEW_DID_ACCEPT,
        
        // Init Listener Event
        ON_INITIALIZATION_COMPLETE,
        
        // LevelPlayListener Events
        // LevelPlay RV
        LP_RV_ON_AD_AVAILABLE,
        LP_RV_ON_AD_UNAVAILABLE,
        LP_RV_ON_AD_OPENED,
        LP_RV_ON_AD_CLOSED,
        LP_RV_ON_AD_REWARDED,
        LP_RV_ON_AD_SHOW_FAILED,
        LP_RV_ON_AD_CLICKED,
        // LevelPlay Manual RV
        LP_MANUAL_RV_ON_AD_READY,
        LP_MANUAL_RV_ON_AD_LOAD_FAILED,
        
        // LevelPlay IS
        LP_IS_ON_AD_READY,
        LP_IS_ON_AD_LOAD_FAILED,
        LP_IS_ON_AD_OPENED,
        LP_IS_ON_AD_CLOSED,
        LP_IS_ON_AD_SHOW_FAILED,
        LP_IS_ON_AD_CLICKED,
        LP_IS_ON_AD_SHOW_SUCCEEDED,
        
        // LevelPlay BN
        LP_BN_ON_AD_LOADED,
        LP_BN_ON_AD_LOAD_FAILED,
        LP_BN_ON_AD_CLICKED,
        LP_BN_ON_AD_SCREEN_PRESENTED,
        LP_BN_ON_AD_SCREEN_DISMISSED,
        LP_BN_ON_AD_LEFT_APPLICATION
    ];
}

// Will be called when this module's first listener is added.
-(void)startObserving {
    self.hasEventListeners = YES;
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
    self.hasEventListeners = NO;
}

@end
