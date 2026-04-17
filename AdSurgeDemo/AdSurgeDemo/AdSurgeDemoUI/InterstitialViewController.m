//
//  InterstitialViewController.m
//  AdSurgeDevDemo
//
//  Created by katie on 2025/4/18.
//

#import <AdSurgeSDK/AdSurgeInterstitialAd.h>
#import "AdLogTable.h"
#import "InterstitialViewController.h"

@interface InterstitialViewController ()<AdSurgeInterstitialAdDelegate>

@property (nonatomic) AdSurgeInterstitialAd *interstitialAd;
@property (nonatomic, strong) AdLogTable *logTable;

@end

@implementation InterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unitIdTitles = @[
        @"General 10857",
    ];
    self.unitIds = @[
        @"10857",
    ];
    self.unitId = self.unitIds.firstObject;
    self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:20];
}

- (void)loadAd {
    self.interstitialAd = [[AdSurgeInterstitialAd alloc] initWithAdUnitIdentifier:self.unitId];
    self.interstitialAd.delegate = self;
    
    AdSurgeAdConfig *adConfig = [AdSurgeAdConfig configWithAdFormat:AdSurgeAdFormat.interstitial];
    adConfig.mute = [SettingManager sharedManager].isMuted;
    [self.interstitialAd loadAd:adConfig];
}

- (void)setNavigationBar {
    [super setNavigationBar];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"InterstitialAD";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)showBtnTapped:(UIButton *)sender {
    [super showBtnTapped:sender];
    if (![self.interstitialAd isValid]) {
        [self.logTable addLogWithInfo:@"Ad not valid" ad:nil error:nil reward:nil];
        return;
    }
    [self.interstitialAd showAdFromRootViewController:self];
}

#pragma mark - AdSurgeRewardedAdDelegate

// 广告数据加载成功回调
- (void)didLoadAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's format: %@, adUnitIdentifier: %@, revenue: %f",ad.format.label, ad.adUnitIdentifier, ad.revenue);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

// 广告数据加载失败失败回调
- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(AdSurgeError *)error {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's adUnitIdentifier: %@, error: %@",adUnitIdentifier, error);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:nil error:error reward:nil];
}

// 广告已经被展示的回调
- (void)didDisplayAd:(AdSurgeAd *)ad withError:(AdSurgeError *)error {
    NSLog(@"%s \n",__FUNCTION__);
    NSLog(@"%@ \n",error);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:error reward:nil];
}

// 广告关闭回调
- (void)didHideAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

// 广告点击回调
- (void)didClickAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

// 广告曝光回调
- (void)didPayRevenueForAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

@end
