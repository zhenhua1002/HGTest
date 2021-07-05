//
//  ViewReusePool.m
//  UITableView_Reuse
//
//  Created by 华哥Addie on 2021/6/22.
//

#import "ViewReusePool.h"

@interface ViewReusePool()

///等待使用的队列
@property (nonatomic, strong, readwrite) NSMutableSet *waitUsedQueue;

///使用中的队列
@property (nonatomic, strong, readwrite) NSMutableSet *usingQueue;

@end

@implementation ViewReusePool

- (instancetype)init {
    self = [super init];
    if (self) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return  self;
}

// 从重用池当中取出一个可重用的view
- (UIView *)dequeueReusableView {
    //1.从等待使用的队列中取出一个view
    UIView *view = [_waitUsedQueue anyObject];
    //1.1 若取出的view为空
    if (view == nil) {
        return  nil;
    } else {
        //1.2 不为空
        //2.进行队列移动
        //2.1将view从等待队列中移除，添加到正在使用中的队列中
        [_waitUsedQueue removeObject:view];
        [_usingQueue addObject:view];
        return  view;
    }
}

//向重用池当中添加一个视图
- (void)addUsingView:(UIView *)view {
    if (view == nil) {
        return;
    }
    
    //添加视图到使用中的队列
    [_usingQueue addObject:view];
}

//重置方法，将当前使用中的视图移动到可重用队列当中
- (void)reset {
    UIView *view = nil;
    
    while ((view = [_usingQueue anyObject])) {
        //从使用中的队列中移除
        [_usingQueue removeObject:view];
        //添加到等待使用的队列中
        [_waitUsedQueue addObject:view];
    }
}

@end
