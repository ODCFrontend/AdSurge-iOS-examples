//
//  BaseAdViewController.h
//  AdSurgeDevDemo
//
//  Created by katie on 2025/4/18.
//

#import <UIKit/UIKit.h>

#import "SettingManager.h"

@interface BaseAdViewController : UIViewController
@property (nonatomic, strong) NSArray *unitIdTitles;
@property (nonatomic, strong) NSArray *unitIds;
@property (nonatomic, copy) NSString *unitId;
- (void)loadAd;
- (void)showBtnTapped:(UIButton *)sender;
- (void)setNavigationBar;
- (void)removeShowButton;
@end
