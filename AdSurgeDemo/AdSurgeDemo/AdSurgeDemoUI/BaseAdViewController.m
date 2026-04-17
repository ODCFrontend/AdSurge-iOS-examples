//
//  BaseAdViewController.m
//  AdSurgeDevDemo
//
//  Created by katie on 2025/4/18.
//

#import <Foundation/Foundation.h>

#import "BaseAdViewController.h"
@interface BaseAdViewController ()
@property (nonatomic, strong) UIButton *showBtn;
@end
@implementation BaseAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed: 242/255.0 green: 242/255.0 blue: 247/255.0 alpha: 1.0];
    [self setNavigationBar];

    UIButton *showBtn = [[UIButton alloc] init];
    showBtn.backgroundColor = UIColor.whiteColor;
    [showBtn setTitle:@"Show" forState:normal];
    [showBtn setTitleColor:[UIColor blueColor] forState:normal];
    [showBtn addTarget:self action:@selector(showBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    showBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [showBtn.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [showBtn.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [showBtn.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [showBtn.heightAnchor constraintEqualToConstant:65]
    ]];
    self.showBtn = showBtn;
}

- (void)unitid:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"UnitIdentifier"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < self.unitIdTitles.count; i++) {
        NSString *optionTitle = self.unitIdTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:optionTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            self.unitId = self.unitIds[i];
        }];
        [alertController addAction:action];
    }

    UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"Input ID..."
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *inputAlert = [UIAlertController alertControllerWithTitle:@"Set Unit ID" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [inputAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Enter Unit ID";
            textField.text = self.unitId;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = inputAlert.textFields.firstObject;
            if (textField.text.length > 0) {
                NSMutableArray *newTitles = [self.unitIdTitles mutableCopy];
                NSMutableArray *newIds = [self.unitIds mutableCopy];
                [newTitles addObject:[NSString stringWithFormat:@"Custom %@", textField.text]];
                [newIds addObject:textField.text];

                self.unitIdTitles = [newTitles copy];
                self.unitIds = [newIds copy];
                self.unitId = textField.text;
            }
        }];
        [inputAlert addAction:cancelAction];
        [inputAlert addAction:okAction];
        [self presentViewController:inputAlert animated:YES completion:nil];
    }];
    [alertController addAction:inputAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    if ([alertController respondsToSelector:@selector(popoverPresentationController)]) {
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.sourceRect = self.view.bounds;
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showBtnTapped:(UIButton *)sender {
    NSLog(@"Show button was tapped!");
}

- (void)setUnitId:(NSString *)unitId {
    _unitId = unitId;
    [self loadAd];
}

- (void)loadAd {}

- (void)setNavigationBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"UnitId" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(unitid:) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [button.widthAnchor constraintEqualToConstant:60],
        [button.heightAnchor constraintEqualToConstant:40]
    ]];

    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnItem;
}

- (void)removeShowButton {
    if (self.showBtn) {
        [self.showBtn removeFromSuperview];
        self.showBtn = nil;
        NSLog(@"Show button removed");
    }
}

@end
