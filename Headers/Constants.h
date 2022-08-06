@import UIKit;


static NSString *const kPath = @"/var/mobile/Library/Preferences/me.luki.rueprefs.plist";

static NSString *const kBingEngine = @"https://www.bing.com/search?q=";
static NSString *const kDuckDuckGoEngine = @"https://duckduckgo.com/?q=";
static NSString *const kEcosiaEngine = @"https://www.ecosia.org/search?q=";
static NSString *const kGoogleEngine = @"https://www.google.com/search?q=";
static NSString *const kSearXEngine = @"https://searx.org/search?q=";
static NSString *const kYahooEngine = @"https://search.yahoo.com/search?q=";
static NSString *const kYandexEngine = @"https://yandex.com/search/?text=";
static NSString *const kYouTubeEngine = @"https://www.youtube.com/results?search_query=";

#define kClass(string) NSClassFromString(string)
#define kRueTintColor [UIColor colorWithRed: 0.74 green: 0.45 blue: 0.83 alpha: 1.0];
