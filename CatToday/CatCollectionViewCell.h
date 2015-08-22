//
//  CatCollectionViewCell.h
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import "PFCollectionViewCell.h"

@interface CatCollectionViewCell : PFCollectionViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITextView *infoTextView;
@end
