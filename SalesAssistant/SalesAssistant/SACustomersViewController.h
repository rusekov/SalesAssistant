//
//  CustomersViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACustomer.h"
#import "SADetailViewController.h"
#import "SAStaticCustomers.h"

@interface SACustomersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end
