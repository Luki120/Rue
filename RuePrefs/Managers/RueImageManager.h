@import UIKit;


@interface RueImageManager : NSObject
- (NSURLSessionTask *)fetchImageWithURLString:(NSString *)urlString
	completion:(void (^)(UIImage *image, NSError *error))completion;
@end
