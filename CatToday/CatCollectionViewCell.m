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
#define InfoSpacing 20.0

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.contentView.backgroundColor = [UIColor clearColor];

		//
		[self.contentView addSubview:self.nameLabel];
		[self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.imageView.mas_bottom).offset(20);
			make.centerX.equalTo(self.contentView.mas_centerX);
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

		//
		[self.contentView addSubview:self.infoTextView];
		[self.infoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self.contentView.mas_leading).offset(InfoSpacing);
			make.trailing.equalTo(self.contentView.mas_trailing).offset(-InfoSpacing);
			make.bottom.equalTo(self.contentView.mas_bottom).offset(-3*InfoSpacing);
			make.top.equalTo(self.nameLabel.mas_bottom).offset(InfoSpacing);
		}];
	}
	return self;
}

- (UIView *)faceView
{
	if (!_faceView) {
		_faceView = [[UIView alloc] init];
		_faceView.backgroundColor = [UIColor testRed];
	}
	return _faceView;
}

- (UILabel *)nameLabel
{
	if (!_nameLabel) {
		_nameLabel = [[UILabel alloc] init];
	}
	return _nameLabel;
}

- (UITextView *)infoTextView
{
	if (!_infoTextView) {
		_infoTextView = [[UITextView alloc] init];
		_infoTextView.backgroundColor = [UIColor clearColor];
		_infoTextView.selectable = NO;
		_infoTextView.editable = NO;
		_infoTextView.font = [UIFont systemFontOfSize:16];
		_infoTextView.textColor = [UIColor grayColor];
	}
	return _infoTextView;
}

@end
