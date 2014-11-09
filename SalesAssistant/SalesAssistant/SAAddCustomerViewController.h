//
//  AddCustomerViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SACustomer.h"
#import "SAStaticCustomers.h"

@interface SAAddCustomerViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@end
