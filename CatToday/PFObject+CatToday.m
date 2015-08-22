//
//  PFObject+CatToday.m
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import "PFObject+CatToday.h"
#import "Constants.h"

@implementation PFObject (CatToday)
- (NSString *)getName
{
	if (self[CAT_CLASS_KEY_NAME]) {
		return self[CAT_CLASS_KEY_NAME];
	}
	return @"";
}
@end
