//
//  UIView+WebCache.m
//  UICycleScrollViewDemo
//
//  Created by captain on 17/2/13.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import "UIView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char UIViewImageURLKey;

static NSString *operationKey = @"UIViewImageLoad";

@implementation UIView (WebCache)

-(void)sd_view_setImageWithURL:(NSURL*)url loadCompletionCallback:(sd_UIViewLoadImageCallback)callback
{
    [self sd_view_setImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        callback(image);
    }];
}

-(void)sd_view_cancelCurrentImageLoad
{
    [self sd_cancelImageLoadOperationWithKey:operationKey];
}

-(void)sd_view_setImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_view_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &UIViewImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (url) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_main_sync_safe(^{
                if (completedBlock && finished) {
                    completedBlock(image,error,cacheType,url);
                }
            });
        }];
        
        [self sd_setImageLoadOperation:operation forKey:operationKey];
    }
    else
    {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil,error, SDImageCacheTypeNone, url);
            }
        });
    }
}

@end
