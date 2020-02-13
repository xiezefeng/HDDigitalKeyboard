//
//  DigitalKeyboardView.h
//  HDDigitalKeyboardDemo
//
//  Created by 谢泽锋 on 2020/2/13.
//  Copyright © 2020 混沌网络科技. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol AmountInputDelegate <NSObject>
@optional
- (BOOL)amountInputText:(NSString *)text;
- (void)amountInputSure;
- (void)amountInputClean;
- (void)amountInputUpdate:(NSString *)text;

@end
typedef enum {
    InputKeyBoardTypeNumberWhile = 10,  //数字输入
    InputKeyBoardTypeNumberBlack = 15,  //数字黑底
    InputKeyBoardTypeAccount = 20,      //金额输入
} InputKeyBoardType;
@interface DigitalKeyboardView : UIView
@property (nonatomic, assign) BOOL isNextEnable;
@property (nonatomic, assign) BOOL isHasPoint;  //是否有小数点
@property (nonatomic, assign) UITextField *textfieldInputView;
@property (nonatomic, assign) id<AmountInputDelegate> delegate;

/**
 数字键盘

 @param textField 输入框
 @param inputKeyBoardType 键盘类型
 @param delegate 输入代理
 @return 键盘对象
 */
+ (instancetype)amountInputView:(UITextField *)textField
                      inputType:(InputKeyBoardType)inputKeyBoardType
                       delegate:(id<AmountInputDelegate>)delegate;

@end
