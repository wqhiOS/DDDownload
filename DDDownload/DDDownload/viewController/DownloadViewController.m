//
//  DownloadViewController.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadCell.h"
#import "PlayerViewController.h"

@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"DownloadCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cellId"];
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/82393f5ce70745bea85701ddaab447b5_512.mp4",
                       @"http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/94f5c04bd2164d4e9d77d6cb8a7de87e_512.mp4",
                       @"http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/9e2462f0a54e474e83c005d8989d52c1_512.mp4",
                       @"http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/bad0d13346314014a8aa3197352c7f43_512.mp4",
                       @"http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201804/5a165205fb924d709e7a6449653bb63f_512.mp4"].mutableCopy;
    }
    return _dataArray;
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSString *url = self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.clickDownloadButtonBlock = ^{
        [DDDownloadManager.sharedManager downloadWithUrl:url];
        [NSNotificationCenter.defaultCenter addObserverForName:url.md5 object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            DDDownloadModel *model = note.userInfo[@"downloadModel"];
            if (model) {
                DownloadCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.progress = model.progress;
            }
        }];
    };
    cell.clickCatButtonBlock = ^{
        PlayerViewController *vc = [PlayerViewController new];
        vc.url = url;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.clickDeleteButtonBlock = ^{
        
    };
    return cell;
}

@end
