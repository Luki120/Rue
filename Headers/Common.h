static NSString *const kPath = @"/var/mobile/Library/Preferences/me.luki.rueprefs.plist";

static NSNotificationName const RueFadeInSubviewsNotification = @"RueFadeInSubviewsNotification";
static NSNotificationName const RueFadeOutSubviewsNotification = @"RueFadeOutSubviewsNotification";
static NSNotificationName const RueSetupNotification = @"RueSetupNotification";
static NSNotificationName const RueHideDockBackgroundNotification = @"RueHideDockBackgroundNotification";
static NSNotificationName const RueSetupSearchEngineNotification = @"RueSetupSearchEngineNotification";
static NSNotificationName const RueHideSearchBarBackgroundNotification = @"RueHideSearchBarBackgroundNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
