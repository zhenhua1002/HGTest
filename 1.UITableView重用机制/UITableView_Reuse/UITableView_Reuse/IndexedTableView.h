//
//  IndexedTableView.h
//  UITableView_Reuse
//
//  Created by 华哥Addie on 2021/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndexedTableViewDataSource <NSObject>

//获取一个TableView的字母索引条数据的方法
- (NSArray <NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView;

@end

@interface IndexedTableView : UITableView

@property (nonatomic, weak, readwrite) id <IndexedTableViewDataSource> indexedDataSource;

@end

NS_ASSUME_NONNULL_END
