//
//  UIButton+FillColor.h
//  ViPayMerchant
//
//  Created by 谢泽锋 on 2019/10/21.
//  Copyright © 2019 混沌网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (FillColor)
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@property (nonatomic, strong) NSString *titleName;

@end

NS_ASSUME_NONNULL_END
