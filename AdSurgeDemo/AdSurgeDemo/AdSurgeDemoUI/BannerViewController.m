//
//  BannerViewController.m
//  AdSurgeDemo
//
//  Created by admin on 2025/9/8.
//

#import <Foundation/Foundation.h>

#import <AdSurgeSDK/AdSurgeBannerAdView.h>

#import "AdLogTable.h"
#import "BannerViewController.h"

@interface BannerViewController ()<AdSurgeBannerAdDelegate>

@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic) AdSurgeBannerAdView *bannerView;
@property (nonatomic, strong) AdLogTable *logTable;

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeShowButton];
    NSMutableArray *unitIds = [NSMutableArray arrayWithArray:@[
        @"15884",
        @"15877",
    ]];
    NSMutableArray *titles = [NSMutableArray arrayWithArray:@[
        @"Banner 15884",
        @"MREC 15877",
    ]];
    self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:250];
    self.unitIds = unitIds;
    self.unitIdTitles = titles;
    self.unitId = self.unitIds.firstObject;
}

- (void)loadAd {
    if (self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
    AdSurgeBannerAdView *bannerView = [[AdSurgeBannerAdView alloc] initWithAdUnitIdentifier:self.unitId];
    bannerView.viewController = self;
    bannerView.delegate = self;
    self.bannerView = bannerView;
    CGRect rect;
    rect = CGRectMake(10, 200, 320, 50);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        rect = CGRectMake(10, 200, 728, 90);
    }
    if (self.bannerView) {
        self.bannerView.frame = rect;
    }
    [self.view addSubview:self.bannerView];
    
    AdSurgeAdConfig *adConfig = [AdSurgeAdConfig configWithAdFormat:AdSurgeAdFormat.banner];
    [self.bannerView loadAd:adConfig];

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

- (void)didHideAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

- (void)didClickAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

- (void)didPayRevenueForAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}


@end
