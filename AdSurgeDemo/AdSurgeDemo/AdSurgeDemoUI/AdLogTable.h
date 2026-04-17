//
//  AdLogTable.h
//  AdSurgeDevDemo
//
//  Created by 饶适 on 2025/9/19.
//

#import <UIKit/UIKit.h>

#import <AdSurgeSDK/AdSurgeAd.h>
#import <AdSurgeSDK/AdSurgeError.h>
#import <AdSurgeSDK/AdSurgeReward.h>

#import "AdLogData.h"
#import "AdLogViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdLogTable : NSObject

@property (nonatomic, strong, readonly) UITableView *tableView;

- (instancetype)initWithParentView:(UIView *)parentView withTopMargin:(CGFloat) topMargin;

- (void)cleanup;
- (void)addLogWithInfo:(NSString *)info ad:(nullable AdSurgeAd *)ad error:(nullable AdSurgeError *)error reward:(nullable AdSurgeReward *)reward;

@end

NS_ASSUME_NONNULL_END
