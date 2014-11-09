//
//  SAValidator.m
//  SalesAssistant
//
//  Created by Admin on 11/9/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "SAValidator.h"

@implementation SAValidator

- (BOOL) isValidPhone:(NSString*) phoneString {
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneString length]);
    NSArray *matches = [detector matchesInString:phoneString options:0 range:inputRange];
    
    if ([matches count] == 0) {
        return NO;
    }
    
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL)isValidStringLength: (NSString*) string{
    BOOL result = NO;
    if (string.length > 3 && string.length < 30) {
        result = YES;
    }
    return result;
}

@end
