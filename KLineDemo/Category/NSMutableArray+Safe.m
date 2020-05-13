//
//  NSMutableArray+Safe.m
//  Test
//
//  Created by iOS on 2019/9/5.
//  Copyright © 2019 徐义恒. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSMutableArray (Safe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //1、提示移除的数据不能为空
        [self swizzleSelector:@selector(removeObject:)
         withSwizzledSelector:@selector(hdf_safeRemoveObject:)];
        
        //2、提示数组不能添加为nil的数据
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(addObject:)
                                withSwizzledSelector:@selector(hdf_safeAddObject:)];
        //3、移除数据越界
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(removeObjectAtIndex:) withSwizzledSelector:@selector(hdf_safeRemoveObjectAtIndex:)];
        
        //4、插入数据越界
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(insertObject:atIndex:)
                                withSwizzledSelector:@selector(hdf_insertObject:atIndex:)];
        
        //5、处理[arr objectAtIndex:1000]这样的越界
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndex:) withSwizzledSelector:@selector(hdf_objectAtIndex:)];
        
        //6、处理arr[1000]这样的越界
        [objc_getClass("__NSArrayM") swizzleSelector:@selector(objectAtIndexedSubscript:) withSwizzledSelector:@selector(safeobjectAtIndexedSubscript:)];
        
    });
}

#pragma mark - 1. 提示移除的数据不能为空
- (void)hdf_safeRemoveObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s 移除的对象为：nil", __FUNCTION__);
        return;
    }
    
    [self hdf_safeRemoveObject:obj];
}

#pragma mark - 2. 数组不能添加为nil的数据
- (void)hdf_safeAddObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s 添加对象为：nil", __FUNCTION__);
    } else {
        [self hdf_safeAddObject:obj];
    }
}

#pragma mark - 3. 移除数据数组越界
- (void)hdf_safeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count <= 0) {
        NSLog(@"%s 该数组没有数据【无法移除】", __FUNCTION__);
        return;
    }
    
    if (index >= self.count) {
        NSLog(@"%s 移除数组越界", __FUNCTION__);
        return;
    }
    
    [self hdf_safeRemoveObjectAtIndex:index];
}

#pragma mark - 4. 插入数据越界
- (void)hdf_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        NSLog(@"%s 插入对象为：nil", __FUNCTION__);
    } else if (index > self.count) {
        NSLog(@"%s 插入对象数组越界", __FUNCTION__);
    } else {
        [self hdf_insertObject:anObject atIndex:index];
    }
}

#pragma mark - 5. 处理[arr objectAtIndex:1000]这样的越界
- (id)hdf_objectAtIndex:(NSUInteger)index {
    if (self.count == 0 || index < 0) {
        NSLog(@"%s 数组越界或索引异常", __FUNCTION__);
        return nil;
    }
    
    if (index > (self.count - 1)) {
        NSLog(@"%s 越界获取数组对象", __FUNCTION__);
        return nil;
    }
    
    return [self hdf_objectAtIndex:index];
}

#pragma mark - 6. 处理arr[1000]这样的越界
- (instancetype)safeobjectAtIndexedSubscript:(NSUInteger)index{
    
    if (self.count == 0 || index < 0) {
        NSLog(@"%s 数组越界或索引异常", __FUNCTION__);
        return nil;
    }
    
    if (index > (self.count - 1)) { // 数组越界
        NSLog(@"数组长度=%zd, 获取索引=%zd", self.count, index);
        return nil;
    }else { // 没有越界
        return [self safeobjectAtIndexedSubscript:index];
    }
}

@end
