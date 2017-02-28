//
//  JSDAlertContentView.m
//  LocationAlert
//
//  Created by Richard Stockdale on 27/02/2017.
//  Copyright © 2017 Junction Seven. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "JSDAlertContentView.h"

@interface JSDAlertContentView ()

@property (strong, nonatomic) IBOutlet JSDAlertContentView *xibView;
@property (weak, nonatomic) IBOutlet UIView *leftView; // Used to work out height

// UI

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelDistanceToTopConstraint;


@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;


@end

@implementation JSDAlertContentView

static CGFloat titleLabelWidth = 228.0;

#pragma mark - Population

- (void) populateAlertWithMessage: (NSString *) message
                         andTitle: (NSString *) title
                     andLocations: (NSArray <CLLocation *>*) locations {
    [self addMapAnnotations:locations];
    [self setMessageYBasedOnTitleHeight:[self calculateHeightOfTitle:title]];
    self.messageLabel.text = message;
    [self updateLayout];
}

- (void) populateAlertWithAttributedMessage: (NSAttributedString *) message
                                   andTitle: (NSString *) title
                               andLocations: (NSArray <CLLocation *>*) locations {
    [self addMapAnnotations:locations];
    [self setMessageYBasedOnTitleHeight:[self calculateHeightOfTitle:title]];
    self.messageLabel.attributedText = message;
    [self updateLayout];
}

#pragma mark - Locations

- (void) addMapAnnotations: (NSArray <CLLocation *>*) locations {
    if (locations && locations.count) {
        MKMapRect zoomRect = MKMapRectNull;
        for (CLLocation *location in locations) {
            
            // Add the pins
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = location.coordinate;
            [self.mapView addAnnotation:annotation];
            
            // Work out the zoom rect, but dont use it right now as we will only use the last
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        
        // Zoom in on the last item
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
        
    }
}

#pragma mark - Interaction

- (IBAction)cancelTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOptionAtIndex:)]) {
        [self.delegate didSelectOptionAtIndex:0];
    }
}

- (IBAction)proceedTapped:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectOptionAtIndex:)]) {
        [self.delegate didSelectOptionAtIndex:1];
    }
}

#pragma mark - Layout Helpers

- (void) setMessageYBasedOnTitleHeight: (CGFloat) titleHeight {
    self.messageLabelDistanceToTopConstraint.constant = (27.0 + titleHeight);
    [self updateLayout];
}

- (CGFloat) calculateHeightOfTitle: (NSString *) titleText {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleLabelWidth, 0)];
    label.text = titleText;
    
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
    
}

#pragma mark - LifeCycle

- (void) updateLayout {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (CGFloat) getHeightOfContent {
    CGFloat height = (self.leftView.frame.origin.y + self.leftView.frame.size.height);
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadAndAddView];
    }
    return self;
}

- (void) loadAndAddView {
    [[NSBundle mainBundle] loadNibNamed:@"JSDAlertContentView" owner:self options:nil];
    _xibView.frame = self.frame;
    [self addSubview:_xibView];
}



@end
