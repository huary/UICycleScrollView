//
//  UIView+WebCache.h
//  UICycleScrollViewDemo
//
//  Created by captain on 17/2/13.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sd_UIViewLoadImageCallback)(UIImage *image);

@interface UIView (WebCache)

-(void)sd_view_setImageWithURL:(NSURL*)url loadCompletionCallback:(sd_UIViewLoadImageCallback)callback;

@end
