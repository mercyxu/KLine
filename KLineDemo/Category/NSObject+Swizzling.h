//
//  NSObject+Swizzling.h
//  Test
//
//  Created by iOS on 2019/9/5.
//  Copyright © 2019 徐义恒. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
