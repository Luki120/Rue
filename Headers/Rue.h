@import CydiaSubstrate;
#import "Views/RueSearchView.h"


@interface SBDockView : UIView
@property (nonatomic, readonly) CGFloat dockHeight;
- (void)setupRue;
- (void)setupRueConstraints;
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
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end
