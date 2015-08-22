//
//  UIColor+CatToday.m
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import "UIColor+CatToday.h"

@implementation UIColor (CatToday)

+ (UIColor *)testRed { return [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.3]; }
+ (UIColor *)testBlue { return [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.3]; }
+ (UIColor *)testGreen { return [UIColor colorWithRed:0 green:1.0 blue:0 alpha:0.3]; }

//
+ (UIColor *)colorWithHex:(int)hex
{
	return [UIColor colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
						   green:((float)((hex & 0x00FF00) >>  8))/255.0
							blue:((float)((hex & 0x0000FF) >>  0))/255.0
						   alpha:alpha];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
	return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}


@end
