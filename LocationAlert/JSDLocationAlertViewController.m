//
//  JSDLocationAlertViewController.m
//  LocationAlert
//
//  Created by Richard Stockdale on 27/02/2017.
//  Copyright © 2017 Junction Seven. All rights reserved.
//

#import "JSDLocationAlertViewController.h"
#import "JSDAlertContentView.h"

@interface JSDLocationAlertViewController ()


@property (nonatomic, strong) JSDAlertContentView * contentView;
@end

@implementation JSDLocationAlertViewController

static CGFloat alertWidth = 270.0;

#pragma mark - <JSDAlertContentViewDelegate> methods

- (void) didSelectOptionAtIndex: (NSInteger) index {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Pass on the message to the delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOptionAtIndex:)]) {
        [self.delegate didSelectOptionAtIndex:index];
    }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init

+ (JSDLocationAlertViewController *) alertControllerWithTitle: (NSString *) title {
    // 1. Create a basic alert
    JSDLocationAlertViewController *alert = [JSDLocationAlertViewController alertControllerWithTitle:title
                                                                                             message:nil
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    // 2. Add the view
    alert.view.clipsToBounds = YES;
    CGRect contentFrame = CGRectMake(0, 0, 270, 400);
    alert.contentView = [[JSDAlertContentView alloc] initWithFrame:contentFrame];
    CGFloat height = [alert.contentView getHeightOfContent];
    alert.contentView.frame = CGRectMake(0, 0, 270, height);
    [alert.view addSubview:alert.contentView];
    
    alert.contentView.delegate = alert;
    
    return alert;
}

+ (JSDLocationAlertViewController *) alertControllerWithTitle: (NSString *) title
                                                      message: (NSString *) message
                                                 andLocations: (NSArray <CLLocation *>*) locations {
    
    JSDLocationAlertViewController * alert = [self alertControllerWithTitle:title];

    [alert.contentView populateAlertWithMessage:message andTitle:title andLocations:locations];
    
    // Size for the content
    CGFloat height = [alert.contentView getHeightOfContent];
    alert.contentView.frame = CGRectMake(0, 0, alertWidth, height);
    [alert.view addSubview:alert.contentView];
    
    [alert.view addConstraint:[NSLayoutConstraint constraintWithItem:alert.view
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute: NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:height]];
    
    
    return alert;
}

+ (JSDLocationAlertViewController *) alertControllerWithTitle: (NSString *) title
                                            attributedMessage: (NSAttributedString *) message
                                                 andLocations: (NSArray <CLLocation *>*) locations {
    JSDLocationAlertViewController * alert = [self alertControllerWithTitle:title];
    [alert.contentView populateAlertWithAttributedMessage:message andTitle:title andLocations:locations];
    
    // Size for the content
    
    CGFloat height = [alert.contentView getHeightOfContent];
    alert.contentView.frame = CGRectMake(0, 0, alertWidth, height);
    [alert.view addSubview:alert.contentView];
    
    [alert.view addConstraint:[NSLayoutConstraint constraintWithItem:alert.view
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute: NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:height]];
    
    return alert;
}



@end
