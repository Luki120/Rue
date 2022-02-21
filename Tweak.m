#import "Headers/Rue.h"
#import "Headers/Prefs.h"
#import "Views/RueSearchView.h"


static void crossDissolveViews() {

	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		[RueSearchView sharedInstance].topAnchorConstraint.active = NO;
		[RueSearchView sharedInstance].topAnchorConstraint = [[RueSearchView sharedInstance].rueSearchBar.topAnchor constraintEqualToAnchor: dockView.topAnchor constant: topConstant];
		[RueSearchView sharedInstance].topAnchorConstraint.active = YES;

		blurredView.alpha = 0;
		dimmedView.alpha = 0;
		iconScrollView.alpha = 1;

	} completion:nil];

	[[RueSearchView sharedInstance].rueSearchBar resignFirstResponder];

}

// ! Setup

static void new_setupRue(SBDockView *self, SEL _cmd) {

	loadShit();

	dockView = self; // get an instance of SBDockView

	[self addSubview: [RueSearchView sharedInstance].rueSearchBar];
	[self shouldHideRueSearchBarBackground];
	[self setupRueConstraints];

}

static void new_setupRueConstraints(SBDockView *self, SEL _cmd) {

	[RueSearchView sharedInstance].topAnchorConstraint.active = NO;
	[RueSearchView sharedInstance].topAnchorConstraint = [[RueSearchView sharedInstance].rueSearchBar.topAnchor constraintEqualToAnchor: self.topAnchor];
	[RueSearchView sharedInstance].topAnchorConstraint.constant = topConstant;
	[RueSearchView sharedInstance].topAnchorConstraint.active = YES;

	[[RueSearchView sharedInstance].rueSearchBar.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;

	[RueSearchView sharedInstance].widthAnchorConstraint.active = NO;
	[RueSearchView sharedInstance].widthAnchorConstraint = [[RueSearchView sharedInstance].rueSearchBar.widthAnchor constraintEqualToConstant: widthConstant];
	[RueSearchView sharedInstance].widthAnchorConstraint.active = YES;

	[[RueSearchView sharedInstance].rueSearchBar.heightAnchor constraintEqualToConstant: 50].active = YES;

}

static void new_shouldHideRueSearchBarBackground(SBDockView *self, SEL _cmd) {

	if(hideSearchBarBackground)

		[RueSearchView sharedInstance].rueSearchBar.searchTextField.backgroundColor = UIColor.clearColor;

	else

		[RueSearchView sharedInstance].rueSearchBar.searchTextField.backgroundColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.50 alpha:0.24]; // stock color, totally hijacked from Flex :lmaoEpic:

}

static void transitionViews(SBDockView *self, SEL _cmd,
	NSLayoutAnchor *topAnchor,
	CGFloat blurredViewAlpha,
	CGFloat dimmedViewAlpha,
	CGFloat iconScrollViewAlpha,
	void(^completion)(BOOL finished)) {

	[UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		[RueSearchView sharedInstance].topAnchorConstraint.active = NO;
		[RueSearchView sharedInstance].topAnchorConstraint = [[RueSearchView sharedInstance].rueSearchBar.topAnchor constraintEqualToAnchor: topAnchor constant: 10];
		[RueSearchView sharedInstance].topAnchorConstraint.active = YES;

		blurredView.alpha = blurredViewAlpha;
		dimmedView.alpha = dimmedViewAlpha;
		iconScrollView.alpha = iconScrollViewAlpha;

	} completion: completion];

}

static void new_keyboardWillShow(SBDockView *self, SEL _cmd) {

	UILayoutGuide *guide = self.superview.superview.superview.superview.superview.safeAreaLayoutGuide;

	transitionViews(self, _cmd, guide.topAnchor, 0.85, 0.45, 0.45, ^(BOOL finished) {

		doubleTap.enabled = YES;

		for(UIView *subview in self.superview.subviews)

			if(![subview isEqual:self]) subview.userInteractionEnabled = NO;

	});

}

static void new_keyboardWillHide(SBDockView *self, SEL _cmd) {

	transitionViews(self, _cmd, self.topAnchor, 0, 0, 1, ^(BOOL finished) {

		doubleTap.enabled = NO;

		for(UIView *subview in self.superview.subviews)

			if(![subview isEqual:self]) subview.userInteractionEnabled = YES;

	});

}

static void (*origDMTS)(SBDockView *self, SEL _cmd);

static void overrideDMTS(SBDockView *self, SEL _cmd) {

	origDMTS(self, _cmd);
	[self setupRue];

	[NSNotificationCenter.defaultCenter removeObserver:self];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow) name:@"fadeInNow" object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide) name:@"fadeOutNow" object:nil];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupRue) name:@"rueSetupDone" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setBackgroundAlpha:) name:@"hideDockBackgroundDone" object:nil];

}

static void new_setupDockConstraints(SBRootFolderDockIconListView *self, SEL _cmd) {

	loadShit();

	self.translatesAutoresizingMaskIntoConstraints = NO;
	[self.centerXAnchor constraintEqualToAnchor: self.superview.centerXAnchor].active = YES;
	[self.centerYAnchor constraintEqualToAnchor: self.superview.centerYAnchor constant: 22.5].active = YES;

}

static void (*origDMTW)(SBRootFolderDockIconListView *self, SEL _cmd);

static void overrideDMTW(SBRootFolderDockIconListView *self, SEL _cmd) {

	origDMTW(self, _cmd);
	[self setupDockConstraints];

	[NSDistributedNotificationCenter.defaultCenter removeObserver:self];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupDockConstraints) name:@"rueSetupDone" object:nil];

}

// ! Misc

static CGFloat (*origDockHeight)(SBDockView *self, SEL _cmd);

static CGFloat overrideDockHeight(SBDockView *self, SEL _cmd) {

	// lol, imagine not overriding readonly properties, thanks Apple for this one btw
	return origDockHeight(self, _cmd) + 50;

}

static void (*origSetBackgroundAlpha)(SBDockView *self, SEL _cmd, CGFloat);

static void overrideSetBackgroundAlpha(SBDockView *self, SEL _cmd, CGFloat alpha) {

	if(!hideDockBackground) return origSetBackgroundAlpha(self, _cmd, 1);

	origSetBackgroundAlpha(self, _cmd, 0);

}

static void (*origTCDC)(UIScreen *self, SEL _cmd, id);

static void overrideTCDC(UIScreen *self, SEL _cmd, id previousTrait) {

	origTCDC(self, _cmd, previousTrait);

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hideDockBackgroundDone" object:nil];

}

static UIView *(*origHitTestPointWithEvent)(SBDockView *self, SEL _cmd, CGPoint, UIEvent *);

static UIView *overrideHitTestPointWithEvent(SBDockView *self, SEL _cmd, CGPoint point, UIEvent *event) {

	origHitTestPointWithEvent(self, _cmd, point, event);

	// https://stackoverflow.com/a/14875673

	/*--- allow touches to pass through even when
	the subview it's outside the superview's bounds ---*/

	if(self.clipsToBounds) return nil;
	else if(self.hidden) return nil;
	else if(self.alpha == 0) return nil;

	for(UIView *subview in self.subviews.reverseObjectEnumerator) {

		CGPoint subPoint = [subview convertPoint:point fromView:self];
		UIView *result = [subview hitTest:subPoint withEvent:event];

		if(result) return result;

	}

    return nil;

}

static void (*origSinglePressUp)(SBHomeHardwareButton *self, SEL _cmd, id);

static void overrideSinglePressUp(SBHomeHardwareButton *self, SEL _cmd, id pressUp) {

	origSinglePressUp(self, _cmd, pressUp);

	if([RueSearchView sharedInstance].rueSearchBar.window == nil) return;

	crossDissolveViews();

}

static void (*origIconScrollViewDMTS)(SBIconScrollView *self, SEL _cmd);

static void overrideIconScrollViewDMTS(SBIconScrollView *self, SEL _cmd) {

	origIconScrollViewDMTS(self, _cmd);
	iconScrollView = self; // get an instance of SBIconScrollView

}

// ! Blur, dim & gesture

static void (*origVDL)(SBHomeScreenViewController *self, SEL _cmd);

static void overrideVDL(SBHomeScreenViewController *self, SEL _cmd) {

	origVDL(self, _cmd);

	hsVC = self; // get an instance of SBHomeScreenViewController

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	blurredView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
	blurredView.alpha = 0;
	blurredView._blurQuality = @"high";
	blurredView.blurRadiusSetOnce = NO;
	[self.view insertSubview:blurredView atIndex:0];

	dimmedView = [UIView new];
	dimmedView.alpha = 0;
	dimmedView.frame = UIScreen.mainScreen.bounds;
	dimmedView.backgroundColor = UIColor.blackColor;
	[self.view insertSubview:dimmedView atIndex:1];

	doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rue_didDoubleTap)];
	doubleTap.enabled = NO;
	doubleTap.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer: doubleTap];

}

static void new_rue_didDoubleTap(SBHomeScreenViewController *self, SEL _cmd) {

	crossDissolveViews();

}


__attribute__((constructor)) static void init() {

	if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) return;

	MSHookMessageEx(kClass(@"SBDockView"), @selector(didMoveToSuperview), (IMP) &overrideDMTS, (IMP *) &origDMTS);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(dockHeight), (IMP) &overrideDockHeight, (IMP *) &origDockHeight);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(setBackgroundAlpha:), (IMP) &overrideSetBackgroundAlpha, (IMP *) &origSetBackgroundAlpha);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(hitTest:withEvent:), (IMP) &overrideHitTestPointWithEvent, (IMP *) &origHitTestPointWithEvent);
	MSHookMessageEx(kClass(@"UIScreen"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);
	MSHookMessageEx(kClass(@"SBRootFolderDockIconListView"), @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);
	MSHookMessageEx(kClass(@"SBHomeHardwareButton"), @selector(singlePressUp:), (IMP) &overrideSinglePressUp, (IMP *) &origSinglePressUp);
	MSHookMessageEx(kClass(@"SBIconScrollView"), @selector(didMoveToSuperview), (IMP) &overrideIconScrollViewDMTS, (IMP *) &origIconScrollViewDMTS);
	MSHookMessageEx(kClass(@"SBHomeScreenViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	class_addMethod(kClass(@"SBDockView"), @selector(setupRue), (IMP) &new_setupRue, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(setupRueConstraints), (IMP) &new_setupRueConstraints, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(shouldHideRueSearchBarBackground), (IMP)&new_shouldHideRueSearchBarBackground, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(keyboardWillShow), (IMP) &new_keyboardWillShow, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(keyboardWillHide), (IMP) &new_keyboardWillHide, "v@:");
	class_addMethod(kClass(@"SBRootFolderDockIconListView"), @selector(setupDockConstraints), (IMP) &new_setupDockConstraints, "v@:");
	class_addMethod(kClass(@"SBHomeScreenViewController"), @selector(rue_didDoubleTap), (IMP) &new_rue_didDoubleTap, "v@:");

}
