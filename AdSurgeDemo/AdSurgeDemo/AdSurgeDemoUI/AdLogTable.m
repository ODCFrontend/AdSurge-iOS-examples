//
//  AdLogTable.m
//  AdSurgeDevDemo
//
//  Created by 饶适 on 2025/9/19.
//

#import "AdLogTable.h"

@interface AdLogTable () <UITableViewDelegate, UITableViewDataSource, AdLogViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<AdLogData *> *logs;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AdLogTable

- (instancetype)initWithParentView:(UIView *)parentView withTopMargin:(CGFloat) topMargin {
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.accessibilityIdentifier = @"tableView_id";
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0;
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [parentView addSubview:_tableView];
        [NSLayoutConstraint activateConstraints:@[
            [_tableView.leadingAnchor constraintEqualToAnchor:parentView.safeAreaLayoutGuide.leadingAnchor constant:20],
            [_tableView.trailingAnchor constraintEqualToAnchor:parentView.safeAreaLayoutGuide.trailingAnchor constant:-20],
            [_tableView.topAnchor constraintEqualToAnchor:parentView.topAnchor constant:topMargin],
            [_tableView.bottomAnchor constraintEqualToAnchor:parentView.bottomAnchor constant:-75]
        ]];
        
        UINib *nib = [UINib nibWithNibName:@"AdLogViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"AdLogViewCell"];

        _logs = [NSMutableArray array];
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    return self;
}

- (void)cleanup {
    [self.tableView removeFromSuperview];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}

- (void)addLogWithInfo:(NSString *)info ad:(nullable AdSurgeAd *)ad error:(nullable AdSurgeError *)error reward:(nullable AdSurgeReward *)reward {
    NSInteger index = self.logs.count + 1;
    NSDate *now = [NSDate date];
    
    AdLogData *logItem = [[AdLogData alloc] initWithIndex:index info:info timestamp:now ad:ad error:error reward:reward];
    [self.logs addObject:logItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.logs.count - 1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.logs.count > 1) { // Reload for the previous row to update round corner
        NSIndexPath *previousLastIndexPath = [NSIndexPath indexPathForRow:self.logs.count - 2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[previousLastIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

// 设置cell的圆角（首个：左上，右上为圆角， 尾个：左下，右下为圆角，只有一个时：四个角均为圆角）
- (void)setCornerRadiusForSectionCell:(UITableViewCell *)cell
                            indexPath:(NSIndexPath *)indexPath
                            tableView:(UITableView *)tableView {
    CGFloat cornerRadius = 20.0;
    NSInteger sectionCount = [tableView numberOfRowsInSection:indexPath.section];

    cell.layer.mask = nil;
    cell.layer.cornerRadius = 0;
    cell.layer.maskedCorners = 0;

    if (sectionCount > 1) {
        if (indexPath.row == 0) {
            cell.layer.cornerRadius = cornerRadius;
            cell.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
        } else if (indexPath.row == sectionCount - 1) {
            cell.layer.cornerRadius = cornerRadius;
            cell.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        }
    } else {
        cell.layer.cornerRadius = cornerRadius;
        cell.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    cell.clipsToBounds = YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setCornerRadiusForSectionCell:cell indexPath:indexPath tableView:tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.logs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdLogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdLogViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    AdLogData *log = self.logs[indexPath.row];
    [cell configureWithIndex:log.index info:log.info timestamp:[self.dateFormatter stringFromDate:log.timestamp]];
    
    if (log.isExpanded) {
        if (log.error) {
            [cell addDetailsLabelWithText:@"Error:"];
            [cell addDetailsLabelWithText:[NSString stringWithFormat:@"\tCode: %ld", (long)log.error.code]];
            [cell addDetailsLabelWithText:[NSString stringWithFormat:@"\tMessage: %@", log.error.message]];
        }
        if (log.ad) {
            [cell addDetailsLabelWithText:@"Ad Info:"];
            [cell addDetailsLabelWithText:[NSString stringWithFormat:@"\tIdentifier: %@", log.ad.adUnitIdentifier]];
            [cell addDetailsLabelWithText:[NSString stringWithFormat:@"\tRevenue: %f", log.ad.revenue]];
        }
        if (log.reward) {
            [cell addDetailsLabelWithText:@"Reward:"];
            [cell addDetailsLabelWithText:[NSString stringWithFormat:@"\tLabel: %@", log.reward.label]];
            [cell addDetailsLabelWithText:[NSString stringWithFormat:@"\tAmount: %ld", (long)log.reward.amount]];
        }
    }
    
    return cell;
}

#pragma mark - AdLogViewCellDelegate

- (void)adLogCellDidTapExpandButton:(AdLogViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) return;
    
    AdLogData *logItem = self.logs[indexPath.row];
    logItem.isExpanded = !logItem.isExpanded;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
