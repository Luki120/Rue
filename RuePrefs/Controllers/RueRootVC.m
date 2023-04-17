#import "RueRootVC.h"


static LukiTwitterCell *cell;

#define kRueTintColor [UIColor colorWithRed:0.74 green:0.45 blue:0.83 alpha: 1.0]

@interface RueRootVC () <LukiTwitterCellDelegate>
@end

@implementation RueRootVC

// ! Lifecycle

- (NSArray *)specifiers {

	if(_specifiers) return _specifiers;
	_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	PSSpecifier *lukiTwitterCellSpecifier = [PSSpecifier preferenceSpecifierNamed:nil target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
	lukiTwitterCellSpecifier->action = @selector(didTapLukiTwitterCell);
	[lukiTwitterCellSpecifier setProperty:[LukiTwitterCell class] forKey:@"cellClass"];
	[_specifiers insertObject:lukiTwitterCellSpecifier atIndex:1];

	return _specifiers;

}


- (id)init {

	self = [super init];
	if(!self) return nil;

	static dispatch_once_t token;
	dispatch_once(&token, ^{ registerRueTintCellClass(); });

	[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]].minimumTrackTintColor = kRueTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = kRueTintColor;

	return self;

}

// ! Selectors

- (void)didTapLukiTwitterCell {

	[UIApplication.sharedApplication openURL:cell->accountURL options:@{} completionHandler:nil];

}

// ! UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	if(indexPath.section != 0) return [super tableView:tableView cellForRowAtIndexPath: indexPath];

	switch(indexPath.row) {
		case 0:
			cell = (LukiTwitterCell *)[super tableView:tableView cellForRowAtIndexPath: indexPath];
			if([cell isKindOfClass: [LukiTwitterCell class]]) cell->delegate = self;
			return cell;

		default: return [super tableView:tableView cellForRowAtIndexPath: indexPath];
	}

}

// ! Preferences

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile: kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:RueSetupNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:RueSetupSearchEngineNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:RueHideDockBackgroundNotification object:nil];

}

// ! LukiTwitterCellDelegate

- (void)lukiTwitterCellShouldPresentAlertController:(UIViewController *)controller {

	[self presentViewController:controller animated:YES completion:nil];

}

// ! Dark juju

static void rue_setTitle(PSTableCell *self, SEL _cmd, NSString *title) {

	struct objc_super superSetTitle = {
		self,
		[self superclass]
	};

	id (*superCall)(struct objc_super *, SEL, NSString *) = (void *)objc_msgSendSuper;
	superCall(&superSetTitle, _cmd, title);

	self.titleLabel.textColor = kRueTintColor;
	self.titleLabel.highlightedTextColor = kRueTintColor;

}

static void registerRueTintCellClass() {

	Class RueTintCellClass = objc_allocateClassPair([PSTableCell class], "RueTintCell", 0);
	Method method = class_getInstanceMethod([PSTableCell class], @selector(setTitle:));
	const char *typeEncoding = method_getTypeEncoding(method);
	class_addMethod(RueTintCellClass, @selector(setTitle:), (IMP) rue_setTitle, typeEncoding);

	objc_registerClassPair(RueTintCellClass);

}

@end


@implementation RueLinksVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"RueLinks" target:self];
	return _specifiers;

}


- (void)launchDiscord { [self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]]; }
- (void)launchPayPal { [self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]]; }
- (void)launchGitHub { [self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/Rue"]]; }
- (void)launchAria { [self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.aria"]]; }
- (void)launchElixir { [self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"]]; }

- (void)launchURL:(NSURL *)url { [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil]; }

@end
