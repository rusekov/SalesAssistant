//
//  SAValidator.h
//  SalesAssistant
//
//  Created by Admin on 11/9/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAValidator : NSObject

- (BOOL) isValidPhone:(NSString*) phoneString;
- (BOOL)isValidStringLength: (NSString*) string;
@end
