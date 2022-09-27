#import "RueSearchView.h"


@implementation RueSearchView {

	NSString *httpURLString;
	NSString *searchableString;
	NSString *vanillaURLString;

}

static NSString *const kBingEngine = @"https://www.bing.com/search?q=";
static NSString *const kDuckDuckGoEngine = @"https://duckduckgo.com/?q=";
static NSString *const kEcosiaEngine = @"https://www.ecosia.org/search?q=";
static NSString *const kGoogleEngine = @"https://www.google.com/search?q=";
static NSString *const kSearXEngine = @"https://searx.org/search?q=";
static NSString *const kYahooEngine = @"https://search.yahoo.com/search?q=";
static NSString *const kYandexEngine = @"https://yandex.com/search/?text=";
static NSString *const kYouTubeEngine = @"https://www.youtube.com/results?search_query=";

#define kStockColor [UIColor.systemGrayColor colorWithAlphaComponent: 0.24]

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self setupRueSearchBar];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupSearchEngine) name:@"chooseSearchEngineDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(hideRueSearchBarBackground) name:@"hideRueSearchBarBackgroundDone" object:nil];

	return self;

}


- (void)setupRueSearchBar {

	self.translatesAutoresizingMaskIntoConstraints = NO;

	if(self.rueSearchBar) return;

	self.rueSearchBar = [UISearchBar new];
	self.rueSearchBar.delegate = self;
	self.rueSearchBar.placeholder = @"Search";
	self.rueSearchBar.keyboardType = UIKeyboardTypeWebSearch;
	self.rueSearchBar.returnKeyType = UIReturnKeyDone;
	self.rueSearchBar.clipsToBounds = YES;
	self.rueSearchBar.backgroundImage = [UIImage new];
	self.rueSearchBar.searchTextField.backgroundColor = hideSearchBarBackground ? UIColor.clearColor : kStockColor;
	self.rueSearchBar.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview: self.rueSearchBar];

	[self layoutRueSearchBar];
	[self hideRueSearchBarBackground];

}


- (void)layoutRueSearchBar {

	NSDictionary *dict = @{ @"rueSearchBar": self.rueSearchBar };

	NSString *formatTop = @"V:|-[rueSearchBar]";
	NSString *formatHeight = @"V:[rueSearchBar(==50)]";
	NSString *formatLeadingTrailing = @"H:|-15-[rueSearchBar]-15-|";

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatTop options:0 metrics:nil views:dict]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatHeight options:0 metrics:nil views:dict]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatLeadingTrailing options:0 metrics:nil views:dict]];

}


- (void)hideRueSearchBarBackground {

	loadShit();
	self.rueSearchBar.searchTextField.backgroundColor = hideSearchBarBackground ? UIColor.clearColor : kStockColor;

}


- (void)setupSearchEngine {

	loadShit();
	switch(searchEngineType) {
		case 0: [self setupSearchEngineWithEngine: kBingEngine]; break;
		case 1: [self setupSearchEngineWithEngine: kDuckDuckGoEngine]; break;
		case 2: [self setupSearchEngineWithEngine: kEcosiaEngine]; break;
		case 3: [self setupSearchEngineWithEngine: kGoogleEngine]; break;
		case 4: [self setupSearchEngineWithEngine: kSearXEngine]; break;
		case 5: [self setupSearchEngineWithEngine: kYahooEngine]; break;
		case 6: [self setupSearchEngineWithEngine: kYandexEngine]; break;
		case 7: [self setupSearchEngineWithEngine: kYouTubeEngine]; break;
	}

}


- (void)setupSearchEngineWithEngine:(NSString *)engine {

	searchableString = [NSString stringWithFormat:@"%@%@", engine, [self.rueSearchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

}


- (void)setupURLTypesForSearchBar:(UISearchBar *)rueSearchBar {

	httpURLString = [NSString stringWithFormat:@"%@", rueSearchBar.text];
	vanillaURLString = [NSString stringWithFormat:@"https://%@", rueSearchBar.text];

	NSURL *httpURL = [NSURL URLWithString: httpURLString];
	NSURL *searchableStringURL = [NSURL URLWithString: searchableString];
	NSURL *vanillaURL = [NSURL URLWithString: vanillaURLString];

	if([rueSearchBar.text hasPrefix:@"http"])

		[UIApplication.sharedApplication openURL:httpURL options:@{} completionHandler:nil];

	else if([rueSearchBar.text hasPrefix:@"www"])

		[UIApplication.sharedApplication openURL:vanillaURL options:@{} completionHandler:nil];

	else [UIApplication.sharedApplication openURL:searchableStringURL options:@{} completionHandler:nil];

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

	[self setupSearchEngine];
	[self setupURLTypesForSearchBar: searchBar];

	[searchBar resignFirstResponder];

	self.rueSearchBar.text = @"";

}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

	[NSNotificationCenter.defaultCenter postNotificationName:@"fadeInNow" object:nil];
	return YES;

}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

	[NSNotificationCenter.defaultCenter postNotificationName:@"fadeOutNow" object:nil];
	return YES;

}

@end
