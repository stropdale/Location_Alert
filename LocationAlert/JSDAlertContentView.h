//
//  JSDAlertContentView.h
//  LocationAlert
//
//  Created by Richard Stockdale on 27/02/2017.
//  Copyright © 2017 Junction Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


/**
 Delegate used by the JSDLocationAlertView to receive messages from the content view
 */
@protocol JSDAlertContentViewDelegate <NSObject>


/**
 The user had made a selection to be handled

 @param index Cancel = 0, Proceed = 1
 */
- (void) didSelectOptionAtIndex: (NSInteger) index;

@end

@interface JSDAlertContentView : UIView <MKMapViewDelegate, CLLocationManagerDelegate>


/**
 Delegate for receiving information from the content view
 */
@property (nonatomic, weak) NSObject<JSDAlertContentViewDelegate> *delegate;


- (void) populateAlertWithMessage: (NSString *) message
                         andTitle: (NSString *) title
                     andLocations: (NSArray <CLLocation *>*) locations;

- (void) populateAlertWithAttributedMessage: (NSAttributedString *) message
                                   andTitle: (NSString *) title
                               andLocations: (NSArray <CLLocation *>*) locations;


/**
 Returns the height of the view sized for the content passed in after content has been added

 @return Height as a CGFloat
 */
- (CGFloat) getHeightOfContent;

@end
