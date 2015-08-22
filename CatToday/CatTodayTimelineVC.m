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
#import "MenuImage.h"
#import "AppDelegate.h"
#import "Azure.h"

//pods
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "AFNetworking.h"
#import "Masonry.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface CatTodayTimelineVC ()
@property (nonatomic, strong) UILabel *networkView;
@end

@implementation CatTodayTimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self.collectionView registerClass:[CatCollectionViewCell class]
			forCellWithReuseIdentifier:cellIdentifier];

	[self uiSetting];

	// network status
	[self createNetworkStatusFrame];
	[self networkStatusMonitoring];

	//[self createNewCat];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(jumpToPhoto)
												 name:NSNotify_ObjectID
											   object:nil];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSNotify_ObjectID
												  object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self jumpToPhoto];
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

- (void)reloadCellOfObject:(PFObject *)object
{
	NSIndexPath *indexPath = [self indexPathForObject:object];
	//NSLog(@"%s %ld", __PRETTY_FUNCTION__, indexPath.item);
	if (indexPath) {
		[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
	}
	else {
#if DEBUG
		NSLog(@"indexPath not found at %s %@", __PRETTY_FUNCTION__, object.objectId);
#endif
	}
}

- (NSIndexPath *)indexPathForObject:(PFObject *)targetObject {
	for (int i = 0; i < self.objects.count; i++) {
		PFObject *object = [self.objects objectAtIndex:i];
		if ([object isEqualToObject:targetObject]) {
			return [NSIndexPath indexPathForRow:i inSection:0];
		}
	}

	return nil;
}

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
	// NSUInteger index = indexPath.item;
	//	NSLog(@"%s %lu %ld", __PRETTY_FUNCTION__, (unsigned long)index, (long)indexPath.row);

	CatCollectionViewCell *cell = (CatCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	cell.imageView.image = nil;
	cell.nameLabel.text = [object getName];
	cell.infoTextView.text = [object getInfo];

	if (object && [object objectForKey:CAT_CLASS_KEY_PHOTO]) {
		cell.imageView.file = [object objectForKey:CAT_CLASS_KEY_PHOTO];
		NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, NSStringFromClass(self.class), cell.imageView.file.url);
		[Azure azureFaceAPI:cell.imageView.file.url];

		// PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
		if ([cell.imageView.file isDataAvailable]) {
			[cell.imageView loadInBackground];
		}
		else {
//			[cell.imageView loadInBackground:^(UIImage *image, NSError *error) {
//				if (!error) {
//					NSLog(@"load file ok: %ld", indexPath.item);
//				}
//				else {
//					NSLog(@"load file fail: %ld %@", indexPath.item, error);
//				}
//			}];
			[[MenuImage sharedManager] loadHelperCellOfObject:object
											   needLoadInView:YES
											   viewController:self];
		}
	}

	return cell;
}

#pragma mark - jump to photo
- (void)jumpToPhoto
{
	NSString *objectID = [self getAppDelegateObjectID];
	if (objectID) {
		NSIndexPath *indexPath = [self indexPathForObjectID:objectID];
		if (indexPath) {
			[self.collectionView scrollToItemAtIndexPath:indexPath
										atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
												animated:NO];
		}
	}
}

- (NSIndexPath *)indexPathForObjectID:(NSString *)objectID {
	for (int i = 0; i < self.objects.count; i++) {
		PFObject *object = [self.objects objectAtIndex:i];
		if ([object.objectId isEqualToString:objectID]) {
			return [NSIndexPath indexPathForRow:i inSection:0];
		}
	}

	return nil;
}

- (NSString *)getAppDelegateObjectID
{
	return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).objectID;
}

#pragma mark - PFQueryCollectionViewController

- (void)objectsDidLoad:(NSError *)error {
	//NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, NSStringFromClass(self.class), self.objects);
	[super objectsDidLoad:error];

	[self jumpToPhoto];
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
	[query setCachePolicy:kPFCachePolicyCacheThenNetwork];

	return query;
}

#pragma mark - 
#pragma mark - Network
- (void)createNetworkStatusFrame
{
	[self.view addSubview:self.networkView];
	[self.networkView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view.mas_bottom);
		make.left.equalTo(@0);
		make.right.equalTo(@0);
		make.height.equalTo(@30);
	}];

}

- (UILabel *)networkView
{
	if (!_networkView) {
		_networkView = [[UILabel alloc] init];
		_networkView.text = @"No Internet";
		_networkView.textColor = [UIColor whiteColor];
		_networkView.textAlignment = NSTextAlignmentCenter;
		_networkView.backgroundColor = [UIColor blackColor];
		_networkView.hidden = YES;
		_networkView.alpha = 0.5;
	}
	return _networkView;
}

- (void)networkStatusMonitoring
{
	// -- Start monitoring network reachability (globally available) -- //
	[[AFNetworkReachabilityManager sharedManager] startMonitoring];

	[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		NSLog(@"Reachability changed: %s %@ %@", __PRETTY_FUNCTION__, NSStringFromClass(self.class), AFStringFromNetworkReachabilityStatus(status));

		switch (status) {
			case AFNetworkReachabilityStatusReachableViaWWAN:
			case AFNetworkReachabilityStatusReachableViaWiFi:
				// -- Reachable -- //
				NSLog(@"Reachable");
				self.networkView.hidden = YES;
				break;
			case AFNetworkReachabilityStatusNotReachable:
			default:
				// -- Not reachable -- //
				NSLog(@"Not Reachable");
				self.networkView.hidden = NO;
				break;
		}

	}];
}


@end
