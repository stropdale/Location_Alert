//
//  ViewController.m
//  LocationAlert
//
//  Created by Richard Stockdale on 27/02/2017.
//  Copyright © 2017 Junction Seven. All rights reserved.
//

#import "ViewController.h"
#import "JSDLocationAlertViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)showAlert:(id)sender {
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:51.5074 longitude:0.1278];
    NSArray *testLocations = @[testLocation];
    
    JSDLocationAlertViewController *alert = [JSDLocationAlertViewController alertControllerWithTitle:@"Hello hello hello" message:@"This is a demo alert controller. with a map pin located in London, England." andLocations:testLocations];
    
    alert.delegate = self;
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) didSelectOptionAtIndex: (NSInteger) index {
    NSLog(@"Selected : %ld", (long)index);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
