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

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSArray <CLLocation *> *pinLocations;

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
    [self startGettingLocation];
    [self setMessageYBasedOnTitleHeight:[self calculateHeightOfTitle:title]];
    self.messageLabel.text = message;
    [self updateLayout];
}

- (void) populateAlertWithAttributedMessage: (NSAttributedString *) message
                                   andTitle: (NSString *) title
                               andLocations: (NSArray <CLLocation *>*) locations {
    [self addMapAnnotations:locations];
    [self startGettingLocation];
    [self setMessageYBasedOnTitleHeight:[self calculateHeightOfTitle:title]];
    self.messageLabel.attributedText = message;
    [self updateLayout];
}

#pragma mark - Locations

- (void) addMapAnnotations: (NSArray <CLLocation *>*) locations {
    if (locations && locations.count) {
        self.pinLocations = locations;
        
        for (CLLocation *location in locations) {
            
            // Add the pins
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
    }
}

- (void) zoomToVenueAnnotation {
    if (self.pinLocations && self.pinLocations.count) {
        CLLocation *location = self.pinLocations.lastObject;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
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

#pragma mark - Mapping

- (void) startGettingLocation {
    if ([self.locationManager respondsToSelector:@selector(requestLocation)]) {
        // Use this method to make the call once
        [self.locationManager requestLocation];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark <MKMapViewDelegate> methods

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    
//    
//    
//}

#pragma mark <CLLocationManagerDelegate> methods

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Zoom to show the user and the pin
    // Be a little lazy and just use the first venue location we are passed
    
    if (self.pinLocations && self.pinLocations.count) {
        CLLocation *venue = self.pinLocations.firstObject;
        CLLocationCoordinate2D venue2D = venue.coordinate;
        
        CLLocation* currentLoc = [locations firstObject];
        CLLocationCoordinate2D currentLoc2D = currentLoc.coordinate;
        
        MKMapPoint currentPoint = MKMapPointForCoordinate(currentLoc2D);
        MKMapPoint venuePoint = MKMapPointForCoordinate(venue2D);
        
        MKMapRect currentPointRect = MKMapRectMake(currentPoint.x, currentPoint.y, 0, 0);
        MKMapRect venuePointRect = MKMapRectMake(venuePoint.x, venuePoint.y, 0, 0);
        
        MKMapRect zoomRect = MKMapRectUnion(currentPointRect, venuePointRect);
        MKMapRect unionRectThatFits = [self.mapView mapRectThatFits:zoomRect];
        
        [self.mapView setVisibleMapRect:unionRectThatFits edgePadding:UIEdgeInsetsMake(10, 10, 10, 10) animated:YES];
        
        [self.locationManager stopUpdatingLocation];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
    
    // If we have an error, just zoom in on the venue
    [self zoomToVenueAnnotation];
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
        _mapView.delegate = self;
        _mapView.zoomEnabled = NO;
        _mapView.scrollEnabled = NO;
        _mapView.userInteractionEnabled = NO;
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
    }
    return self;
}

- (void) dealloc {
    [self.locationManager stopUpdatingLocation];
}

- (void) loadAndAddView {
    [[NSBundle mainBundle] loadNibNamed:@"JSDAlertContentView" owner:self options:nil];
    _xibView.frame = self.frame;
    [self addSubview:_xibView];
}



@end
