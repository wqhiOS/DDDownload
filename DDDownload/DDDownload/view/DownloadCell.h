//
//  DownloadCell.h
//  DDDownload
//
//  Created by wuqh on 2018/12/13.
//  Copyright © 2018 wuqh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadCell : UITableViewCell

@property(nonatomic, copy) void(^clickDownloadButtonBlock)(void);
@property(nonatomic, copy) void(^clickCatButtonBlock)(void);
@property(nonatomic, copy) void(^clickDeleteButtonBlock)(void);

@end

NS_ASSUME_NONNULL_END
