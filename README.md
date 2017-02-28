# Location_Alert
A UIAlertViewController that displays a map view and annotations.

# How to use

1. Open the demo project
2. Copy the 5 files located in the AlertDialogue Group to your application
3. Use as follows...

     ```objective-c
     CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:51.5074 longitude:0.1278];
     NSArray *testLocations = @[testLocation];
     
     JSDLocationAlertViewController *alert = [JSDLocationAlertViewController alertControllerWithTitle:titleString message:messageString andLocations:testLocations];
     alert.delegate = self;
     [self presentViewController:alert animated:YES completion:nil];
     ```
     
4. The delegate calls a single method giving the index of the selected button. 0 is cancel. 1 is proceed.
