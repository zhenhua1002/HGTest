//
//  ViewController.m
//  UITableView_Reuse
//
//  Created by 华哥Addie on 2021/6/22.
//

#import "ViewController.h"
#import "IndexedTableView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,IndexedTableViewDataSource> {
    
    //声明带有索引的tableView
    IndexedTableView *tableView;
    UIButton *button;
    NSMutableArray *dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self initData];
}

- (void)initUI {
    //1.创建一个TableView
    tableView = [[IndexedTableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width,self.view.frame.size.height -60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //设置table的索引数据源
    tableView.indexedDataSource = self;
    
    [self.view addSubview:tableView];
    
    //2.创建一个用于reload的按钮
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"reloadTableView" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)initData {
    
    //数据源
    dataSource = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [dataSource addObject:@(i + 1)];
    }
}

#pragma mark - IndexedTableViewDataSource

- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView {
    
    //奇数次调用返回6个字母，偶数次调用返回11个
    static BOOL change = NO;
    
    if (change) {
        change = NO;
        return  @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K"];
    } else {
        change = YES;
        return @[@"A",@"B",@"C",@"D",@"E",@"F"];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier =@"reuseId";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    //如果重用池当中没有可重用的cell,那么创建一个cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //文案设置
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row] stringValue];
    
    return  cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  40;
}

- (void)doAction:(UIButton *)button {
    NSLog(@"reloadData");
    [tableView reloadData];
}
@end
