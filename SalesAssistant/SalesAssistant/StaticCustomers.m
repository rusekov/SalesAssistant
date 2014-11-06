//
//  StaticCustomers.m
//  SalesAssistant
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "StaticCustomers.h"

@implementation StaticCustomers

+(StaticCustomers *)customers{
    
    static StaticCustomers *customers = nil;
    
    if (!customers) {
        customers = [[super allocWithZone:nil] init];
    }
    
    return customers;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self customers];
}

-(instancetype)init{
    self = [super init];
    
    if (self) {
        _listOfCustommers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray *)sortedCustomers{
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"companyName" ascending:YES];
    
    return [_listOfCustommers sortedArrayUsingDescriptors:@[sd1, sd2]];
}

-(NSArray *)cities{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    for (int i = 0; i<_listOfCustommers.count; i++) {
        Customer *cm = _listOfCustommers[i];
        
        [set addObject:cm.city];
    }
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    return [[set allObjects] sortedArrayUsingDescriptors:@[sd]];
}

@end
