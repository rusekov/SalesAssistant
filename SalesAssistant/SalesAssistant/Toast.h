//
//  Toast.h
//  SalesAssistant
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 ILR. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define FONT_SIZE 14

#define LEFT_RIGHT_PADDING 20
#define TOP_BOTTOM_PADDING 15

#define FADE_IN_DURATION 0.5
#define FADE_OUT_DURATION 0.5
#define TIMEDELAY 1.5

@interface Toast : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UILabel *label;

+ (Toast *)toastWithMessage:(NSString *)msg andColor : (UIColor*) color;
- (void)showOnView:(UIView *)mainView;

@end