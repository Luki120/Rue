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

	if(self) {

		[self setupRueSearchBar];

		[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupSearchEngine) name:@"chooseSearchEngineDone" object:nil];

	}

	return self;

}


- (void)setupRueSearchBar {

	if(self.rueSearchBar) return;

	self.rueSearchBar = [UISearchBar new];
	self.rueSearchBar.tag = 1337;
	self.rueSearchBar.delegate = self;
	self.rueSearchBar.placeholder = @"Search";
	self.rueSearchBar.returnKeyType = UIReturnKeyDone;
	self.rueSearchBar.backgroundImage = [UIImage new];
	self.rueSearchBar.translatesAutoresizingMaskIntoConstraints = NO;

}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

	[self setupSearchEngine];

	httpURLString = [NSString stringWithFormat:@"%@", searchBar.text];
	vanillaURLString = [NSString stringWithFormat:@"https://%@", searchBar.text];

	NSURL *httpURL = [NSURL URLWithString: httpURLString];
	NSURL *searchableStringURL = [NSURL URLWithString: searchableString];
	NSURL *vanillaURL = [NSURL URLWithString: vanillaURLString];

	if([searchBar.text hasPrefix:@"http"])

		[UIApplication.sharedApplication openURL:httpURL options:@{} completionHandler:nil];

	else if([searchBar.text hasPrefix:@"www"])

		[UIApplication.sharedApplication openURL:vanillaURL options:@{} completionHandler:nil];

	else [UIApplication.sharedApplication openURL:searchableStringURL options:@{} completionHandler:nil];

	[searchBar resignFirstResponder];

	self.rueSearchBar.text = @"";

}


- (void)setupSearchEngine {

	loadShit();

	switch(searchEngineType) {

		case 0:

			[self setupSearchEngineWithEngine: kBingEngine];
			break;

		case 1:

			[self setupSearchEngineWithEngine: kDuckDuckGoEngine];
			break;

		case 2:

			[self setupSearchEngineWithEngine: kEcosiaEngine];
			break;

		case 3:

			[self setupSearchEngineWithEngine: kGoogleEngine];
			break;

		case 4:

			[self setupSearchEngineWithEngine: kSearXEngine];
			break;

		case 5:

			[self setupSearchEngineWithEngine: kYahooEngine];
			break;

		case 6:

			[self setupSearchEngineWithEngine: kYandexEngine];
			break;

		case 7:

			[self setupSearchEngineWithEngine: kYouTubeEngine];
			break;

	}

}


- (void)setupSearchEngineWithEngine:(NSString *)engine {

	searchableString = [NSString stringWithFormat:@"%@%@", engine, [self.rueSearchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

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
