#import "Headers/Prefs.h"
#import "Headers/Headers.h"


@interface RueSearchView: UIView <UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *rueSearchBar;
@property (nonatomic, strong) NSLayoutConstraint *topAnchorConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthAnchorConstraint;
@end
