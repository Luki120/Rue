#import "RueRootVC.h"


@implementation RueRootVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];

	return _specifiers;

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPath]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:kPath]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:kPath atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"rueSetupDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"chooseSearchEngineDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hideDockBackgroundDone" object:nil];

}


@end



@implementation RueLinksVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"RueLinks" target:self];

	return _specifiers;

}


- (void)launchDiscord {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://discord.gg/jbE3avwSHs"] options:@{} completionHandler:nil];

}


- (void)launchPayPal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)launchGitHub {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/Rue"] options:@{} completionHandler:nil];

}


- (void)launchAria {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.aria"] options:@{} completionHandler:nil];

}


- (void)launchElixir {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://luki120.github.io/depictions/web/?p=me.luki.elixir"] options:@{} completionHandler:nil];

}


@end


@implementation RueTintCell


- (void)setTitle:(NSString *)title {

	[super setTitle:title];

	self.titleLabel.textColor = kRueTintColor;

}


@end
