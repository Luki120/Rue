#import <rootless.h>

#define jbRootPath(path) ROOT_PATH_NS(path)

static NSString *const kSuiteName = @"me.luki.rueprefs";

static NSNotificationName const RueDidFadeInSubviewsNotification = @"RueDidFadeInSubviewsNotification";
static NSNotificationName const RueDidFadeOutSubviewsNotification = @"RueDidFadeOutSubviewsNotification";
static NSNotificationName const RueDidSetupNotification = @"RueDidSetupNotification";
static NSNotificationName const RueDidHideDockBackgroundNotification = @"RueDidHideDockBackgroundNotification";
static NSNotificationName const RueDidSetupSearchEngineNotification = @"RueDidSetupSearchEngineNotification";

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end
