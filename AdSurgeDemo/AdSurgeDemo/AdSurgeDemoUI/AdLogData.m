//
//  AdLogData.m
//  AdSurgeDevDemo
//
//  Created by 饶适 on 2025/9/18.
//

#import "AdLogData.h"

@implementation AdLogData

- (instancetype)initWithIndex:(NSInteger)index info:(NSString *)info timestamp:(NSDate *)timestamp ad:(AdSurgeAd *)ad error:(AdSurgeError *)error reward:(AdSurgeReward *)reward{
    self = [super init];
    if (self) {
        _index = index;
        _info = [info copy];
        _timestamp = [timestamp copy];
        _ad = ad;
        _error = error;
        _reward = reward;
        _isExpanded = NO;
    }
    return self;
}

@end
