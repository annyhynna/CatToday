//
//  CatTodayTimelineVC.m
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import "CatTodayTimelineVC.h"
#import "CatCollectionViewCell.h"

//pods
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface CatTodayTimelineVC ()

@end

@implementation CatTodayTimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {


	// NSUInteger index = indexPath.item;
	//	NSLog(@"%s %lu %ld", __PRETTY_FUNCTION__, (unsigned long)index, (long)indexPath.row);

	CatCollectionViewCell *catCell;

	catCell.imageView.image = nil;

	return catCell;
}





@end
