#import "RueSearchView.h"


@implementation RueSearchView {

	NSString *stringToSearch;

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

	NSURL *theURL = [NSURL URLWithString: stringToSearch];

	[UIApplication.sharedApplication openURL:theURL options:@{} completionHandler:nil];

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

	stringToSearch = [NSString stringWithFormat:@"%@%@", engine, [self.rueSearchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

}


@end
