//
//  MenuImage.h
//  MENU
//
//  Created by cjlin on 2015/6/17.
//
//

#import <Foundation/Foundation.h>
#import "CatTodayTimelineVC.h"

@interface MenuImage : NSObject
+ (MenuImage *)sharedManager;
- (void)clear;
- (void)loadHelperCellOfObject:(PFObject *)object
				needLoadInView:(BOOL)needLoadInView
				viewController:(CatTodayTimelineVC *)viewController;
@end
