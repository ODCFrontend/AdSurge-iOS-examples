//
//  AppOpenViewController.m
//  AdSurgeDemo
//
//  Created by shirao on 2025/12/18.
//

#import <Foundation/Foundation.h>
#import <AdSurgeSDK/AdSurgeAppOpenAd.h>

#import "AdLogTable.h"
#import "AppOpenViewController.h"
#import "SettingManager.h"

@interface AppOpenViewController () <AdSurgeAppOpenAdDelegate>
@property (nonatomic, strong) AdSurgeAppOpenAd *appOpenAd;
@property (nonatomic, strong) AdLogTable *logTable;
@end

@implementation AppOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unitIds = @[@"16762", @"16763"];
    self.unitIdTitles = @[@"General 16762", @"Bidding 16763"];
    self.unitId = self.unitIds.firstObject;
    self.logTable = [[AdLogTable alloc] initWithParentView:self.view withTopMargin:20];
}

- (void)loadAd {
    self.appOpenAd = [[AdSurgeAppOpenAd alloc] initWithAdUnitIdentifier:self.unitId];
    self.appOpenAd.delegate = self;

    AdSurgeAdConfig *adConfig = [AdSurgeAdConfig configWithAdFormat:AdSurgeAdFormat.appOpen];
    adConfig.mute = [SettingManager sharedManager].isMuted;

    [self.appOpenAd loadAd:adConfig];
}

- (void)setNavigationBar {
    [super setNavigationBar];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"AppOpenAD";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)showBtnTapped:(UIButton *)sender {
    [super showBtnTapped:sender];
    if (![self.appOpenAd isValid]) {
        [self.logTable addLogWithInfo:@"Ad not valid" ad:nil error:nil reward:nil];
        return;
    }
    [self.appOpenAd showAdFromRootViewController:self];
}

#pragma mark - AdSurgeAppOpenAdDelegate

- (void)didLoadAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's format: %@, adUnitIdentifier: %@, revenue: %f, creative_id: %@",ad.format.label, ad.adUnitIdentifier, ad.revenue, ad.creativeId);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(AdSurgeError *)error {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's adUnitIdentifier: %@, error: %@",adUnitIdentifier, error);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:nil error:error reward:nil];
}

- (void)didDisplayAd:(AdSurgeAd *)ad withError:(AdSurgeError *)error {
    NSLog(@"%s",__FUNCTION__);
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

- (void)didPayRevenueForAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    [self.logTable addLogWithInfo:NSStringFromSelector(_cmd) ad:ad error:nil reward:nil];
}

@end
