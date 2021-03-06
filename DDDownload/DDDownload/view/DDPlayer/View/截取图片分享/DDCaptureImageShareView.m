//
//  DDCaptureImageShareView.m
//  DDPlayerProject
//
//  Created by wuqh on 2018/11/15.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DDCaptureImageShareView.h"
#import <Masonry/Masonry.h>
#import "DDPlayerTool.h"
#import "DDPlayerUIFactory.h"

@interface DDCaptureImageShareView()
{
    UIImage *_sharedImage;
}
@property(nonatomic, strong) UIImageView *sharedImageView;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UILabel *promptLabel;

@end

@implementation DDCaptureImageShareView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _sharedImage = image;
        self.sharedImageView.image = image;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    [self addSubview:self.backButton ];
    [self addSubview:self.sharedImageView];
    [self addSubview:self.promptLabel];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(33);
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 44 : 20);
        make.width.mas_equalTo(68);
        make.height.mas_equalTo(26);
    }];
    
    [self.sharedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(DDPlayerTool.isiPhoneX ? 34 + 36 : 36);
        if (DDPlayerTool.isiPhone5or4) {
            make.height.mas_equalTo(DDPlayerTool.screenWidth * 0.3);
            make.width.mas_equalTo(DDPlayerTool.screenWidth * 0.3 * 16 / 9);
        }else {
            make.height.mas_equalTo(DDPlayerTool.screenWidth * 0.4);
            make.width.mas_equalTo(DDPlayerTool.screenWidth * 0.4 * 16 / 9);
        }
        
        make.centerY.equalTo(self);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sharedImageView.mas_right).mas_offset(36);
        make.top.equalTo(self.sharedImageView).mas_offset(DDPlayerTool.isiPhone5or4 ? -24 : 0);
    }];
    
    NSArray *sharedItemTitleArray = @[@"微信好友",@"朋友圈",@"新浪微博",@"QQ"];
    NSArray *sharedItemImageArray = @[@"DDPlayer_Btn_Wechat",@"DDPlayer_Btn_Friend",@"DDPlayer_Btn_Weibo",@"DDPlayer_Btn_QQ"];
    UIStackView *stackView = [[UIStackView alloc] init];
    [self addSubview:stackView];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.spacing = 24;
    for (NSInteger i = 0 ; i < 4; i++) {
        UIButton *button = [DDPlayerUIFactory attributeButtonWithImage:[UIImage imageNamed:sharedItemImageArray[i]] title:sharedItemTitleArray[i] font:[DDPlayerTool PingFangSCRegularAndSize:15] titleColor:UIColor.whiteColor spacing:3.5];
        [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2000+i;
        [stackView addArrangedSubview:button];
    }
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sharedImageView);
        make.left.equalTo(self.promptLabel);
    }];
    
}
#pragma mark - action
- (void)backButtonClick:(UIButton *)button {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [self removeFromSuperview];
}
- (void)shareButtonClick:(UIButton *)button {
    if (self.shareButtonClickBlock) {
        self.shareButtonClickBlock(button.tag - 2000);
    }
}

#pragma mark - getter
- (UIImageView *)sharedImageView {
    if (!_sharedImageView) {
        _sharedImageView = [[UIImageView alloc]init];
    }
    return _sharedImageView;
}
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"取消" forState:UIControlStateNormal];
        [_backButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textColor = UIColor.whiteColor;
        _promptLabel.font = [DDPlayerTool PingFangSCRegularAndSize:15];
        _promptLabel.text = @"已保存到系统相册，可以分享给好友啦";
    }
    return _promptLabel;
}
@end
