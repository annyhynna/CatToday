//
//  MenuNaviVC.m
//  MENU
//
//  Created by cjlin on 2015/4/20.
//
//

#import "WhiteNaviVC.h"
#import "UIColor+CatToday.h"
//#import "UINavigationBar+CustomHeight.h"

@interface WhiteNaviVC ()

@end

@implementation WhiteNaviVC

- (void)viewDidLoad {
    [super viewDidLoad];

	[self colorStatusBar];

//	[self.navigationBar setHeight:47.0f];
//	UIImage *navBG = [UIImage imageNamed:@"IMG_navbar"];
 //   [self.navigationBar setBackgroundImage:[navBG resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch]
//												  forBarMetrics:UIBarMetricsDefault];
    //[self.navigationBar setBackgroundImage:navBG forBarMetrics:UIBarMetricsDefault];
//	self.navigationBar.translucent = YES;
	//[self.navigationBar setBarTintColor:[UIColor colorWithRed:0.859 green:0.714 blue:0.329 alpha:1]];
    [self.navigationBar setBarTintColor:[UIColor navBar]];
    [self.navigationBar setBackgroundColor:[UIColor navBar]];
    //[self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}

- (void)colorStatusBar
{
	UIView *addStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
	addStatusBar.backgroundColor = [UIColor statusBarColor];
	[self.view addSubview:addStatusBar];
//	[addStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.top.equalTo(@0);
//		make.leading.equalTo(@0);
//		make.trailing.equalTo(@0);
//		make.height.equalTo(@20);
//	}];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)fadingPushViewController:(UIViewController *)viewController
{
	CATransition* transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
	//transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
	[self.view.layer addAnimation:transition forKey:nil];
	[self pushViewController:viewController animated:NO];
}

@end
