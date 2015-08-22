//
//  MenuImage.m
//  MENU
//
//  Created by cjlin on 2015/6/17.
//
//

#import "MenuImage.h"
#import "PFObject+CatToday.h"
#import "AFNetworking.h"
#import "Constants.h"

#import <Parse/Parse.h>

@interface MenuImage ()
@property (nonatomic, strong) NSMutableDictionary *pfLoadHelperDic; //call PFFile download in early timing
@property (nonatomic, strong) NSMutableDictionary *pfLoadHelperLoadingDic; //pfLoadHelperDic loading indicator

@property (nonatomic, strong) NSMutableDictionary *thumbnailHelperDic; //call PFFile download in early timing

@end

@implementation MenuImage

#pragma mark - init
+ (MenuImage *)sharedManager
{
	//  Static local predicate must be initialized to 0
	static MenuImage *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[MenuImage alloc] initSingleton];
	});
	return sharedInstance;
}

- (id)init {
	// Forbid calls to –init or +new
	NSAssert(NO, @"Cannot create instance of Singleton");
	// You can return nil or [self initSingleton] here,
	// depending on how you prefer to fail.
	return nil;
}

// Real (private) init method
- (id)initSingleton {
	self = [super init];
	if (self = [super init]) {
		// Init code
	}
	return self;
}

#pragma mark - getter
- (NSMutableDictionary *)pfLoadHelperDic {
	if (!_pfLoadHelperDic) {
		_pfLoadHelperDic = [[NSMutableDictionary alloc] initWithCapacity:30];
	}
	return _pfLoadHelperDic;
}

- (NSMutableDictionary *)pfLoadHelperLoadingDic
{
	if (!_pfLoadHelperLoadingDic) {
		_pfLoadHelperLoadingDic = [[NSMutableDictionary alloc] initWithCapacity:30];
	}
	return _pfLoadHelperLoadingDic;
}

- (NSMutableDictionary *)thumbnailHelperDic {
	if (!_thumbnailHelperDic) {
		_thumbnailHelperDic = [[NSMutableDictionary alloc] initWithCapacity:30];
	}
	return _thumbnailHelperDic;
}

#pragma mark - 
- (void)clear
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	[self.pfLoadHelperDic removeAllObjects];
	[self.pfLoadHelperLoadingDic removeAllObjects];
	[self.thumbnailHelperDic removeAllObjects];
}

- (void)loadHelperCellOfObject:(PFObject *)object
				needLoadInView:(BOOL)needLoadInView
				viewController:(CatTodayTimelineVC *)viewController
{
	if (!object.objectId) return;

	PFFile *pfFile = self.pfLoadHelperDic[object.objectId];
	if (!pfFile && [object objectForKey:CAT_CLASS_KEY_PHOTO]) {
		pfFile = [object objectForKey:CAT_CLASS_KEY_PHOTO];
		self.pfLoadHelperDic[object.objectId] = pfFile;
	}

	if ([pfFile isDataAvailable]){
		if (needLoadInView) {
			//NSLog(@"%s image available load into view now", __PRETTY_FUNCTION__);
			[viewController reloadCellOfObject:object];
		}
		else {
			//NSLog(@"%s image available and do nothing", __PRETTY_FUNCTION__);
		}
	}
	else if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
		NSLog(@"%s No Internet", __PRETTY_FUNCTION__);
	}
	else if (![pfFile isDataAvailable] && (!self.pfLoadHelperLoadingDic[object.objectId] || [self.pfLoadHelperLoadingDic[object.objectId] boolValue]==NO)) {
		//NSLog(@"%s start loading %@ %@", __PRETTY_FUNCTION__, object.shopName, object.dishName);
		self.pfLoadHelperLoadingDic[object.objectId] = @(YES);
		[pfFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
			self.pfLoadHelperLoadingDic[object.objectId] = @(NO);
			//NSIndexPath *indexPath = [viewController indexPathForObject:object];
			if (!error) {
				//NSLog(@"%@ helper load file ok %lu %@ %@ %@", [self class], indexPath.item, object.shopName, object.dishName, object.photoDescription);
				if (needLoadInView) {
					[viewController reloadCellOfObject:object];
				}
			}
			else {
				//NSLog(@"%@ helper load file fail %lu %@ %@ %@ %@", [self class], indexPath.item, object.shopName, object.dishName, object.photoDescription, error);

				[self loadHelperCellOfObject:object needLoadInView:needLoadInView viewController:viewController];
			}
		}];
	}
	else if ([self.pfLoadHelperLoadingDic[object.objectId] boolValue]==YES) {
		//NSLog(@"%s object is downloading", __PRETTY_FUNCTION__);
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self loadHelperCellOfObject:object needLoadInView:needLoadInView viewController:viewController];
		});
	}
	else {
		//NSLog(@"%s", __PRETTY_FUNCTION__);
		NSAssert(FALSE, @"weird");
	}
}

@end
