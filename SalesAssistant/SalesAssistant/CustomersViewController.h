//
//  CustomersViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
#import "CustomerDetailViewController.h"
#import "StaticCustomers.h"

@interface CustomersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end
