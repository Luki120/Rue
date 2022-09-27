@import Preferences.PSSpecifier;
@import Preferences.PSTableCell;
@import Preferences.PSListController;
#import "Headers/Common.h"

#define kRueTintColor [UIColor colorWithRed:0.74 green:0.45 blue:0.83 alpha: 1.0];

@interface RueRootVC : PSListController
@end


@interface RueLinksVC : PSListController
@end


@interface PSTableCell ()
- (void)setTitle:(NSString *)title;
@end


@interface RueTintCell : PSTableCell
@end
