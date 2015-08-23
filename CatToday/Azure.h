//
//  Azure.h
//  CatToday
//
//  Created by cjlin on 2015/8/23.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Azure : NSObject
+ (void)azureFaceAPI:(NSString *)imageUrl withBlock:(void (^)(NSMutableDictionary *json))block;

@property (nonatomic, strong) NSMutableDictionary *faceRectDic;
- (NSString *)faceRectForID:(NSString *)objectID;
- (void)setRect:(NSString *)rect withID:(NSString *)objectID;

@end
