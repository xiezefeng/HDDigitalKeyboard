//
//  DigitalKeyboardView.m
//  HDDigitalKeyboardDemo
//
//  Created by 谢泽锋 on 2020/2/13.
//  Copyright © 2020 混沌网络科技. All rights reserved.
//


#import "DigitalKeyboardView.h"
#import "UIButton+FillColor.h"
#import "UIColor+Extension.h"
@interface DigitalKeyboardView ()
@property (nonatomic, strong) UIButton *point_BT;
@property (nonatomic, assign) InputKeyBoardType inputKeyBoardType;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSMutableArray *numberKeyboardAllButtonArray;

@end
#define kScreenWidth      [[UIScreen mainScreen] bounds].size.width

@implementation DigitalKeyboardView
- (void)setIsNextEnable:(BOOL)isNextEnable {
    _isNextEnable = isNextEnable;
    if (isNextEnable) {
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#7190d7"];
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.backgroundColor = [UIColor colorWithHexString:@"#e4e5ea"];
        self.nextButton.enabled = NO;
    }
}

+ (instancetype)amountInputView:(UITextField *)textField
                      inputType:(InputKeyBoardType)inputKeyBoardType
                       delegate:(id<AmountInputDelegate>)delegate {

    DigitalKeyboardView *inputView;
    switch (inputKeyBoardType) {
        case InputKeyBoardTypeAccount: {
            inputView = [DigitalKeyboardView accountInputView];

        } break;
        case InputKeyBoardTypeNumberBlack:
        case InputKeyBoardTypeNumberWhile:

        {
            inputView = [DigitalKeyboardView numberInputView:inputKeyBoardType];
        }

        break;
        default:
            break;
    }
    inputView.delegate = delegate;
    inputView.textfieldInputView = textField;
    inputView.inputKeyBoardType = inputKeyBoardType;
    textField.inputView = inputView;
    return inputView;
}

+ (DigitalKeyboardView *)accountInputView {
    CGFloat adjust = 0;

    if (@available(iOS 11.0, *)) {
        //Account for possible notch
        UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
        adjust = safeArea.bottom;
    }

    DigitalKeyboardView *inputView = [[DigitalKeyboardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.7 + adjust)];
    NSArray *array = @[@"1", @"2", @"3", @"del",
                       @"4", @"5", @"6", @"C",
                       @"7", @"8", @"9", @"下一步",
                       @".", @"0", @"00", @"下一步"];
    double border = 1;
    float unitW = (inputView.frame.size.width - 3.0 * border) / 4.0;
    float unitH = (inputView.frame.size.height - adjust + 3.0 * border) / 4.0;
    for (int i = 0; i < 15; i++) {
        UIButton *unit;
        if (i == 11) {
            unit = [UIButton buttonWithType:UIButtonTypeCustom];
            unit.frame = CGRectMake((unitW + border) * (i % 4), (unitH + border) * (i / 4), unitW, unitH * 2 + border);
            [unit setTitle:@"下一步" forState:0];
            unit.titleLabel.font = [UIFont systemFontOfSize:25];
            unit.backgroundColor = [UIColor colorWithHexString:@"#7190d7"];
            [unit addTarget:inputView action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
            inputView.nextButton = unit;
            //            [unit setBackgroundColor:[UIColor colorWithHexString:@"#3F3F3F"] forState:UIControlStateHighlighted];
        } else {
            unit = [[UIButton alloc] initWithFrame:CGRectMake((unitW + border) * (i % 4), (unitH + border) * (i / 4), unitW, unitH)];
            if (i == 3) {
                [unit setImage:[UIImage imageNamed:@"ic_del"] forState:0];
                [unit addTarget:inputView action:@selector(inputVIewDeleteNum:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [unit setTitle:array[i] forState:0];
                if (i == 7) {
                    [unit addTarget:inputView action:@selector(inputVIewClean:) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    [unit addTarget:inputView action:@selector(inputViewEnterNum:) forControlEvents:UIControlEventTouchUpInside];
                }
                if (i == 12) {
                    inputView.point_BT = unit;
                }
            }

            [unit setTitleColor:[UIColor colorWithHexString:@"#222847"] forState:0];
            unit.titleLabel.font = [UIFont systemFontOfSize:30];
            unit.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        }
        [inputView addSubview:unit];
    }

    inputView.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1];
    return inputView;
}
+ (DigitalKeyboardView *)numberInputView:(InputKeyBoardType)inputKeyBoardType {
    CGFloat adjust = 0;

    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeArea = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
        adjust = safeArea.bottom;
    }
    double border = 7;
    float unitW = (kScreenWidth - 4 * border) / 3;
    float unitH = unitW * (46.0 / 117.0);
    DigitalKeyboardView *amount = [[DigitalKeyboardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, unitH * 4 + adjust + 5 * border + 30)];
    UILabel *topTitle_LB = [[UILabel alloc] initWithFrame:CGRectMake(0, border / 2, kScreenWidth, 30)];
    [amount addSubview:topTitle_LB];
    topTitle_LB.text = [NSString stringWithFormat:@"- %@ -", @"安全键盘"];  // @"- ViPay安全键盘 -";
    topTitle_LB.textAlignment = NSTextAlignmentCenter;
    topTitle_LB.font = [UIFont systemFontOfSize:15];
    topTitle_LB.textColor = [UIColor colorWithHexString:@"#777777"];

    amount.inputKeyBoardType = inputKeyBoardType;

    return amount;
}
- (void)setInputKeyBoardType:(InputKeyBoardType)inputKeyBoardType {
    _inputKeyBoardType = inputKeyBoardType;
    switch (inputKeyBoardType) {

        case InputKeyBoardTypeNumberWhile: {
            self.backgroundColor = [UIColor colorWithHexString:@"#E4E5EA"];  //白色
            for (int i = 0; i < self.numberKeyboardAllButtonArray.count - 1; i++) {
                UIButton *unit = self.numberKeyboardAllButtonArray[i];
                unit.backgroundColor = [UIColor whiteColor];
                [unit setTitleColor:[UIColor colorWithHexString:@"#777777"] forState:UIControlStateNormal];
                [unit setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateNormal];
                [unit setBackgroundColor:[UIColor colorWithHexString:@"#F1F2F4"] forState:UIControlStateHighlighted];
            }
        } break;
        case InputKeyBoardTypeNumberBlack: {
            for (int i = 0; i < self.numberKeyboardAllButtonArray.count - 1; i++) {
                UIButton *unit = self.numberKeyboardAllButtonArray[i];
                self.backgroundColor = [UIColor colorWithHexString:@"#292929"];
                [unit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [unit setBackgroundColor:[UIColor colorWithHexString:@"#343434"] forState:UIControlStateNormal];
                [unit setBackgroundColor:[UIColor colorWithHexString:@"#3F3F3F"] forState:UIControlStateHighlighted];
            }
        } break;
        default:
            break;
    }
}

- (void)setIsHasPoint:(BOOL)isHasPoint {
    if (isHasPoint) {
        [self.point_BT setTitle:@"." forState:UIControlStateNormal];
        self.point_BT.titleLabel.text = @".";

    } else {
        [self.point_BT setTitle:@"" forState:UIControlStateNormal];
        self.point_BT.titleLabel.text = @"";
    }
}

- (void)sure:(UIButton *)unit {
    if ([self.delegate respondsToSelector:@selector(amountInputSure)]) {
        [self.delegate amountInputSure];
        //        [unit addTarget:self.delegate action:@selector(amountInputSure) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.textfieldInputView resignFirstResponder];
    }
}
- (void)inputVIewClean:(UIButton *)unit {
    self.textfieldInputView.text = @"";
    [self inputVIewDeleteNum:unit];
    if ([self.delegate respondsToSelector:@selector(amountInputClean)]) {
        [self.delegate amountInputClean];
    }
}
- (void)inputVIewDeleteNum:(UIButton *)unit {
    [self isSplitAmount:NO];
    NSMutableString *outted = [self.textfieldInputView.text copy];
    if ([self.textfieldInputView.text length] > 0) {
        self.textfieldInputView.text = [outted substringToIndex:([outted length] - 1)];  // 去掉最后一个","
    }
    if ([self.delegate respondsToSelector:@selector(amountInputClean)]) {
        [self.delegate amountInputClean];
    }
    [self isSplitAmount:YES];
}

- (void)isSplitAmount:(BOOL)isSplit {
    switch (self.inputKeyBoardType) {
        case InputKeyBoardTypeAccount: {
            if ([self.textfieldInputView.text rangeOfString:@"."].length || self.textfieldInputView.text.length == 0)  //输入 . 或者包含小数点不做处理
            {
                return;
            }
            if (isSplit)  //千分符号
            {
                self.textfieldInputView.text = [self.textfieldInputView.text stringByReplacingOccurrencesOfString:@"," withString:@""];
//                self.textfieldInputView.text = [HDCommonUtils thousandSeparatorNoCurrencySymbolWithAmount:self.textfieldInputView.text CurrencyCode:CURRENCE_TYPE_KHR];
            } else {
                self.textfieldInputView.text = [self.textfieldInputView.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
        } break;

        default:
            break;
    }
}
- (void)inputViewEnterNum:(UIButton *)sender {
    switch (self.inputKeyBoardType) {
        case InputKeyBoardTypeAccount: {
            if ([sender.titleLabel.text isEqualToString:@"."] || [self.textfieldInputView.text rangeOfString:@"."].length)  //输入 . 或者包含小数点
            {

            } else {
                [self isSplitAmount:NO];
            }

            if ([self.delegate respondsToSelector:@selector(amountInputText:)]) {
                if ([self.delegate amountInputText:[NSString stringWithFormat:@"%@%@", self.textfieldInputView.text, sender.titleLabel.text]]) {
                    self.textfieldInputView.text = [NSString stringWithFormat:@"%@%@", self.textfieldInputView.text, sender.titleLabel.text];
                    if ([self.delegate respondsToSelector:@selector(amountInputUpdate:)]) {
                        [self.delegate amountInputUpdate:self.textfieldInputView.text];
                    }
                }
            }
            [self isSplitAmount:YES];
        }

        break;

        default:

            if ([self.delegate respondsToSelector:@selector(amountInputText:)]) {
                if ([self.delegate amountInputText:[NSString stringWithFormat:@"%@%@", self.textfieldInputView.text, sender.titleLabel.text]]) {

                    self.textfieldInputView.text = [NSString stringWithFormat:@"%@%@", self.textfieldInputView.text, sender.titleLabel.text];
                    if ([self.delegate respondsToSelector:@selector(amountInputUpdate:)]) {
                        [self.delegate amountInputUpdate:self.textfieldInputView.text];
                    }
                }
            }
            break;
    }
}
/** @lazy <#item#> */
- (NSMutableArray *)numberKeyboardAllButtonArray {
    if (!_numberKeyboardAllButtonArray) {
        _numberKeyboardAllButtonArray = [[NSMutableArray alloc] init];
        NSArray *array = @[@"1", @"2", @"3",
                           @"4", @"5", @"6",
                           @"7", @"8", @"9",
                           @"", @"0", @"keyboard_del"];
        double border = 7;
        float unitW = (kScreenWidth - 4 * border) / 3;
        float unitH = unitW * (46.0 / 117.0);

        for (int i = 0; i < array.count; i++) {
            UIButton *unit;
            if (i == 11) {
                unit = [UIButton buttonWithType:UIButtonTypeCustom];
                [unit setImage:[UIImage imageNamed:@"keyboard_del"] forState:0];
                [unit addTarget:self action:@selector(inputVIewDeleteNum:) forControlEvents:UIControlEventTouchUpInside];
                unit.backgroundColor = [UIColor colorWithHexString:@"#5A7CCB"];
                unit.frame = CGRectMake(border + (unitW + border) * (i % 3), 30 + border + (unitH + border) * (i / 3), unitW, unitH);
                [_numberKeyboardAllButtonArray addObject:unit];

            } else {
                unit = [[UIButton alloc] initWithFrame:CGRectMake(border + (unitW + border) * (i % 3), 30 + border + (unitH + border) * (i / 3), unitW, unitH)];
                [unit setTitle:array[i] forState:0];
                if (i != 9) {
                    [unit addTarget:self action:@selector(inputViewEnterNum:) forControlEvents:UIControlEventTouchUpInside];
                }
                [unit setTitleColor:[UIColor colorWithHexString:@"#222847"] forState:0];
                unit.titleLabel.font = [UIFont systemFontOfSize:30];
                unit.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:0.1];
                [_numberKeyboardAllButtonArray addObject:unit];
            }

            unit.layer.cornerRadius = 5;
            unit.layer.borderWidth = 0.01;
            unit.layer.masksToBounds = YES;

            [self addSubview:unit];
        }
    }
    return _numberKeyboardAllButtonArray;
}




@end


