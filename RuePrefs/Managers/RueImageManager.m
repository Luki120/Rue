/*--- credits & slightly modified from ⇝ https://stackoverflow.com/a/66297487, good old objc guru ---*/

#import "RueImageManager.h"


typedef NS_CLOSED_ENUM(NSInteger, RueImageManagerError) {
	RueImageManagerErrorInvalidImage,
	RueImageManagerErrorInvalidURL,
	RueImageManagerErrorNetworkError
};


@implementation RueImageManager {

	NSCache<NSString *, UIImage *> *imageCache;

}

- (id)init {

	self = [super init];
	if(!self) return nil;

	imageCache = [NSCache new];

	return self;

}


- (NSURLSessionTask *)fetchImageWithURLString:(NSString *)urlString
	completion:(void(^)(UIImage *image, NSError *error))completion {

	UIImage *cachedImage = [imageCache objectForKey: urlString];

	if(cachedImage) {
		completion(cachedImage, nil);
		return nil;
	}

	NSURL *url = [NSURL URLWithString: urlString];
	if(!url) {
		completion(nil, [self errorWithCode: RueImageManagerErrorInvalidURL]);
		return nil;
	}

	NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithURL:url
		completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		if(error) {
			dispatch_async(dispatch_get_main_queue(), ^{ completion(nil, error); });
			return;
		}

		if(!data)
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil, [self errorWithCode: RueImageManagerErrorNetworkError]);
			});

		UIImage *image = [UIImage imageWithData: data];

		if(!image)
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(nil, [self errorWithCode: RueImageManagerErrorInvalidImage]);
			});

		[imageCache setObject:image forKey: urlString];
		dispatch_async(dispatch_get_main_queue(), ^{ completion(image, nil); });

	}];

	[task resume];

	return task;

}


- (NSError *)errorWithCode:(RueImageManagerError)errorCode {

	NSError *error = [NSError errorWithDomain:@"me.luki.rue" code:errorCode userInfo:nil];
	return error;

}

@end
