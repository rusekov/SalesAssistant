//
//  StaticCustomers.h
//  SalesAssistant
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface StaticCustomers : NSObject
@property (strong, nonatomic) NSMutableArray *listOfCustommers;

+ (StaticCustomers*) customers;

- (NSArray*) cities;

- (NSArray*) sortedCustomers;

@end
