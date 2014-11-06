//
//  CustomerDetailViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Customer.h"
#import "OrderViewController.h"


@interface CustomerDetailViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) Customer *currentCustomer;

@end
