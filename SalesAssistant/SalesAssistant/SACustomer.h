//
//  Customer.h
//  SalesAssistant
//
//  Created by Admin on 11/4/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SACustomer : NSObject

@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *contactName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phoneNumber;
@property double turnover;
@property (strong, nonatomic) NSDate *dateOfLastUpdate;
@property double latitude;
@property double longitude;

@end
