#import "LukiTwitterCell.h"


@implementation LukiTwitterCell {

	UIStackView *_horizontalStackView;
	UILabel *_accountLabel;
	UIImageView *_avatarImageView;
	UIImageView *_twitterAccessoryImageView;

}

static NSString *const kAccountString = @"Luki120\n@Lukii120";
static NSString *const kAccountUsernameString = @"@Lukii120";
static NSString *const kAvatarURLString = @"https://avatars.githubusercontent.com/u/74214115?v=4";

static NSDictionary *views;
static RueImageManager *rueImageManager;
static UIAlertController *alertController;

// ! Lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
	if(!self) return nil;

	if(!rueImageManager) rueImageManager = [RueImageManager new];

	[self _setupDictPropertiesForSpecifier: specifier];
	[self _setupUI];

	accountURL = [NSURL URLWithString:[@"https://twitter.com/" stringByAppendingString: kAccountUsernameString]];

	return self;

}

// ! Private

- (void)_setupDictPropertiesForSpecifier:(PSSpecifier *)specifier {

	NSMutableDictionary *dictProperties = [NSMutableDictionary new];
	[dictProperties setObject:@58 forKey: @"height"];
	[dictProperties setObject:@"LukiTwitterCell" forKey: @"id"];
	[dictProperties setObject:kAccountString forKey: @"account"];
	[dictProperties setObject:kAvatarURLString forKey: @"avatarUrl"];

	[specifier setProperties: dictProperties];

}


- (void)_setupUI {

	if(!_horizontalStackView) {
		_horizontalStackView = [UIStackView new];
		_horizontalStackView.spacing = 15;
		_horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview: _horizontalStackView];
	}

	if(!_avatarImageView) {
		_avatarImageView = [UIImageView new];
		_avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
		_avatarImageView.clipsToBounds = YES;
		_avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
		_avatarImageView.layer.cornerRadius = 20;
		[self _unleashImageFromURLString: kAvatarURLString];
		[_horizontalStackView addArrangedSubview: _avatarImageView];
	}

	if(!_accountLabel) {
		_accountLabel = [UILabel new];
		_accountLabel.numberOfLines = 0;
		_accountLabel.attributedText = [[NSMutableAttributedString alloc] initWithFullString:kAccountString subString: kAccountUsernameString];
		[_horizontalStackView addArrangedSubview: _accountLabel];
	}

	if(!_twitterAccessoryImageView) {
		_twitterAccessoryImageView = [UIImageView new];
		_twitterAccessoryImageView.frame = CGRectMake(0, 0, 15, 15);
		_twitterAccessoryImageView.image = [UIImage imageWithContentsOfFile: jbRootPath(@"/Library/PreferenceBundles/RuePrefs.bundle/Assets/Twitter.png")];
		_twitterAccessoryImageView.clipsToBounds = YES;
		_twitterAccessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.accessoryView = _twitterAccessoryImageView;
	}

	[self _layoutUI];

}


- (void)_layoutUI {

	views = @{
		@"superview": self.contentView,
		@"horizontalStackView": _horizontalStackView,
		@"avatarImageView": _avatarImageView
	};

	NSArray *formatStrings = @[
		@"H:|-15-[horizontalStackView]",
		@"H:[horizontalStackView(==111.5)]",
		@"H:[avatarImageView(==40)]",
		@"V:[avatarImageView(==40)]"
	];

	for(NSString *format in formatStrings) [self _setupConstraintsWithFormat: format];

	NSString *formatHorizontalStackViewCenterY = @"H:[superview]-(<=1)-[horizontalStackView]";

	[self _setupConstraintsWithFormat:formatHorizontalStackViewCenterY withOptions: NSLayoutFormatAlignAllCenterY];

}


- (void)_setupConstraintsWithFormat:(NSString *)format { [self _setupConstraintsWithFormat:format withOptions:0]; }
- (void)_setupConstraintsWithFormat:(NSString *)format withOptions:(NSLayoutFormatOptions)options {

	[NSLayoutConstraint activateConstraints:
		[NSLayoutConstraint constraintsWithVisualFormat:format options:options metrics:nil views:views]];

}


- (void)_unleashImageFromURLString:(NSString *)urlString {

	[rueImageManager fetchImageWithURLString:urlString completion:^(UIImage *image, NSError *error) {

		if(error || !image) {

			if(alertController) return;
			NSString *errorMessage = [NSString stringWithFormat: @"There was an error when trying to fetch the avatar image ⇝ %@", error.localizedDescription];

			alertController = [UIAlertController alertControllerWithTitle:@"Rue" message:errorMessage preferredStyle:UIAlertControllerStyleActionSheet];
			UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@":(" style:UIAlertActionStyleDefault handler:nil];

			[alertController addAction: dismissAction];

			[delegate lukiTwitterCell:self shouldPresentAlertController: alertController];
			return;

		}

		[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

			_avatarImageView.image = image;

		} completion:nil];

	}];

}

@end
