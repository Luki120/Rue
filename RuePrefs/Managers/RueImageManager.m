/*--- credits & slightly modified from ⇝ https://stackoverflow.com/a/66297487, good old objc guru ---*/

#import "RueImageManager.h"


#define Async(block) dispatch_async(dispatch_get_main_queue(), block)

typedef NS_CLOSED_ENUM(NSInteger, RueImageManagerError) {
	RueImageManagerErrorInvalidImage,
	RueImageManagerErrorInvalidURL,
	RueImageManagerErrorNetworkError
};


@implementation RueImageManager {

	NSCache<NSString *, UIImage *> *_imageCache;

}

- (id)init {

	self = [super init];
	if(!self) return nil;

	_imageCache = [NSCache new];

	return self;

}


- (NSURLSessionTask *)fetchImageWithURLString:(NSString *)urlString
	completion:(void(^)(UIImage *, NSError *))completion {

	UIImage *cachedImage = [_imageCache objectForKey: urlString];

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
			Async( ^{ completion(nil, error); });
			return;
		}

		if(!data)
			Async( ^{
				completion(nil, [self errorWithCode: RueImageManagerErrorNetworkError]);
			});

		UIImage *image = [UIImage imageWithData: data];

		if(!image)
			Async( ^{
				completion(nil, [self errorWithCode: RueImageManagerErrorInvalidImage]);
			});

		[_imageCache setObject:image forKey: urlString];
		Async( ^{ completion(image, nil); });

	}];

	[task resume];

	return task;

}


- (NSError *)errorWithCode:(RueImageManagerError)errorCode {

	return [NSError errorWithDomain:@"me.luki.rue" code:errorCode userInfo:nil];

}

@end
