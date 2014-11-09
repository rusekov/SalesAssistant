//
//  AddCustomerViewController.m
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "SAAddCustomerViewController.h"
#import "AppDelegate.h"
#import "SAValidator.h"

@interface SAAddCustomerViewController ()

@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UITextField *contactPerson;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *address;

@end

@implementation SAAddCustomerViewController{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    double latitude;
    double longitude;
    SAValidator *validator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    validator = [[SAValidator alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark KeyBoard Resign Methods

-(void) resignKeyboard{
    [self.companyName resignFirstResponder];
    [self.contactPerson resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.city resignFirstResponder];
    [self.address resignFirstResponder];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignKeyboard];
    return NO;
}

#pragma mark Action Buttons
- (IBAction)addToPhonebook:(UIButton *)sender {

    NSString *venueName = self.contactPerson.text;
    NSString *venuePhone = self.phoneNumber.text;
    NSString *venueOrganization = self.companyName.text;

    [self resignKeyboard];
    
    if ([validator isValidStringLength:venueName] && [validator isValidPhone:venuePhone]) {
    
        ABRecordRef person = ABPersonCreate();
        
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef) venueName, NULL);
        ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFStringRef) venueOrganization, NULL);

        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        NSArray *venuePhoneNumbers = [venuePhone componentsSeparatedByString:@" or "];
        for (NSString *venuePhoneNumberString in venuePhoneNumbers)
            ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFStringRef) venuePhoneNumberString, kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
        
        ABUnknownPersonViewController *controller = [[ABUnknownPersonViewController alloc] init];
    
        controller.displayedPerson = person;
        controller.allowsAddingToAddressBook = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    
        CFRelease(person);
    } else {
        UIAlertView *noContact = [[UIAlertView alloc] initWithTitle:@"ERROR SAVING CONTACT" message:@"Incorrect name or phone number!" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
        [noContact show];
    }
}

- (IBAction)getAddress:(UIButton *)sender {
    [self resignKeyboard];
    
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
    
    if ([self isValidCustommer]) {
    UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"ADD NEW CUSTOMER" message:@"CONFIRM NEW CUSTOMER" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
    [allert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self addNewCutomer];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark Add new Customer Procedure

-(void)badData:(NSString*) text{
    
    UIAlertView *allert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Incorect %@",text] message:@"PLEASE ENTER PROPER DATA" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [allert show];
}

-(BOOL)isValidCustommer{
    BOOL result = NO;
    if (![validator isValidStringLength:self.companyName.text]) {
        [self badData:@"Company Name"];
    }
    else if (![validator isValidStringLength:self.contactPerson.text]){
        [self badData:@"Contact Person"];
    }
    else if (![validator isValidPhone:self.phoneNumber.text]){
        [self badData:@"Phone Number"];
    }
    else if (![validator isValidStringLength:self.city.text]){
        [self badData:@"City"];
    }
    else if (![validator isValidStringLength:self.address.text]){
        [self badData:@"Address"];
    }
    else{
        result = YES;
    }
    return result;
}

-(void)addNewCutomer{
        
        SACustomer *customer = [[SACustomer alloc] init];
        customer.companyName = self.companyName.text;
        customer.contactName = self.contactPerson.text;
        customer.phoneNumber = self.phoneNumber.text;
        customer.city = self.city.text;
        customer.address = self.address.text;
        customer.dateOfLastUpdate = [NSDate date];
        customer.turnover = 0;
        customer.latitude = latitude;
        customer.longitude = longitude;
    
        [[[SAStaticCustomers customers] listOfCustommers] addObject:customer];
    
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSManagedObject *newCustomer;
        newCustomer = [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:context];
        [newCustomer setValue: customer.address forKey:@"address"];
        [newCustomer setValue: customer.city forKey:@"city"];
        [newCustomer setValue: customer.companyName forKey:@"companyName"];
        [newCustomer setValue: customer.contactName forKey:@"contactName"];
        [newCustomer setValue: customer.dateOfLastUpdate forKey:@"dateOfLastUpdate"];
        [newCustomer setValue: [NSNumber numberWithDouble:customer.latitude] forKey:@"latitude"];
        [newCustomer setValue: [NSNumber numberWithDouble:customer.longitude] forKey:@"longitude"];
        [newCustomer setValue: customer.phoneNumber forKey:@"phoneNumber"];
        [newCustomer setValue: [NSNumber numberWithDouble:customer.turnover] forKey:@"turnover"];
    
        NSError *error;
        [context save:&error];
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

#pragma mark phone number validator

@end
