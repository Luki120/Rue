#import "RueRootVC.h"

@implementation RueRootVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


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

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"rueSetupDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"chooseSearchEngineDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hideDockBackgroundDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hideRueSearchBarBackgroundDone" object:nil];

}

@end


@implementation RueLinksVC

- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"RueLinks" target:self];
	return _specifiers;

}


- (void)launchDiscord {

	[self launchURL: [NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"]];

}


- (void)launchPayPal {

	[self launchURL: [NSURL URLWithString: @"https://paypal.me/Luki120"]];

}


- (void)launchGitHub {

	[self launchURL: [NSURL URLWithString: @"https://github.com/Luki120/Rue"]];

}


- (void)launchAria {

	[self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.aria"]];

}


- (void)launchElixir {

	[self launchURL: [NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"]];

}

- (void)launchURL:(NSURL *)url {

	[UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];	

}

@end

@implementation RueTintCell

- (void)setTitle:(NSString *)title {

	[super setTitle: title];
	self.titleLabel.textColor = kRueTintColor;

}

@end
