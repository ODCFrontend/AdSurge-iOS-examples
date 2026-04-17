//
//  AdLogData.h
//  AdSurgeDevDemo
//
//  Created by 饶适 on 2025/9/18.
//

#import <Foundation/Foundation.h>


#import <AdSurgeSDK/AdSurgeAd.h>
#import <AdSurgeSDK/AdSurgeError.h>
#import <AdSurgeSDK/AdSurgeReward.h>


NS_ASSUME_NONNULL_BEGIN

@interface AdLogData : NSObject

@property (nonatomic, readonly) NSInteger index;
@property (nonatomic, readonly, copy) NSString *info;
@property (nonatomic, readonly, copy) NSDate *timestamp;
@property (nonatomic, readonly, strong) AdSurgeAd *ad;
@property (nonatomic, readonly, strong) AdSurgeError *error;
@property (nonatomic, readonly, strong) AdSurgeReward *reward;
@property (nonatomic, assign) BOOL isExpanded;

- (instancetype)initWithIndex:(NSInteger)index info:(NSString *)info timestamp:(NSDate *) timestamp ad:(AdSurgeAd *)ad error:(AdSurgeError *)error reward:(AdSurgeReward *)reward;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
