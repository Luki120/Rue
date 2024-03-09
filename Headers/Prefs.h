#import "Common.h"

static BOOL hideDockBackground;
static BOOL hideSearchBarBackground;

static double topConstant;
static double widthConstant;

static NSInteger searchEngineType;

static void loadShit(void) {

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName: kSuiteName];

	hideDockBackground = [prefs objectForKey:@"hideDockBackground"] ? [prefs boolForKey:@"hideDockBackground"] : NO;
	hideSearchBarBackground = [prefs objectForKey:@"hideSearchBarBackground"] ? [prefs boolForKey:@"hideSearchBarBackground"] : NO;
	searchEngineType = [prefs objectForKey:@"searchEngineType"] ? [prefs integerForKey:@"searchEngineType"] : 2;
	topConstant = [prefs objectForKey:@"topConstant"] ? [prefs floatForKey:@"topConstant"] : 10;
	widthConstant = [prefs objectForKey:@"widthConstant"] ? [prefs floatForKey:@"widthConstant"] : 220;

}
