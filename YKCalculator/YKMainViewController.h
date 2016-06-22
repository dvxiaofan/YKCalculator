//
//  YKMainViewController.h
//  YKCalculator
//
//  Created by xiaofans on 16/6/22.
//  Copyright © 2016年 xiaofan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKMainViewController : UIViewController

@property (nonatomic, strong) UILabel *showLabel;           // 创建标签
@property (nonatomic, strong) NSMutableString *msgText;     // 标签显示文本
@property (nonatomic, copy) NSString *preMsg;               // 之前输入信息
@property (nonatomic, copy) NSString *signStr;              // 运算符

@end
