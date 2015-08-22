//
//  CatTodayTimelineVC.m
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import "CatTodayTimelineVC.h"
#import "CatCollectionViewCell.h"
#import "Constants.h"
#import "PFObject+CatToday.h"
#import "UIColor+CatToday.h"
#import "Constants.h"

//pods
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

static NSString *cellIdentifier = @"cellIdentifier";

@interface CatTodayTimelineVC ()

@end

@implementation CatTodayTimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self.collectionView registerClass:[CatCollectionViewCell class]
			forCellWithReuseIdentifier:cellIdentifier];

	[self uiSetting];
	//[self createNewCat];
}

- (void)uiSetting
{
	self.collectionView.backgroundColor = [UIColor mainPageBackground];
	self.paginationEnabled = NO;
	self.pullToRefreshEnabled = NO;
	((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).scrollDirection = UICollectionViewScrollDirectionHorizontal;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}

	if ([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)]) {
		self.extendedLayoutIncludesOpaqueBars = NO;
	}

	if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
}

- (void)createNewCat
{
	PFObject *cat = [PFObject objectWithClassName:CAT_CLASS];
	[cat setObject:@"kitty" forKey:CAT_CLASS_KEY_NAME];

	UIImage *catPhoto = [UIImage imageNamed:@"catDemo"];
	NSData *data = UIImagePNGRepresentation(catPhoto);
	[cat setObject:[PFFile fileWithData:data] forKey:CAT_CLASS_KEY_PHOTO];
	[cat saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegateFlowLayout
// comment and move to collectionViewLayout using itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize size = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
	return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return MainPage_Item_Spacing;
}

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
	// NSUInteger index = indexPath.item;
	//	NSLog(@"%s %lu %ld", __PRETTY_FUNCTION__, (unsigned long)index, (long)indexPath.row);

	CatCollectionViewCell *cell = (CatCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.imageView.image = nil;
	cell.nameLabel.text = [object getName];

	if (object && [object objectForKey:CAT_CLASS_KEY_PHOTO]) {
		cell.imageView.file = [object objectForKey:CAT_CLASS_KEY_PHOTO];

		// PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
		if ([cell.imageView.file isDataAvailable]) {
			[cell.imageView loadInBackground];
		}
		else {
			[cell.imageView loadInBackground:^(UIImage *image, NSError *error) {
				if (!error) {
					NSLog(@"load file ok: %ld", indexPath.item);
				}
				else {
					NSLog(@"load file fail: %ld %@", indexPath.item, error);
				}
			}];
		}
	}

	return cell;
}

#pragma mark - PFQueryCollectionViewController

- (void)objectsDidLoad:(NSError *)error {
	NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, NSStringFromClass(self.class), self.objects);
	[super objectsDidLoad:error];
}

- (PFQuery *)queryForCollection {
	NSLog(@"%s %@", __PRETTY_FUNCTION__, NSStringFromClass(self.class));
	if (![PFUser currentUser]) {
		PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
		[query setLimit:0];
		return query;
	}

	PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
	[query orderByDescending:@"createdAt"];

	// A pull-to-refresh should always trigger a network request.
	[query setCachePolicy:kPFCachePolicyNetworkOnly];

	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	//
	// If there is no network connection, we will hit the cache first.
	if (self.objects.count == 0) {
		[query setCachePolicy:kPFCachePolicyCacheThenNetwork];
	}

	return query;
}



@end
