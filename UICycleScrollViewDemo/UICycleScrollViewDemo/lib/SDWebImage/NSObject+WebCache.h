//
//  NSObject+WebCache.h
//  DlodloVR
//
//  Created by captain on 16/6/23.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

typedef void(^sd_NSObjectLoadImageCallBack)(NSString *filePath);

@interface NSObject (WebCache)

- (void)sd_obj_setImageWithURL:(NSURL *)url loadCompletionCallBack:(sd_NSObjectLoadImageCallBack)callback;

@end
