//
// Copyright (c) 2016 deltaDNA Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "DDNASmartAdUnityAdsAdapter.h"
#import <UnityAds/UnityAds.h>

@interface DDNASmartAdUnityAdsAdapter () <UnityAdsDelegate>

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic, assign) BOOL testMode;

@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) BOOL reward;

@end

@implementation DDNASmartAdUnityAdsAdapter

- (instancetype)initWithGameId:(NSString *)gameId zoneId:(NSString *)zoneId testMode:(BOOL)testMode eCPM:(NSInteger)eCPM waterfallIndex:(NSInteger)waterfallIndex
{
    if ((self = [super initWithName:@"UNITY" version:[UnityAds getSDKVersion] eCPM:eCPM waterfallIndex:waterfallIndex])) {
        self.gameId = gameId;
        self.zoneId = zoneId;
        self.testMode = testMode;
        
        [[UnityAds sharedInstance] setDelegate:self];
        [[UnityAds sharedInstance] setTestMode:testMode];
        [[UnityAds sharedInstance] setDebugMode:testMode];
        if (zoneId != nil && zoneId.length > 0) {
            [[UnityAds sharedInstance] setZone:zoneId];
        }
    }
    return self;
}

#pragma mark - DDNASmartAdAdapter

- (instancetype)initWithConfiguration:(NSDictionary *)configuration waterfallIndex:(NSInteger)waterfallIndex
{
    if (!configuration[@"gameId"]) return nil;
    
    return [self initWithGameId:configuration[@"gameId"] zoneId:configuration[@"zoneId"] testMode:[configuration[@"testMode"] boolValue] eCPM:[configuration[@"eCPM"] integerValue] waterfallIndex:waterfallIndex];
}

- (void)requestAd
{
    if (!self.started) {
        [[UnityAds sharedInstance] startWithGameId:self.gameId];
        self.started = YES;
    }
    
    if ([[UnityAds sharedInstance] canShow]) {
        [self.delegate adapterDidLoadAd:self];
    }
}

- (void)showAdFromViewController:(UIViewController *)viewController
{
    [[UnityAds sharedInstance] setViewController:viewController];
    
    if ([[UnityAds sharedInstance] canShow]) {
        [[UnityAds sharedInstance] show];
    } else {
        [self.delegate adapterDidFailToShowAd:self withResult:[DDNASmartAdClosedResult resultWith:DDNASmartAdClosedResultCodeNotReady]];
    }
}

#pragma mark - UnityAdsDelegate

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    self.reward = !skipped;
}

- (void)unityAdsWillShow
{

}

- (void)unityAdsDidShow
{
    [self.delegate adapterIsShowingAd:self];
}

- (void)unityAdsWillHide
{

}

- (void)unityAdsDidHide
{
    [self.delegate adapterDidCloseAd:self canReward:self.reward];
    
    if ([[UnityAds sharedInstance] canShow]) {
        [self.delegate adapterDidLoadAd:self];
    }
}

- (void)unityAdsWillLeaveApplication
{
    [self.delegate adapterWasClicked:self];
    [self.delegate adapterLeftApplication:self];
}

- (void)unityAdsVideoStarted
{

}

- (void)unityAdsFetchCompleted
{
    [self.delegate adapterDidLoadAd:self];
}

- (void)unityAdsFetchFailed
{
    [self.delegate adapterDidFailToLoadAd:self withResult:[DDNASmartAdRequestResult resultWith:DDNASmartAdRequestResultCodeError]];
}

@end
