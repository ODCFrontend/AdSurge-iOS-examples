//
//  AdLogViewCell.m
//  AdSurgeDevDemo
//
//  Created by 饶适 on 2025/9/17.
//

#import "AdLogViewCell.h"

@interface AdLogViewCell ()

@property (nonatomic, strong) NSMutableArray<UILabel *> *dynamicLabels;

@end

@implementation AdLogViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dynamicLabels = [NSMutableArray array];
    [self.expandButton addTarget:self action:@selector(expandButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)prepareForReuse{
    [super prepareForReuse];
    for(UILabel *label in self.dynamicLabels){
        [label removeFromSuperview];
    }
    [self.dynamicLabels removeAllObjects];
}

- (void)configureWithIndex:(NSInteger)index info:(NSString *)info timestamp:(NSString *)timestamp {
    self.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
    self.mainInfoLabel.text = info;
    self.timestampLabel.text = timestamp;
}

- (void)addDetailsLabelWithText:(NSString *)text {
    UILabel *detailsLabel = [UILabel new];
    detailsLabel.text = text;
    detailsLabel.font = [UIFont systemFontOfSize:14.0];
    
    [self.stackView addArrangedSubview:detailsLabel];
    [self.dynamicLabels addObject:detailsLabel];
}

- (void)expandButtonTapped {
    [self.delegate adLogCellDidTapExpandButton:self];
}

@end
