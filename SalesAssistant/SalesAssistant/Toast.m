//
//  Toast.m
//  SalesAssistant
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//

#import "Toast.h"

@implementation Toast
{
    CGRect rect;
}

+ (Toast *)toastWithMessage:(NSString *)msg andColor : (UIColor*) color;
{
    Toast *t = [[Toast alloc] init];
    t.message = msg;
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:FONT_SIZE]};
    CGSize size = [msg sizeWithAttributes:attributes];
    if (size.width > screen.size.width)
    {
        size.width = screen.size.width;
    }
    
    CGRect rect = CGRectMake(0, 20, screen.size.width, size.height + TOP_BOTTOM_PADDING);
    
    t.label = [[UILabel alloc] initWithFrame:rect];
    t.label.text = msg;
    t.label.textColor = [UIColor whiteColor];
    t.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    t.label.textAlignment = NSTextAlignmentCenter;
    t.label.backgroundColor = color;
    
    return t;
    
}

- (void)showOnView:(UIView *)view
{
    [self.label setAlpha:0];
    [view addSubview:self.label];
    
    [UIView animateWithDuration:FADE_IN_DURATION
                     animations:^{
                         [self.label setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:FADE_OUT_DURATION
                                               delay:TIMEDELAY
                                             options:0
                                          animations:^{ [self.label setAlpha:0]; }
                                          completion:^(BOOL finished) {}
                          ];
                     }];
}

@end