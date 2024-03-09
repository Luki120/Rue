@import ObjectiveC.runtime;
@import Preferences.PSSpecifier;
@import Preferences.PSTableCell;
#import "Headers/Common.h"
#import "../Categories/NSMutableAttributedString+Attributed.h"
#import "../Managers/RueImageManager.h"


@class LukiTwitterCell;
@protocol LukiTwitterCellDelegate

@required
- (void)lukiTwitterCell:(LukiTwitterCell *)cell shouldPresentAlertController:(UIAlertController *)alertController;

@end


@interface LukiTwitterCell : PSTableCell {
	@public __weak id <LukiTwitterCellDelegate> delegate;
	@public NSURL *accountURL;
}
@end
