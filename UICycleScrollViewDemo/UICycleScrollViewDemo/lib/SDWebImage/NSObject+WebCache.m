//
//  NSObject+WebCache.m
//  DlodloVR
//
//  Created by captain on 16/6/23.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import "NSObject+WebCache.h"
#import "objc/runtime.h"
#import "NSObject+WebCacheOperation.h"

static char imageURLKey;
//static char imageCacheKey;

static NSString *operationKey=@"NSObjectImageLoad";

static const char *dispatch_queue_name = "NSObjectLoadImageQueue";

//@interface OBJ_ImageCacheManager : NSObject
//
//@property (nonatomic, strong) NSMutableDictionary *cache;
//
//+(instancetype)shareManager;
//
//-(void)addObject:(id)obj forKey:(id)key;
//
//-(id)valueForKey:(id)key;
//
//@end
//
//@implementation OBJ_ImageCacheManager
//
//+(instancetype)shareManager
//{
//    
//}
//
//-(void)addObject:(id)obj forKey:(id)key
//{
//    
//}
//
//-(id)valueForKey:(NSString *)key
//{
//    return [self.cache objectForKey:key];
//}
//
//@end

@implementation NSObject (WebCache)

//-(NSMutableDictionary*)imageCache
//{
//    NSMutableDictionary *cacheDict = objc_getAssociatedObject(self, &imageCacheKey);
//    if (cacheDict) {
//        return cacheDict;
//    }
//    cacheDict = [NSMutableDictionary dictionary];
//    objc_setAssociatedObject(self, &imageCacheKey, cacheDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    return cacheDict;
//}

- (void)sd_obj_setImageWithURL:(NSURL *)url loadCompletionCallBack:(sd_NSObjectLoadImageCallBack)callback
{
//    [self sd_obj_setImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            NSString *fileName = [NSString stringWithFormat:@"%@.png",[DataHelper md5HexDigest:[url absoluteString]]];
//            NSData *imageData = UIImagePNGRepresentation(image);
//            NSString *filePath = [Utils applicationTmpDirectory:fileName];
//            [imageData writeToFile:filePath atomically:NO];
//            callback(filePath);
//        }
//        else
//        {
//            callback(nil);
//        }
//    }];
}

- (void)sd_obj_cancelCurrentImageLoad {
    [self sd_obj_cancelImageLoadOperationWithKey:operationKey];
}

- (void)sd_obj_setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    
    [self sd_obj_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
//    WEAK_SELF(weakSelf);
    if (url) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_async(dispatch_queue_create(dispatch_queue_name, NULL), ^{
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_obj_setImageLoadOperation:operation forKey:operationKey];
    } else {
        dispatch_async(dispatch_queue_create(dispatch_queue_name, NULL), ^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

@end
