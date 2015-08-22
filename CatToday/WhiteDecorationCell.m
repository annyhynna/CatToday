//
//  WhiteDecorationCell.m
//  MENU
//
//  Created by cjlin on 2015/7/24.
//
//

#import "WhiteDecorationCell.h"
#import "UIColor+CatToday.h"
#import "Constants.h"
#import "Masonry.h"

@interface WhiteDecorationCell ()
@property (nonatomic, strong) UIView *backDecorationView;
@end

@implementation WhiteDecorationCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor mainPageBackground];
		[self setupDecorationView];
	}
	return self;
}

+ (NSString *)kind { return NSStringFromClass([self class]); }

#pragma mark - DecorationView
- (UIView *)backDecorationView
{
	if (!_backDecorationView) {
		_backDecorationView = [[UIView alloc] init];
		_backDecorationView.backgroundColor = [UIColor mainPageDecorationBackground];
		_backDecorationView.layer.cornerRadius = 5.0f;
		//_backDecorationView.layer.borderWidth = 1.0f;
		//_backDecorationView.layer.borderColor = [[UIColor mainPageDecorationStroke] CGColor];
	}
	return _backDecorationView;
}

- (void)setupDecorationView
{
	[self addSubview:self.backDecorationView];
	[self sendSubviewToBack:self.backDecorationView];
	[self.backDecorationView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(@0).offset(-DECORATION_MARGIN);
		make.leading.equalTo(@0).offset(DECORATION_MARGIN);
		make.top.equalTo(@0).offset(DECORATION_MARGIN);
		make.bottom.equalTo(@0).offset(-DECORATION_MARGIN);
	}];
}

@end
