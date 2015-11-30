//
//  DDNASmartAdChartboostInterstitialAdapter.h
//  
//
//  Created by David White on 30/11/2015.
//
//

#import <Foundation/Foundation.h>
#import <DeltaDNAAds/DDNASmartAdAdapter.h>

@interface DDNASmartAdChartboostInterstitialAdapter : DDNASmartAdAdapter

@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *appSignature;
@property (nonatomic, copy, readonly) NSString *location;

- (instancetype)initWithAppId:(NSString *)appId
                 appSignature:(NSString *)appSignature
                     location:(NSString *)location
                         eCPM:(NSInteger)eCPM
               waterfallIndex:(NSInteger)waterfallIndex;

@end
