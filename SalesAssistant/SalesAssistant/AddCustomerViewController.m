//
//  AddCustomerViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "AddCustomerViewController.h"

@interface AddCustomerViewController ()

@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UITextField *contactPerson;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;

@end

@implementation AddCustomerViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    double latitude;
    double longitude;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action Buttons
- (IBAction)addToPhonebook:(UIButton *)sender {
    NSLog(@"Pressed");
}

- (IBAction)getAddress:(UIButton *)sender {
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:
         @selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)save:(UIButton *)sender {
    
    UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"ADD NEW CUSTOMER" message:@"CONFIRM NEW CUSTOMER" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
    [allert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        Customer *customer = [[Customer alloc] init];
        customer.companyName = self.companyName.text;
        customer.contactName = self.contactPerson.text;
        customer.phoneNumber = self.phoneNumber.text;
        customer.city = self.city.text;
        customer.address = self.address.text;
        customer.dateOfLastUpdate = [NSDate date];
        customer.turnover = 0;
        customer.latitude = latitude;
        customer.longitude = longitude;
        
        [[[StaticCustomers customers] listOfCustommers] addObject:customer];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        latitude = currentLocation.coordinate.latitude;
        longitude = currentLocation.coordinate.longitude;
        
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                
                NSString *subAdress = (placemark.subThoroughfare) ? [NSString stringWithFormat:@"%@",placemark.subThoroughfare] : @"";
                NSString *address = (placemark.thoroughfare) ? [NSString stringWithFormat:@"%@",placemark.thoroughfare] : @"";
                NSString *town = (placemark.locality) ? [NSString stringWithFormat:@"%@",placemark.locality] : @"";
                self.address.text = [NSString stringWithFormat:@"%@ %@", subAdress, address];
                self.city.text = [NSString stringWithFormat:@"%@", town];
            } else {
                    NSLog(@"%@", error.debugDescription);
            }
        }];
    
    }
    [locationManager stopUpdatingLocation];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
