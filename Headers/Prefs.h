#import "Common.h"

static BOOL hideDockBackground;
static BOOL hideSearchBarBackground;

static double topConstant;
static double widthConstant;

static NSInteger searchEngineType;

static void loadShit() {

	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: kPath];
	NSMutableDictionary *prefs = dict ? [dict mutableCopy] : [NSMutableDictionary dictionary];

	hideDockBackground = prefs[@"hideDockBackground"] ? [prefs[@"hideDockBackground"] boolValue] : NO;
	hideSearchBarBackground = prefs[@"hideSearchBarBackground"] ? [prefs[@"hideSearchBarBackground"] boolValue] : NO;
	searchEngineType = prefs[@"searchEngineType"] ? [prefs[@"searchEngineType"] integerValue] : 2;
	topConstant = prefs[@"topConstant"] ? [prefs[@"topConstant"] doubleValue] : 10;
	widthConstant = prefs[@"widthConstant"] ? [prefs[@"widthConstant"] doubleValue] : 220;

}
