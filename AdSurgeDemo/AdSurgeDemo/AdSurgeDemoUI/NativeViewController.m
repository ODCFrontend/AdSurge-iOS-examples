//
//  NativeViewController.m
//  AdSurgeDemo
//
//  Created by kaze on 2025/11/6.
//

#import <Foundation/Foundation.h>
#import "BaseAdViewController.h"
#import <AdSurgeSDK/AdSurgeNativeAd.h>
#import <AdSurgeSDK/AdSurgeAd.h>
#import "NativeViewController.h"

typedef NS_ENUM(NSInteger, TableViewSection) {
    TableViewSectionSample = 1,
    TableViewSectionAd = 2,
    TableViewSectionCount = 3
};

@interface NativeViewController()<AdSurgeNativeAdDelegate,AdSurgeNativeMediaContentDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary *> *sampleDataArray;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;

@property (nonatomic, strong) AdSurgeNativeAd *nativeAd;
@property (nonatomic, strong) AdSurgeNativeAdView *nativeAdView;

@property (nonatomic, strong) UILabel *headLineLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *callToActionView;
@property (nonatomic, strong) UIView *mediaView;
@property (nonatomic, strong) UIView *adChoicesView;
@property (nonatomic, strong) AdSurgeMediaContent *mediaContent;
@property (nonatomic, assign) BOOL hasRegisteredInteraction;

@end

@implementation NativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeShowButton];
    NSMutableArray *unitIds = [NSMutableArray arrayWithArray:@[
        @"15839",
    ]];
    NSMutableArray *titles = [NSMutableArray arrayWithArray:@[
        @"General 15839",
    ]];
    self.unitIds = unitIds;
    self.unitIdTitles = titles;
    self.unitId = self.unitIds.firstObject;
    [self initializeSampleData];
    [self setupTableView];
}

#pragma mark - TableView Setup

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400.0;
    [self.view addSubview:self.tableView];
    
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:guide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor]
    ]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SettingsCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SampleCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AdCell"];
}

- (void)dealloc {
    NSLog(@"NativeViewController dealloc");
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case TableViewSectionSample:
            return self.sampleDataArray.count;
        case TableViewSectionAd:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableViewSectionSample) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SampleCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        NSDictionary *sampleData = self.sampleDataArray[indexPath.row];
        [self configureSampleCell:cell withData:sampleData];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        [self configureAdCell:cell];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableViewSectionAd) {
        [self handleAdCellWillDisplay:cell atIndexPath:indexPath];
    }
}

#pragma mark - Ad Cell Display Handling

- (void)handleAdCellWillDisplay:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.hasRegisteredInteraction) {
        NSLog(@"[Register] Already registered, skipping");
        return;
    }
    if (!self.nativeAd || !self.nativeAdView) {
        NSLog(@"[Register] Missing nativeAd or nativeAdView");
        return;
    }
    if (self.isBeingDismissed || self.isMovingFromParentViewController) {
        NSLog(@"[Register] View controller is deallocating");
        return;
    }
    if (!self.headLineLabel || !self.iconView || !self.callToActionView || !self.adChoicesView) {
        NSLog(@"[Register] Views not ready yet, ad might still be loading");
        return;
    }
    [self.nativeAd registerViewForInteraction:self.nativeAdView
                                   clickViews:@[self.headLineLabel, self.adChoicesView, self.iconView, self.callToActionView]];
    self.hasRegisteredInteraction = YES;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TableViewSectionSample:
            return 180.0;
        case TableViewSectionAd:
            return 480.0;
        default:
            return 44.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

#pragma mark - Cell Configuration


- (void)configureSampleCell:(UITableViewCell *)cell {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"sample for show";
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"This is a sample cell used to display other content";
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor grayColor];
    descLabel.numberOfLines = 2;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:descLabel];
    
    UIView *sampleView = [[UIView alloc] init];
    sampleView.backgroundColor = [UIColor systemBlueColor];
    sampleView.layer.cornerRadius = 8.0;
    sampleView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:sampleView];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [titleLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:12],
        
        [descLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [descLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:6],
        
        [sampleView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [sampleView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
        [sampleView.topAnchor constraintEqualToAnchor:descLabel.bottomAnchor constant:8],
        [sampleView.heightAnchor constraintEqualToConstant:30]
    ]];
}

- (void)configureAdCell:(UITableViewCell *)cell {
    self.nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:self.nativeAdView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.nativeAdView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:12],
        [self.nativeAdView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:12],
        [self.nativeAdView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-12],
        [self.nativeAdView.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-12]
    ]];
}

#pragma mark - Ad Loading

- (void)playButtonTapped:(UIButton *)sender {
    AdSurgeMediaContent *mediaContent = self.nativeAd.mediaContent;
    if (mediaContent) {
        [mediaContent play];
    } else {
        NSLog(@"mediaContent is nil");
    }
}

- (void)pauseButtonTapped:(UIButton *)sender {
    AdSurgeMediaContent *mediaContent = self.nativeAd.mediaContent;
    
    if (mediaContent) {
        [mediaContent pause];
    } else {
        NSLog(@"Warning: mediaContent is nil");
    }
}
- (void)setNavigationBar {
    [super setNavigationBar];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"NativeAd";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)loadAd {
    if (self.isBeingDismissed || self.isMovingFromParentViewController) {
        return;
    }
    
    if (self.nativeAd) {
        self.nativeAd = nil;
    }
    
    if (self.nativeAdView) {
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = nil;
    }
    self.hasRegisteredInteraction = NO;
    AdSurgeNativeAd *nativeAd = [[AdSurgeNativeAd alloc] initWithAdUnitIdentifier:self.unitId];
    nativeAd.viewController = self;
    nativeAd.delegate = self;
    self.nativeAd = nativeAd;

    AdSurgeNativeAdView *nativeAdView = [[AdSurgeNativeAdView alloc] init];
    self.nativeAdView = nativeAdView;
    
    AdSurgeAdConfig *adConfig = [AdSurgeAdConfig configWithAdFormat:AdSurgeAdFormat.native];
    adConfig.nativeAdLogoPos = AdSurgeNativeLogoPosition_TopRight;
    [self.nativeAd loadAd:adConfig];
}

- (void)commonInit {
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:nil];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.clipsToBounds = YES;
    iconImageView.layer.cornerRadius = 8.0;
    iconImageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    NSURL *url = [NSURL URLWithString:self.nativeAd.iconInfo.iconUrl];
    [self downloadImageFromURL:url completion:^(UIImage * image) {
        iconImageView.image = image;
    }];
    _iconView = iconImageView;
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;

    _headLineLabel = [[UILabel alloc] init];
    _headLineLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    _headLineLabel.numberOfLines = 1;
    _headLineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _headLineLabel.text = self.nativeAd.headLine;
    _headLineLabel.textColor = [UIColor blackColor];

    _bodyLabel = [[UILabel alloc] init];
    _bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    _bodyLabel.numberOfLines = 2;
    _bodyLabel.textColor = [UIColor grayColor];
    _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _bodyLabel.text = self.nativeAd.body;

    _mediaView = [[UIView alloc] init];
    _mediaView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _mediaView.layer.cornerRadius = 8.0;
    _mediaView.clipsToBounds = YES;
    _mediaView.translatesAutoresizingMaskIntoConstraints = NO;

    _callToActionView = [[UILabel alloc] init];
    _callToActionView.backgroundColor = [UIColor systemBlueColor];
    _callToActionView.layer.cornerRadius = 6.0;
    _callToActionView.translatesAutoresizingMaskIntoConstraints = NO;
    _callToActionView.clipsToBounds = YES;
    _callToActionView.textAlignment = NSTextAlignmentCenter;
    _callToActionView.text = self.nativeAd.callToAction;
    _callToActionView.textColor = [UIColor whiteColor];
    _callToActionView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _callToActionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [_callToActionView.centerYAnchor constraintEqualToAnchor:_callToActionView.centerYAnchor],
        [_callToActionView.centerXAnchor constraintEqualToAnchor:_callToActionView.centerXAnchor]
    ]];
    
    self.adChoicesView = self.nativeAd.adChoicesView;
    self.adChoicesView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    self.adChoicesView.layer.cornerRadius = 6.0;
    self.adChoicesView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.playButton = [[UIButton alloc] init];
    self.playButton.backgroundColor = [UIColor systemGreenColor];
    self.playButton.layer.cornerRadius = 6.0;
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playButton setTitle:@"▶ Play" forState:UIControlStateNormal];
    [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.playButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [self.playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    self.pauseButton = [[UIButton alloc] init];
    self.pauseButton.backgroundColor = [UIColor systemOrangeColor];
    self.pauseButton.layer.cornerRadius = 6.0;
    self.pauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.pauseButton setTitle:@"⏸ Pause" forState:UIControlStateNormal];
    [self.pauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pauseButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [self.pauseButton addTarget:self action:@selector(pauseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.nativeAdView addSubview:_iconView];
    [self.nativeAdView addSubview:_headLineLabel];
    [self.nativeAdView addSubview:_bodyLabel];
    [self.nativeAdView addSubview:_mediaView];
    [self.nativeAdView addSubview:_callToActionView];
    [self.nativeAdView addSubview:_playButton];
    [self.nativeAdView addSubview:_pauseButton];
    [self.nativeAdView addSubview:_adChoicesView];
    
    [self.nativeAdView setHeadlineView:_headLineLabel];
    [self.nativeAdView setIconView:_iconView];
    [self.nativeAdView setBodyView:_bodyLabel];
    [self.nativeAdView setMediaView:_mediaView];
    [self.nativeAdView setCallToActionView:_callToActionView];
    
    self.nativeAdView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    self.mediaContent = self.nativeAd.mediaContent;
    self.mediaContent.delegate = self;
    NSLog(@"mediaContent ratio:%f",self.mediaContent.aspectRatio);
    NSLog(@"mediaContent duration:%f",self.mediaContent.duration);

    [self setupConstraints];
    [self.tableView reloadData];
}

- (void)setupConstraints {
    CGFloat margin = 12.0;
    CGFloat iconSize = 60.0;
    CGFloat labelHeight = 30.0;
    CGFloat buttonHeight = 36.0;
    CGFloat buttonWidth = 75.0;
    CGFloat buttonSpacing = 8.0;
    CGFloat adChoicesWidth = 40.0;

    [NSLayoutConstraint activateConstraints:@[
        [_iconView.topAnchor constraintEqualToAnchor:self.nativeAdView.topAnchor constant:margin],
        [_iconView.leadingAnchor constraintEqualToAnchor:self.nativeAdView.leadingAnchor constant:margin],
        [_iconView.widthAnchor constraintEqualToConstant:iconSize],
        [_iconView.heightAnchor constraintEqualToConstant:iconSize]
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [_headLineLabel.topAnchor constraintEqualToAnchor:_iconView.topAnchor],
        [_headLineLabel.leadingAnchor constraintEqualToAnchor:_iconView.trailingAnchor constant:10.0],
        [_headLineLabel.trailingAnchor constraintEqualToAnchor:self.nativeAdView.trailingAnchor constant:-margin],
        [_headLineLabel.heightAnchor constraintEqualToConstant:labelHeight]
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [_bodyLabel.topAnchor constraintEqualToAnchor:_headLineLabel.bottomAnchor constant:6.0],
        [_bodyLabel.leadingAnchor constraintEqualToAnchor:_headLineLabel.leadingAnchor],
        [_bodyLabel.trailingAnchor constraintEqualToAnchor:_headLineLabel.trailingAnchor],
        [_bodyLabel.heightAnchor constraintEqualToConstant:labelHeight]
    ]];

    NSLayoutConstraint *mediaTopToIcon = [_mediaView.topAnchor constraintEqualToAnchor:_iconView.bottomAnchor constant:12.0];
    mediaTopToIcon.priority = UILayoutPriorityDefaultLow;
    mediaTopToIcon.active = YES;

    NSLayoutConstraint *mediaTopToBody = [_mediaView.topAnchor constraintEqualToAnchor:_bodyLabel.bottomAnchor constant:12.0];
    mediaTopToBody.priority = UILayoutPriorityRequired;
    mediaTopToBody.active = YES;

    [NSLayoutConstraint activateConstraints:@[
        [_mediaView.leadingAnchor constraintEqualToAnchor:self.nativeAdView.leadingAnchor constant:margin],
        [_mediaView.trailingAnchor constraintEqualToAnchor:self.nativeAdView.trailingAnchor constant:-margin],
        [_mediaView.heightAnchor constraintEqualToConstant:300.0]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.adChoicesView.centerYAnchor constraintEqualToAnchor:self.callToActionView.centerYAnchor],
        [self.adChoicesView.trailingAnchor constraintEqualToAnchor:self.nativeAdView.trailingAnchor constant:-12.0],
        [self.adChoicesView.heightAnchor constraintEqualToConstant:24.0],
        [self.adChoicesView.widthAnchor constraintEqualToConstant:40.0]
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [_callToActionView.topAnchor constraintEqualToAnchor:_mediaView.bottomAnchor constant:10.0],
        [_callToActionView.leadingAnchor constraintEqualToAnchor:self.nativeAdView.leadingAnchor constant:margin],
        [_callToActionView.heightAnchor constraintEqualToConstant:buttonHeight],
        [_callToActionView.widthAnchor constraintGreaterThanOrEqualToConstant:100.0],
        [_callToActionView.bottomAnchor constraintLessThanOrEqualToAnchor:self.nativeAdView.bottomAnchor constant:-margin]
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.playButton.topAnchor constraintEqualToAnchor:_callToActionView.topAnchor],
        [self.playButton.leadingAnchor constraintEqualToAnchor:_callToActionView.trailingAnchor constant:buttonSpacing],
        [self.playButton.heightAnchor constraintEqualToConstant:buttonHeight],
        [self.playButton.widthAnchor constraintEqualToConstant:buttonWidth]
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.pauseButton.topAnchor constraintEqualToAnchor:_callToActionView.topAnchor],
        [self.pauseButton.leadingAnchor constraintEqualToAnchor:self.playButton.trailingAnchor constant:buttonSpacing],
        [self.pauseButton.heightAnchor constraintEqualToConstant:buttonHeight],
        [self.pauseButton.widthAnchor constraintEqualToConstant:buttonWidth],
        [self.pauseButton.trailingAnchor constraintLessThanOrEqualToAnchor:self.nativeAdView.trailingAnchor constant:-(margin + adChoicesWidth + buttonSpacing)]
    ]];
}




- (void)downloadImageFromURL:(NSURL *)url completion:(void(^)(UIImage *image))completion {
    if (!url) {
        if (completion) completion(nil);
        return;
    }

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = nil;
        if (data && !error) {
            image = [UIImage imageWithData:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(image);
        });
    }];
    [task resume];
}



#pragma mark - AdSurgeNativeAdDelegate

- (void)didLoadAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's format: %@, adUnitIdentifier: %@, revenue: %f",ad.format.label, ad.adUnitIdentifier, ad.revenue);
    [self commonInit];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(AdSurgeError *)error {
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"ad's adUnitIdentifier: %@, error: %@",adUnitIdentifier, error);
}

- (void)didDisplayAd:(AdSurgeAd *)ad withError:(AdSurgeError *)error {
    NSLog(@"%s \n",__FUNCTION__);
    NSLog(@"%@ \n",error);
}

- (void)didClickAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
}

- (void)didPayRevenueForAd:(AdSurgeAd *)ad {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - AdSurgeNativeMediaContentDelegate
- (void)mediaContentDidStopVideo {
    NSLog(@"%s",__FUNCTION__);
}

- (void)mediaContentDidPauseVideo {
    NSLog(@"%s",__FUNCTION__);
}

- (void)mediaContentDidStartVideo {
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - Sample Data Management

- (void)initializeSampleData {
    self.sampleDataArray = @[
        @{
            @"title": @"sample 1",
            @"description": @"This is the first sample cell, used for displaying content",
            @"color": [UIColor systemBlueColor]
        },
        @{
            @"title": @"sample 2",
            @"description": @"This is the second sample cell, showing different content",
            @"color": [UIColor systemGreenColor]
        },
        @{
            @"title": @"sample 3",
            @"description": @"This is the third sample cell. Let's continue to show",
            @"color": [UIColor systemOrangeColor]
        },
        @{
            @"title": @"sample 4",
            @"description": @"This is the fourth sample cell, the last example",
            @"color": [UIColor systemPurpleColor]
        }
    ];
}

- (void)configureSampleCell:(UITableViewCell *)cell withData:(NSDictionary *)sampleData {
    NSString *title = sampleData[@"title"];
    NSString *description = sampleData[@"description"];
    UIColor *color = sampleData[@"color"];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:titleLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = description;
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = [UIColor grayColor];
    descLabel.numberOfLines = 2;
    descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:descLabel];
    
    UIView *sampleView = [[UIView alloc] init];
    sampleView.backgroundColor = color;
    sampleView.layer.cornerRadius = 8.0;
    sampleView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.contentView addSubview:sampleView];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [titleLabel.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:12],
        
        [descLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [descLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
        [descLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:6],
        
        [sampleView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:16],
        [sampleView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-16],
        [sampleView.topAnchor constraintEqualToAnchor:descLabel.bottomAnchor constant:8],
        [sampleView.heightAnchor constraintEqualToConstant:30]
    ]];
}


- (void)addSampleCellWithTitle:(NSString *)title description:(NSString *)description color:(UIColor *)color {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.sampleDataArray];
    [mutableArray addObject:@{
        @"title": title,
        @"description": description,
        @"color": color
    }];
    self.sampleDataArray = [mutableArray copy];
    
    // Refresh the Sample Section of the TableView
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionSample] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)removeSampleCellAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.sampleDataArray.count) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.sampleDataArray];
        [mutableArray removeObjectAtIndex:index];
        self.sampleDataArray = [mutableArray copy];
        
        // Refresh the Sample Section of the TableView
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionSample] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (void)clearAllSampleCells {
    self.sampleDataArray = @[];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:TableViewSectionSample] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
