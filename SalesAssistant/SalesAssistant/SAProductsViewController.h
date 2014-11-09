//
//  ProductsViewController.h
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SAStockItem.h"
#import "SAToast.h"

@interface SAProductsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchResultsUpdating>

@end
