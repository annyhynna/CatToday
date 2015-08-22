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
#import <ParseUI/ParseUI.h>

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *quoteTextView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 100);
    // Do any additional setup after loading the view from its nib.

	[Parse setApplicationId:appID
				  clientKey:clKey];

	NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	PFQuery *query = [PFQuery queryWithClassName:CAT_CLASS];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error && objects.count>0) {
			PFObject *obj = objects[arc4random() % objects.count];
			self.imageView.file = obj[CAT_CLASS_KEY_PHOTO];
			[self.imageView loadInBackground];
		}
		else {
			NSLog(@"%s %@ cat error", __PRETTY_FUNCTION__, NSStringFromClass(self.class));
		}
	}];

	PFQuery *queryQuote = [PFQuery queryWithClassName:QUOTE_CLASS];
	[queryQuote findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error && objects.count>0) {
			PFObject *obj = objects[arc4random() % objects.count];
            self.quoteTextView.text = obj[QUOTE_CLASS_KEY_NAME];
            self.authorLabel.text = obj[QUOTE_CLASS_KEY_AUTHOR];
		}
		else {
			NSLog(@"%s %@ quote error", __PRETTY_FUNCTION__, NSStringFromClass(self.class));
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
