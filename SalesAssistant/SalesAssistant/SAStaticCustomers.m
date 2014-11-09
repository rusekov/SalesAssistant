//
//  StaticCustomers.m
//  SalesAssistant
//
//  Created by Admin on 11/6/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "SAStaticCustomers.h"
#import "AppDelegate.h"

@implementation SAStaticCustomers

+(SAStaticCustomers *)customers{
    
    static SAStaticCustomers *customers = nil;
    
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
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSManagedObject *matches = nil;
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if ([objects count] == 0)
        {
            NSLog(@"No matches");
        }
        else
        {
            for (int i = 0; i < [objects count]; i++)
            {
                matches = objects[i];
                SACustomer *customer = [[SACustomer alloc] init];
                customer.companyName = [matches valueForKey:@"companyName"];
                customer.contactName = [matches valueForKey:@"contactName"];
                customer.phoneNumber = [matches valueForKey:@"phoneNumber"];
                customer.city = [matches valueForKey:@"city"];
                customer.address = [matches valueForKey:@"address"];
                customer.dateOfLastUpdate = [matches valueForKey:@"dateOfLastUpdate"];
                customer.turnover = [[matches valueForKey:@"turnover"] doubleValue];
                customer.latitude = [[matches valueForKey:@"latitude"] doubleValue];
                customer.longitude = [[matches valueForKey:@"longitude"] doubleValue];
                
                [_listOfCustommers addObject:customer];
            }
        }
    }
    
    return self;
}

#pragma mark Sorting Methods

-(void)sortByNameCustomers{
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"companyName" ascending:YES];
    
    NSArray *ar = [[NSArray alloc]initWithArray:[_listOfCustommers sortedArrayUsingDescriptors:@[sd1, sd2]]];
    [_listOfCustommers removeAllObjects];
    [_listOfCustommers addObjectsFromArray:ar];
}

-(void)sortByDateCustomers{
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"dateOfLastUpdate" ascending:YES];
    
    NSArray *ar = [[NSArray alloc]initWithArray:[_listOfCustommers sortedArrayUsingDescriptors:@[sd1, sd2]]];
    [_listOfCustommers removeAllObjects];
    [_listOfCustommers addObjectsFromArray:ar];
}

-(void)sortByTurnoverCustomers{
    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"city" ascending:YES];
    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"turnover" ascending:NO];
    
    NSArray *ar = [[NSArray alloc]initWithArray:[_listOfCustommers sortedArrayUsingDescriptors:@[sd1, sd2]]];
    [_listOfCustommers removeAllObjects];
    [_listOfCustommers addObjectsFromArray:ar];
}

#pragma mark Extract Cities method

-(NSArray *)cities{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    
    for (int i = 0; i<_listOfCustommers.count; i++) {
        SACustomer *cm = _listOfCustommers[i];
        
        [set addObject:cm.city];
    }
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
    return [[set allObjects] sortedArrayUsingDescriptors:@[sd]];
}

@end
