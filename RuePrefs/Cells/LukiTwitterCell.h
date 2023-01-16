@import ObjectiveC.runtime;
@import Preferences.PSSpecifier;
@import Preferences.PSTableCell;
#import "../Managers/RueImageManager.h"


@protocol LukiTwitterCellDelegate

@required
- (void)lukiTwitterCellShouldPresentAlertController:(UIViewController *)controller;

@end


@interface LukiTwitterCell : PSTableCell {
	@public __weak id <LukiTwitterCellDelegate> delegate;
	@public NSURL *accountURL;
}
@end
