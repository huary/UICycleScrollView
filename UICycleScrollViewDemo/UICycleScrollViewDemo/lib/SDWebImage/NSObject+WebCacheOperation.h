//
//  NSObject+WebCacheOperation.h
//  DlodloVR
//
//  Created by captain on 16/6/23.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"

@interface NSObject (WebCacheOperation)

- (void)sd_obj_setImageLoadOperation:(id)operation forKey:(NSString *)key;

- (void)sd_obj_cancelImageLoadOperationWithKey:(NSString *)key;

- (void)sd_obj_removeImageLoadOperationWithKey:(NSString *)key;

@end
