//
//  UIColor+CatToday.h
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CatToday)
//
+ (UIColor *)testRed;
+ (UIColor *)testBlue;
+ (UIColor *)testGreen;

//
+ (UIColor *)colorWithHex:(int)hex;
+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;


@end
