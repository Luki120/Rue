#import "NSMutableAttributedString+Attributed.h"

@implementation NSMutableAttributedString (Attributed)

- (id)initWithFullString:(NSString *)fullString subString:(NSString *)subString {

	NSRange rangeOfSubString = [fullString rangeOfString: subString];
	NSRange rangeOfFullString = { 0, fullString.length };

	UIFont *fullStringFont = [UIFont systemFontOfSize: 16];

	NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
	paragraphStyle.paragraphSpacing = 0.10 * fullStringFont.lineHeight;

	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: fullString];

	[attributedString addAttribute:NSFontAttributeName value:fullStringFont range: rangeOfFullString];
	[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize: 11] range: rangeOfSubString];
	[attributedString addAttribute:NSForegroundColorAttributeName value:UIColor.labelColor range: rangeOfFullString];
	[attributedString addAttribute:NSForegroundColorAttributeName value:UIColor.secondaryLabelColor range: rangeOfSubString];
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range: rangeOfFullString];

	return [self initWithAttributedString: attributedString];

}

@end


