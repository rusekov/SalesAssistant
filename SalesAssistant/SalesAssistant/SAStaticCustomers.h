//
//  StaticCustomers.h
//  SalesAssistant
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SACustomer.h"

@interface SAStaticCustomers : NSObject
@property (strong, nonatomic) NSMutableArray *listOfCustommers;

+ (SAStaticCustomers*) customers;

- (NSArray*) cities;

- (void) sortByNameCustomers;
- (void) sortByDateCustomers;
- (void) sortByTurnoverCustomers;

@end
