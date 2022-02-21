#import "RueSearchView.h"


@implementation RueSearchView {

	NSString *httpURLString;
	NSString *searchableString;
	NSString *vanillaURLString;

}


+ (RueSearchView *)sharedInstance {

	static RueSearchView *sharedInstance = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{ sharedInstance = [self new]; });

	return sharedInstance;

}


- (id)init {

	self = [super init];

	if(!self) return nil;

	[self setupRueSearchBar];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupSearchEngine) name:@"chooseSearchEngineDone" object:nil];

	return self;

}


- (void)setupRueSearchBar {

	if(self.rueSearchBar) return;

	self.rueSearchBar = [UISearchBar new];
	self.rueSearchBar.delegate = self;
	self.rueSearchBar.placeholder = @"Search";
	self.rueSearchBar.keyboardType = UIKeyboardTypeWebSearch;
	self.rueSearchBar.returnKeyType = UIReturnKeyDone;
	self.rueSearchBar.backgroundImage = [UIImage new];
	self.rueSearchBar.translatesAutoresizingMaskIntoConstraints = NO;

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
