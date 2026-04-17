//
//  AdLogViewCell.h
//  AdSurgeDevDemo
//
//  Created by 饶适 on 2025/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AdLogViewCell;

@protocol AdLogViewCellDelegate <NSObject>

- (void)adLogCellDidTapExpandButton:(AdLogViewCell *)cell;

@end

@interface AdLogViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) id<AdLogViewCellDelegate> delegate;

- (void)configureWithIndex:(NSInteger)index info:(NSString *)info timestamp:(NSString *)timestamp;
- (void)addDetailsLabelWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
