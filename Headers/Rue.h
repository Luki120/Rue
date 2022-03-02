@import UIKit;
#import <substrate.h>
#import "Views/RueSearchView.h"


@interface SBDockView : UIView
@property (nonatomic, readonly) CGFloat dockHeight;
- (void)setupRue;
- (void)shouldHideRueSearchBarBackground;
- (void)setupRueConstraints;
- (void)setBackgroundAlpha:(CGFloat)alpha;
@end


@interface SBRootFolderDockIconListView : UIView
- (void)setupDockConstraints;
@end


@interface SBIconScrollView : UIView
@end


@interface SBHomeHardwareButton : NSObject
@end


@interface SBHomeScreenViewController : UIViewController
@end


@interface _UIBackdropViewSettings : NSObject
+ (id)settingsForStyle:(NSInteger)arg1;
@end


@interface _UIBackdropView : UIView
@property (assign, nonatomic) BOOL blurRadiusSetOnce;
@property (copy, nonatomic) NSString *_blurQuality;
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end

// global

_UIBackdropView *blurredView;
RueSearchView *rueSearchView;
UIView *dimmedView;

static UITapGestureRecognizer *doubleTap;
