#import "Headers/Rue.h"


// ! Global

static _UIBackdropView *blurredView;
static RueSearchView *rueSearchView;
static UIView *dimmedView;

static UITapGestureRecognizer *tapGestureRecognizer;

static NSNotificationName const RueDimIconsNowNotification = @"RueDimIconsNowNotification";
static NSNotificationName const RueDimUndimIconsNowNotification = @"RueDimUndimIconsNowNotification";

#define kClass(class) NSClassFromString(class)

// ! Setup

static void new_setupRue(SBDockView *self, SEL _cmd) {

	loadShit();

	if(!rueSearchView) rueSearchView = [RueSearchView new];
	if(![rueSearchView isDescendantOfView: self]) [self addSubview: rueSearchView];

	[self setupRueConstraints];

}

static void new_setupRueConstraints(SBDockView *self, SEL _cmd) {

	rueSearchView.topAnchorConstraint.active = NO;
	rueSearchView.topAnchorConstraint = [rueSearchView.topAnchor constraintEqualToAnchor:self.topAnchor constant: topConstant];
	rueSearchView.topAnchorConstraint.active = YES;

	[rueSearchView.centerXAnchor constraintEqualToAnchor: self.centerXAnchor].active = YES;
	[rueSearchView.heightAnchor constraintEqualToConstant: 50].active = YES;

	rueSearchView.widthAnchorConstraint.active = NO;
	rueSearchView.widthAnchorConstraint = [rueSearchView.widthAnchor constraintEqualToConstant: widthConstant];
	rueSearchView.widthAnchorConstraint.active = YES;

}

static void transitionViews(
	SBDockView *self,
	BOOL isDismissing,
	CGFloat blurredViewAlpha,
	CGFloat dimmedViewAlpha,
	NSLayoutAnchor *topAnchor,
	CGFloat constraintConstant,
	NSNotificationName notificationName,
	void(^completion)(BOOL finished)) {

	UIViewAnimationOptions options = isDismissing ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionFlipFromTop;

	[UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.1 options:options animations:^{

		rueSearchView.topAnchorConstraint.active = NO;
		rueSearchView.topAnchorConstraint = [rueSearchView.topAnchor constraintEqualToAnchor:topAnchor constant: constraintConstant];
		rueSearchView.topAnchorConstraint.active = YES;

		[self layoutIfNeeded];

	} completion:nil];

	[UIView transitionWithView:rueSearchView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

		blurredView.alpha = blurredViewAlpha;
		dimmedView.alpha = dimmedViewAlpha;
		[NSNotificationCenter.defaultCenter postNotificationName:notificationName object:nil];

	} completion: completion];

}

static void new_keyboardWillShow(SBDockView *self, SEL _cmd) {

	UILayoutGuide *guide = self.superview.superview.superview.superview.superview.safeAreaLayoutGuide;

	transitionViews(self, NO, 0.85, 0.45, guide.topAnchor, 10, RueDimIconsNowNotification, ^(BOOL finished) {

		tapGestureRecognizer.enabled = YES;

		for(UIView *subview in self.superview.subviews)

			if(![subview isEqual:self]) subview.userInteractionEnabled = NO;

	});

}

static void new_keyboardWillHide(SBDockView *self, SEL _cmd) {

	transitionViews(self, YES, 0, 0, self.topAnchor, topConstant, RueDimUndimIconsNowNotification, ^(BOOL finished) {

		tapGestureRecognizer.enabled = NO;

		for(UIView *subview in self.superview.subviews)

			if(![subview isEqual:self]) subview.userInteractionEnabled = YES;

	});

	[rueSearchView.rueSearchBar resignFirstResponder];

}

static id (*origIWF)(SBDockView *, SEL, CGRect);
static id overrideIWF(SBDockView *self, SEL _cmd, CGRect frame) {

	id origStub = origIWF(self, _cmd, frame);

	[self setupRue];

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow) name:RueFadeInSubviewsNotification object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide) name:RueFadeOutSubviewsNotification object:nil];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupRue) name:RueSetupNotification object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setBackgroundAlpha:) name:RueHideDockBackgroundNotification object:nil];

	return origStub;

}

static void new_setupDockConstraints(SBRootFolderDockIconListView *self, SEL _cmd) {

	loadShit();

	self.translatesAutoresizingMaskIntoConstraints = NO;
	[self.centerXAnchor constraintEqualToAnchor: self.superview.centerXAnchor].active = YES;
	[self.centerYAnchor constraintEqualToAnchor: self.superview.centerYAnchor constant: 22.5].active = YES;

}

static void (*origDMTW)(SBRootFolderDockIconListView *, SEL);
static void overrideDMTW(SBRootFolderDockIconListView *self, SEL _cmd) {

	origDMTW(self, _cmd);
	[self setupDockConstraints];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setupDockConstraints) name:RueSetupNotification object:nil];

}

// ! Misc

static CGFloat (*origDockHeight)(SBDockView *, SEL);
static CGFloat overrideDockHeight(SBDockView *self, SEL _cmd) {

	// lol, imagine not overriding readonly properties, thanks Apple for this one btw
	return origDockHeight(self, _cmd) + 50;

}

static void (*origSetBackgroundAlpha)(SBDockView *, SEL, CGFloat);
static void overrideSetBackgroundAlpha(SBDockView *self, SEL _cmd, CGFloat alpha) {

	if(!hideDockBackground) return origSetBackgroundAlpha(self, _cmd, 1);
	origSetBackgroundAlpha(self, _cmd, 0);

}

static void (*origTCDC)(SBDockView *, SEL, UITraitCollection *);
static void overrideTCDC(SBDockView *self, SEL _cmd, UITraitCollection *previousTrait) {

	origTCDC(self, _cmd, previousTrait);

	// credits & slightly modified from ⇝ https://github.com/ren7995/Atria/blob/master/Hooks/DockView.xm
	// turns out NSNotificationCenter wasn't bulletproof in the end, at least on iOS 15+
	// the fact that this works and performSelector:withObject: doesn't is just cursed tho, but whatever
	[self performSelector:@selector(setBackgroundAlpha:) withObject:nil afterDelay:0];

}

static UIView *(*origHitTestPointWithEvent)(SBDockView *, SEL, CGPoint, UIEvent *);
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

static void (*origSinglePressUp)(SBHomeHardwareButton *, SEL, id);
static void overrideSinglePressUp(SBHomeHardwareButton *self, SEL _cmd, id pressUp) {

	origSinglePressUp(self, _cmd, pressUp);

	if(rueSearchView.rueSearchBar.window == nil) return;
	[NSNotificationCenter.defaultCenter postNotificationName:RueFadeOutSubviewsNotification object:nil];

}

static void (*origIconScrollViewDMTS)(SBIconScrollView *, SEL);
static void overrideIconScrollViewDMTS(SBIconScrollView *self, SEL _cmd) {

	origIconScrollViewDMTS(self, _cmd);

	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dimIcons:) name:RueDimIconsNowNotification object:nil];
	[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dimIcons:) name:RueDimUndimIconsNowNotification object:nil];

}

static void new_dimIcons(SBIconScrollView *self, SEL _cmd, NSNotification *notification) {

	self.alpha = [notification.name isEqualToString: RueDimIconsNowNotification] ? 0.45 : 1;

}

// ! Blur, dim & gesture

static void (*origVDL)(SBHomeScreenViewController *, SEL);
static void overrideVDL(SBHomeScreenViewController *self, SEL _cmd) {

	origVDL(self, _cmd);

	if(!blurredView) {
		_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

		blurredView = [[_UIBackdropView alloc] initWithFrame:CGRectZero autosizesToFitSuperview:YES settings:settings];
		blurredView.alpha = 0;
		[self.view insertSubview:blurredView atIndex:0];
	}

	if(!dimmedView) {
		dimmedView = [UIView new];
		dimmedView.alpha = 0;
		dimmedView.frame = UIScreen.mainScreen.bounds;
		dimmedView.backgroundColor = UIColor.blackColor;
		[self.view insertSubview:dimmedView atIndex:1];
	}

	if(!tapGestureRecognizer) {
		tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rue_didDoubleTap)];
		tapGestureRecognizer.enabled = NO;
		tapGestureRecognizer.numberOfTapsRequired = 2;
		[self.view addGestureRecognizer: tapGestureRecognizer];
	}

}

static void new_rue_didDoubleTap(SBHomeScreenViewController *self, SEL _cmd) {

	[NSNotificationCenter.defaultCenter postNotificationName:RueFadeOutSubviewsNotification object:nil];

}


__attribute__((constructor)) static void init() {

	MSHookMessageEx(kClass(@"SBDockView"), @selector(initWithFrame:), (IMP) &overrideIWF, (IMP *) &origIWF);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(dockHeight), (IMP) &overrideDockHeight, (IMP *) &origDockHeight);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(setBackgroundAlpha:), (IMP) &overrideSetBackgroundAlpha, (IMP *) &origSetBackgroundAlpha);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(hitTest:withEvent:), (IMP) &overrideHitTestPointWithEvent, (IMP *) &origHitTestPointWithEvent);
	MSHookMessageEx(kClass(@"SBDockView"), @selector(traitCollectionDidChange:), (IMP) &overrideTCDC, (IMP *) &origTCDC);
	MSHookMessageEx(kClass(@"SBRootFolderDockIconListView"), @selector(didMoveToWindow), (IMP) &overrideDMTW, (IMP *) &origDMTW);
	MSHookMessageEx(kClass(@"SBHomeHardwareButton"), @selector(singlePressUp:), (IMP) &overrideSinglePressUp, (IMP *) &origSinglePressUp);
	MSHookMessageEx(kClass(@"SBIconScrollView"), @selector(didMoveToSuperview), (IMP) &overrideIconScrollViewDMTS, (IMP *) &origIconScrollViewDMTS);
	MSHookMessageEx(kClass(@"SBHomeScreenViewController"), @selector(viewDidLoad), (IMP) &overrideVDL, (IMP *) &origVDL);

	class_addMethod(kClass(@"SBDockView"), @selector(setupRue), (IMP) &new_setupRue, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(setupRueConstraints), (IMP) &new_setupRueConstraints, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(keyboardWillShow), (IMP) &new_keyboardWillShow, "v@:");
	class_addMethod(kClass(@"SBDockView"), @selector(keyboardWillHide), (IMP) &new_keyboardWillHide, "v@:");
	class_addMethod(kClass(@"SBRootFolderDockIconListView"), @selector(setupDockConstraints), (IMP) &new_setupDockConstraints, "v@:");
	class_addMethod(kClass(@"SBHomeScreenViewController"), @selector(rue_didDoubleTap), (IMP) &new_rue_didDoubleTap, "v@:");
	class_addMethod(kClass(@"SBIconScrollView"), @selector(dimIcons:), (IMP) &new_dimIcons, "v@:@");

}
