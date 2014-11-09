//
//  OrderViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/5/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SACustomer.h"
#import "SAStockItem.h"
#import "SAStaticCustomers.h"
#import "SADetailViewController.h"
#import "SAToast.h"

@interface SAOrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) SACustomer *currentCustomer;

@end
