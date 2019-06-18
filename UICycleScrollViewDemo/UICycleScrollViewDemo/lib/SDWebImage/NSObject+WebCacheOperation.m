//
//  NSObject+WebCacheOperation.m
//  DlodloVR
//
//  Created by captain on 16/6/23.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import "NSObject+WebCacheOperation.h"
#import "objc/runtime.h"

static char loadOperationKey;

@implementation NSObject (WebCacheOperation)

-(NSMutableDictionary *)operationDictionary
{
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    if (operations) {
        return operations;
    }
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

- (void)sd_obj_setImageLoadOperation:(id)operation forKey:(NSString *)key
{
    [self sd_obj_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary setObject:operation forKey:key];
}

- (void)sd_obj_cancelImageLoadOperationWithKey:(NSString *)key
{
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    id operations = [operationDictionary objectForKey:key];
    if (operations) {
        if ([operations isKindOfClass:[NSArray class]]) {
            for (id <SDWebImageOperation> operation in operations) {
                if (operation) {
                    [operation cancel];
                }
            }
        }
        else if ([operations conformsToProtocol:@protocol(SDWebImageOperation)])
        {
            [(id<SDWebImageOperation>)operations cancel];
        }
        [operationDictionary removeObjectForKey:key];
    }
}

- (void)sd_obj_removeImageLoadOperationWithKey:(NSString *)key
{
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary removeObjectForKey:key];
}

@end
