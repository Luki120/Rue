#import "LukiTwitterCell.h"


@implementation LukiTwitterCell {

	UIStackView *horizontalStackView;
	UIStackView *verticalStackView;
	UILabel *accountLabel;
	UILabel *accountUsernameLabel;
	UIImageView *avatarImageView;
	UIImageView *twitterAccessoryImageView;

}

static NSString *const kAccountNameString = @"Luki120";
static NSString *const kAccountUsernameString = @"Lukii120";
static NSString *const kAvatarURLString = @"https://avatars.githubusercontent.com/u/74214115?v=4";

static NSDictionary *views;
static RueImageManager *rueImageManager;
static UIAlertController *alertController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {

	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
	if(!self) return nil;

	if(!rueImageManager) rueImageManager = [RueImageManager new];

	[self setupDictPropertiesForSpecifier: specifier];
	[self setupUI];

	accountURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", kAccountUsernameString]];

	return self;

}


- (void)setupDictPropertiesForSpecifier:(PSSpecifier *)specifier {

	NSMutableDictionary *dictProperties = [NSMutableDictionary new];
	[dictProperties setObject:@58 forKey: @"height"];
	[dictProperties setObject:@"LukiTwitterCell" forKey: @"id"];
	[dictProperties setObject:kAccountNameString forKey: @"accountName"];
	[dictProperties setObject:kAccountUsernameString forKey: @"accountUsername"];
	[dictProperties setObject:kAvatarURLString forKey: @"avatarUrl"];

	[specifier setProperties: dictProperties];

}


- (void)setupUI {

	if(!horizontalStackView) {
		horizontalStackView = [self createStackViewWithAxis:UILayoutConstraintAxisHorizontal withSpacing: 15];
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.contentView addSubview: horizontalStackView];
	}

	if(!avatarImageView) {
		avatarImageView = [UIImageView new];
		avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
		avatarImageView.clipsToBounds = YES;
		avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
		avatarImageView.layer.cornerRadius = 20;
		[self unleashImageFromURLString: kAvatarURLString];
		[horizontalStackView addArrangedSubview: avatarImageView];
	}

	if(!verticalStackView) {
		verticalStackView = [self createStackViewWithAxis:UILayoutConstraintAxisVertical withSpacing: 2.5];
		[horizontalStackView addArrangedSubview: verticalStackView];
	}

	if(!accountLabel)
		accountLabel = [self createLabelWithText:kAccountNameString fontSize:16 textColor:UIColor.labelColor];

	if(!accountUsernameLabel) {
		accountUsernameLabel = [self createLabelWithText:
			[NSString stringWithFormat: @"@%@", kAccountUsernameString]
			fontSize:11
			textColor:UIColor.secondaryLabelColor
		];	
	}

	if(!twitterAccessoryImageView) {
		twitterAccessoryImageView = [UIImageView new];
		twitterAccessoryImageView.frame = CGRectMake(0, 0, 15, 15);
		twitterAccessoryImageView.image = [UIImage imageWithContentsOfFile: @"/Library/PreferenceBundles/RuePrefs.bundle/Assets/Twitter.png"];
		twitterAccessoryImageView.clipsToBounds = YES;
		twitterAccessoryImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.accessoryView = twitterAccessoryImageView;
	}

	[self layoutUI];

}


- (void)layoutUI {

	views = @{
		@"superview": self.contentView,
		@"horizontalStackView": horizontalStackView,
		@"avatarImageView": avatarImageView
	};

	NSArray *formatStrings = @[
		@"H:|-15-[horizontalStackView]",
		@"H:[avatarImageView(==40)]",
		@"V:[avatarImageView(==40)]"
	];

	for(NSString *format in formatStrings) [self setupConstraintsWithFormat: format];

	NSString *formatHorizontalStackViewCenterY = @"H:[superview]-(<=1)-[horizontalStackView]";

	[self setupConstraintsWithFormat:formatHorizontalStackViewCenterY withOptions: NSLayoutFormatAlignAllCenterY];

}


- (void)setupConstraintsWithFormat:(NSString *)format { [self setupConstraintsWithFormat:format withOptions:0]; }
- (void)setupConstraintsWithFormat:(NSString *)format withOptions:(NSLayoutFormatOptions)options {

	[NSLayoutConstraint activateConstraints:
		[NSLayoutConstraint constraintsWithVisualFormat:format options:options metrics:nil views:views]];

}


- (void)unleashImageFromURLString:(NSString *)urlString {

	[rueImageManager fetchImageWithURLString:urlString completion:^(UIImage *image, NSError *error) {

		if(error || !image) {

			if(alertController) return;
			NSString *errorMessage = [NSString stringWithFormat: @"There was an error when trying to fetch the avatar image ⇝ %@", error.localizedDescription];

			alertController = [UIAlertController alertControllerWithTitle:@"Rue" message:errorMessage preferredStyle:UIAlertControllerStyleActionSheet];
			UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@":(" style:UIAlertActionStyleDefault handler:nil];

			[alertController addAction: dismissAction];

			[delegate lukiTwitterCellShouldPresentAlertController: alertController];
			return;

		}

		[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

			avatarImageView.image = image;

		} completion:nil];

	}];

}

// ! Reusable

- (UILabel *)createLabelWithText:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color {

	UILabel *label = [UILabel new];
	label.font = [UIFont systemFontOfSize: size];
	label.text = text;
	label.textColor = color;
	[verticalStackView addArrangedSubview: label];
	return label;

}


- (UIStackView *)createStackViewWithAxis:(UILayoutConstraintAxis)axis withSpacing:(CGFloat)spacing {

	UIStackView *stackView = [UIStackView new];
	stackView.axis = axis;
	stackView.spacing = spacing;
	return stackView;

}

@end
