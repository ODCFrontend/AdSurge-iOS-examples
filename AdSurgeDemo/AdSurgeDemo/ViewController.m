//
//  ViewController.m
//  AdSurgeDemo
//
//  Created by andrew taylor on 2025/3/17.
//

#import "ViewController.h"
#import "SettingManager.h"

#define kTableViewHeaderHeight 54.0
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *demoArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    NSArray *section1 = @[
        @[@"RewardAD", @"RewardedViewController"],
        @[@"interstitialAD", @"InterstitialViewController"],
        @[@"BannerAD", @"BannerViewController"],
        @[@"NativeAD", @"NativeViewController"],
        @[@"AppOpenAD", @"AppOpenViewController"]];

    self.demoArray = @[
        @{@"Supported ad form": section1}
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavigationBar];
}

- (void)setNavigationBar {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"AdSurge demo - ObjC";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    [label sizeToFit];
    self.navigationItem.titleView = label;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[self getBtnIcon] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressMuteBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.widthAnchor constraintEqualToConstant:25],
        [button.heightAnchor constraintEqualToConstant:25]
    ]];
    UIBarButtonItem *muteBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = muteBtn;
}

- (void)pressMuteBtn:(UIButton*)btn {
    [SettingManager sharedManager].isMuted = ![SettingManager sharedManager].isMuted;
    UIImage *image = [self getBtnIcon];
    [btn setImage:image forState:UIControlStateNormal];
}
- (UIImage *)getBtnIcon {
    return [SettingManager sharedManager].isMuted ? [UIImage imageNamed:@"mute_icon"] : [UIImage imageNamed:@"unmute_icon"];
}
#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.demoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTableViewHeaderHeight)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.0, 0, header.bounds.size.width - 18.0, kTableViewHeaderHeight)];
    label.text = [[self.demoArray[section] allKeys] firstObject];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:18.0];
    [header addSubview:label];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[(NSDictionary *)self.demoArray[section] allValues] firstObject] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *cellConfig = (NSArray *)[[(NSDictionary *)self.demoArray[indexPath.section] allValues] firstObject];
    cell.textLabel.text = cellConfig[indexPath.row][0];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(383, 15, 10, 14)];
    img.image = [UIImage imageNamed:@"showMoreBtn"];
    img.translatesAutoresizingMaskIntoConstraints = NO;
    [cell addSubview:img];
    [NSLayoutConstraint activateConstraints:@[
        [img.widthAnchor constraintEqualToConstant:10],
        [img.heightAnchor constraintEqualToConstant:14],
        [img.centerYAnchor constraintEqualToAnchor:cell.centerYAnchor],
        [img.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor constant:-20]
    ]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *cellConfig = (NSArray *)[[(NSDictionary *)self.demoArray[indexPath.section] allValues] firstObject];
    id item = cellConfig[indexPath.row][1];
    if ([item isKindOfClass:[NSString class]]) {
        UIViewController *vc = [[NSClassFromString(item) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}


@end
