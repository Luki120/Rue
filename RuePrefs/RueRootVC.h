#import "Headers/Constants.h"
#import "Headers/Headers.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSListController.h>


@interface RueRootVC : PSListController
@end


@interface RueLinksVC : PSListController
@end


@interface PSTableCell ()
- (void)setTitle:(NSString *)title;
@end


@interface RueTintCell : PSTableCell
@end
