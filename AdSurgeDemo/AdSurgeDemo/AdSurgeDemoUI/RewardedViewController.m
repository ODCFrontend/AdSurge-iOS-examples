//
//  RewardedViewController.m
//  AdSurgeDevDemo
//
//  Created by katie on 2025/4/17.
//

#import <Foundation/Foundation.h>

#import <AdSurgeSDK/AdSurgeRewardedAd.h>

#import "AdLogTable.h"
#import "RewardedViewController.h"

@interface RewardedViewController ()<AdSurgeRewardedAdDelegate>

@property (nonatomic) AdSurgeRewardedAd *rewardedAd;
@property (nonatomic, strong) AdLogTable *logTable;

@end

@implementation RewardedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unitIdTitles = @[
        @"General 10856",
    ];
    self.unitIds = @[
        @"10856",
    ];
    self.unitId = self.unitIds.firstObject;
    self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:20];
}

- (void)loadAd {
    self.rewardedAd = [[AdSurgeRewardedAd alloc] initWithAdUnitIdentifier:self.unitId];
    self.rewardedAd.delegate = self;
    
    AdSurgeAdConfig *adConfig = [AdSurgeAdConfig configWithAdFormat:AdSurgeAdFormat.rewarded];
    adConfig.mute = [SettingManager sharedManager].isMuted;
    [self.rewardedAd loadAd:adConfig];
}

- (void)setNavigationBar {
    [super setNavigationBar];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"RewardAD";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)showBtnTapped:(UIButton *)sender {
    [super showBtnTapped:sender];
    if (![self.rewardedAd isValid]) {
        [self.logTable addLogWithInfo:@"Ad not valid" ad:nil error:nil reward:nil];
        return;
    }
    [self.rewardedAd showAdFromRootViewController:self];
}

#pragma mark - AdSurgeRewardedAdDelegate

- (void)didLoadAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's format: %@, adUnitIdentifier: %@, revenue: %f",ad.format.label, ad.adUnitIdentifier, ad.revenue);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(AdSurgeError *)error {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's adUnitIdentifier: %@, error: %@",adUnitIdentifier, error);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:nil error:error reward:nil];
}

- (void)didDisplayAd:(AdSurgeAd *)ad withError:(AdSurgeError *)error {
    NSLog(@"%s \n",__FUNCTION__);
    NSLog(@"%@ \n",error);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:error reward:nil];
}

- (void)didHideAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

- (void)didClickAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

- (void)didRewardUserForAd:(AdSurgeAd *)ad withReward:(AdSurgeReward *)reward {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:reward];
}

- (void)didPayRevenueForAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

@end
