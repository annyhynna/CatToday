//
//  TodayViewController.m
//  CatToday Widget
//
//  Created by HsuAnny on 8/22/15.
//  Copyright (c) 2015 HackUC. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "PrivateKey.h"
#import "Constants.h"
#import "PFObject+CatToday.h"

#import <Parse/Parse.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 100);
    // Do any additional setup after loading the view from its nib.

	[Parse setApplicationId:appID
				  clientKey:clKey];

	self.quoteLabel.text = @"didLoad";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	self.quoteLabel.text = @"456";

	PFQuery *query = [PFQuery queryWithClassName:CAT_CLASS];
	query.limit = 1;
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error && objects.count>0) {
			PFObject *obj = objects[0];
			self.quoteLabel.text = [obj getName];
		}
		else {
			self.quoteLabel.text = @"error";
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
