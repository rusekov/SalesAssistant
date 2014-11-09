//
//  OrderViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Customer.h"
#import "StockItem.h"
#import "StaticCustomers.h"
#import "CustomerDetailViewController.h"
#import "Toast.h"

@interface OrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) Customer *currentCustomer;

@end
