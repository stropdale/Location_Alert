//
//  JSDLocationAlertViewController.h
//  LocationAlert
//
//  Created by Richard Stockdale on 27/02/2017.
//  Copyright © 2017 Junction Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDAlertContentView.h"
#import <MapKit/MapKit.h>

/**
 Delegate used by the JSDLocationAlertView to receive messages from the content view
 */
@protocol JSDLocationAlertViewControllerDelegate <NSObject>


/**
 The user had made a selection to be handled
 
 @param index Cancel = 0, Proceed = 1
 */
- (void) didSelectOptionAtIndex: (NSInteger) index;

@end

@interface JSDLocationAlertViewController : UIAlertController <JSDAlertContentViewDelegate>

@property (nonatomic, weak) NSObject <JSDLocationAlertViewControllerDelegate> *delegate;

+ (JSDLocationAlertViewController *) alertControllerWithTitle: (NSString *) title
                                                      message: (NSString *) message
                                                 andLocations: (NSArray <CLLocation *>*) locations;

+ (JSDLocationAlertViewController *) alertControllerWithTitle: (NSString *) title
                                            attributedMessage: (NSAttributedString *) message
                                                 andLocations: (NSArray <CLLocation *>*) locations;


// TODO
//- (void) showControllerWithAttributedTitle: (NSAttributedString *) title attributedMessage: (NSAttributedString *) message;

@end
