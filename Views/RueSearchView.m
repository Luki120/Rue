#import "RueSearchView.h"


@interface RueSearchView () <UISearchBarDelegate>
@end


@implementation RueSearchView {

	NSString *_httpURLString;
	NSString *_searchableString;
	NSString *_vanillaURLString;

}

static NSString *const kBingEngine = @"https://www.bing.com/search?q=";
static NSString *const kDuckDuckGoEngine = @"https://duckduckgo.com/?q=";
static NSString *const kEcosiaEngine = @"https://www.ecosia.org/search?q=";
static NSString *const kGoogleEngine = @"https://www.google.com/search?q=";
static NSString *const kSearXEngine = @"https://searx.org/search?q=";
static NSString *const kYahooEngine = @"https://search.yahoo.com/search?q=";
static NSString *const kYandexEngine = @"https://yandex.com/search/?text=";
static NSString *const kYouTubeEngine = @"https://www.youtube.com/results?search_query=";

// ! Lifecycle

- (id)init {

	self = [super init];
	if(!self) return nil;

	[self _setupRueSearchBar];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(_setupSearchEngine) name:RueDidSetupSearchEngineNotification object:nil];

	return self;

}

// ! Private

- (void)_setupRueSearchBar {

	self.translatesAutoresizingMaskIntoConstraints = NO;

	if(self.rueSearchBar) return;

	self.rueSearchBar = [UISearchBar new];
	self.rueSearchBar.delegate = self;
	self.rueSearchBar.placeholder = @"Search";
	self.rueSearchBar.keyboardType = UIKeyboardTypeWebSearch;
	self.rueSearchBar.returnKeyType = UIReturnKeyDone;
	self.rueSearchBar.clipsToBounds = YES;
	self.rueSearchBar.backgroundImage = [UIImage new];
	self.rueSearchBar.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview: self.rueSearchBar];

	[self _layoutRueSearchBar];

}


- (void)_layoutRueSearchBar {

	NSDictionary *dict = @{ @"rueSearchBar": self.rueSearchBar };

	NSArray *formatStrings = @[
		@"V:|-[rueSearchBar]",
		@"V:[rueSearchBar(==50)]",
		@"H:|-15-[rueSearchBar]-15-|"
	];

	for(NSString *format in formatStrings)
		[NSLayoutConstraint activateConstraints:
			[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:dict]];

}


- (void)_setupSearchEngine {

	loadShit();
	switch(searchEngineType) {
		case 0: [self _setupSearchEngineWithEngine: kBingEngine]; break;
		case 1: [self _setupSearchEngineWithEngine: kDuckDuckGoEngine]; break;
		case 2: [self _setupSearchEngineWithEngine: kEcosiaEngine]; break;
		case 3: [self _setupSearchEngineWithEngine: kGoogleEngine]; break;
		case 4: [self _setupSearchEngineWithEngine: kSearXEngine]; break;
		case 5: [self _setupSearchEngineWithEngine: kYahooEngine]; break;
		case 6: [self _setupSearchEngineWithEngine: kYandexEngine]; break;
		case 7: [self _setupSearchEngineWithEngine: kYouTubeEngine]; break;
	}

}


- (void)_setupSearchEngineWithEngine:(NSString *)engine {

	_searchableString = [NSString stringWithFormat:@"%@%@", engine, [self.rueSearchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

}


- (void)_setupURLTypesForSearchBar:(UISearchBar *)rueSearchBar {

	_httpURLString = [NSString stringWithFormat:@"%@", rueSearchBar.text];
	_vanillaURLString = [NSString stringWithFormat:@"https://%@", rueSearchBar.text];

	NSURL *httpURL = [NSURL URLWithString: _httpURLString];
	NSURL *searchableStringURL = [NSURL URLWithString: _searchableString];
	NSURL *vanillaURL = [NSURL URLWithString: _vanillaURLString];

	if([rueSearchBar.text hasPrefix:@"http"])
		[UIApplication.sharedApplication openURL:httpURL options:@{} completionHandler:nil];

	else if([rueSearchBar.text hasPrefix:@"www"])
		[UIApplication.sharedApplication openURL:vanillaURL options:@{} completionHandler:nil];

	else [UIApplication.sharedApplication openURL:searchableStringURL options:@{} completionHandler:nil];

}

// ! UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

	[self _setupSearchEngine];
	[self _setupURLTypesForSearchBar: searchBar];

	[searchBar resignFirstResponder];

	self.rueSearchBar.text = @"";

}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

	[NSNotificationCenter.defaultCenter postNotificationName:RueDidFadeInSubviewsNotification object:nil];
	return YES;

}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

	[NSNotificationCenter.defaultCenter postNotificationName:RueDidFadeOutSubviewsNotification object:nil];
	return YES;

}

@end
