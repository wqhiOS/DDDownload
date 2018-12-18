//
//  DownloadCell.m
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import "DownloadCell.h"

@interface DownloadCell()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *catButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation DownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(0.1, 0.1), NO, UIScreen.mainScreen.scale);
    UIRectFill(CGRectMake(0, 0, 0.1, 0.1));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.slider setThumbImage:image forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)downloadButtonClick:(UIButton *)sender {
    if (self.clickDownloadButtonBlock) {
        self.clickDownloadButtonBlock();
    }
}
- (IBAction)catButtonClick:(UIButton *)sender {
    if (self.clickCatButtonBlock) {
        self.clickCatButtonBlock();
    }
}
- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (self.clickDeleteButtonBlock) {
        self.clickDeleteButtonBlock();
    }
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.slider.value = progress;
}
@end
