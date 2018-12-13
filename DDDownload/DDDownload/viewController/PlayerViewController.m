//
//  PlayerViewController.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "PlayerViewController.h"
#import "DDPlayerView.h"
@interface PlayerViewController ()

@property(nonatomic, strong) DDPlayerView *playerView;

@end

@implementation PlayerViewController

- (void)dealloc {
    [self.playerView.player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    self.playerView = [[DDPlayerView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16)];
    [self.view addSubview:self.playerView];
}
- (void)setUrl:(NSString *)url {
    [self.playerView.player playWithUrl:url];
}


@end
