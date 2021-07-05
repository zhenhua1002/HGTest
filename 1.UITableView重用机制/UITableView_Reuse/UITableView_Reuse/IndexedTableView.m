//
//  IndexedTableView.m
//  UITableView_Reuse
//
//  Created by 华哥Addie on 2021/6/22.
//

#import "IndexedTableView.h"
#import "ViewReusePool.h"

@interface IndexedTableView() {
    /// 装载字母索引控件的容器view
    UIView *containerView;
    /// 重用池
    ViewReusePool *reusePool;
}

@end

@implementation IndexedTableView

- (void)reloadData {
    [super reloadData];
    
    //懒加载：真正使用时才去创建
    //懒加载创建containerView
    if (containerView == nil) {
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor whiteColor];
        
        //为避免索引条随着tableView滚动出现问题，将容器添加在最上层
        [self.superview insertSubview:containerView aboveSubview:self];
    }
    
    //懒加载创建重用池reusePool
    if (reusePool == nil) {
        reusePool = [[ViewReusePool alloc] init];
    }
    
    //标记所有视图为可重用状态
    [reusePool reset];
    
    //reload字母索引条
    [self reloadIndexedBar];
}

- (void)reloadIndexedBar {
    
    //获取字母索引条的显示内容
    NSArray <NSString *> *arrayTitles = nil;
    //判定当时数据源是否响应数据源方法
    if ([self.indexedDataSource respondsToSelector:@selector(indexTitlesForIndexTableView:)]) {
        //响应时，用数据源方法向数据源提供方获取字母索引数组
        arrayTitles = [self.indexedDataSource indexTitlesForIndexTableView:self];
    }
    
    //判断字母索引条是否为空
    if (!arrayTitles || arrayTitles.count <= 0) {
        [containerView setHidden:YES];
        return;
    }
    
    //有字母索引条
    NSUInteger count = arrayTitles.count;
    CGFloat buttonW = 60;
    CGFloat buttonH = self.frame.size.height / count;
    for (int i = 0; i < arrayTitles.count; i++) {
        NSString *title = [arrayTitles objectAtIndex:i];
        
        //从重用池中取一个Button出来
        UIButton *button = (UIButton *)[reusePool dequeueReusableView];
        //如果没有可重用的button则重新创建一个
        if (button == nil) {
            button = [[UIButton alloc] initWithFrame:CGRectZero];
            button.backgroundColor = [UIColor whiteColor];
            
            //注册button到重用池当中
            [reusePool addUsingView:button];
            NSLog(@"新创建了一个button");
        } else {
            NSLog(@"button 重用了");
        }
        
        //添加button到父视图控件
        [containerView addSubview:button];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //设置button的坐标
        [button setFrame:CGRectMake(0, i * buttonH, buttonW, buttonH)];
    }
    
    [containerView setHidden:NO];
    containerView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - buttonW, self.frame.origin.y, buttonW, self.frame.size.height);
}

@end
