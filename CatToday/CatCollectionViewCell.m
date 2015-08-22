//
//  CatCollectionViewCell.m
//  CatToday
//
//  Created by cjlin on 2015/8/22.
//  Copyright (c) 2015年 HackUC. All rights reserved.
//

#import "CatCollectionViewCell.h"
#import "UIColor+CatToday.h"
#import "Masonry.h"

@implementation CatCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.contentView.backgroundColor = [UIColor clearColor];

		//
		[self.contentView addSubview:self.nameLabel];
		[self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.contentView.mas_centerX);
			make.centerY.equalTo(self.contentView.mas_centerY);
		}];

		//
		self.imageView.backgroundColor = [UIColor whiteColor];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		self.imageView.clipsToBounds = YES;
		[self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.contentView.mas_centerX);
			make.top.equalTo(self.contentView.mas_top).offset(44);
			make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
			make.width.equalTo(self.imageView.mas_height);
		}];
	}
	return self;
}

- (UILabel *)nameLabel
{
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] init];
	}
	return _nameLabel;
}

@end
