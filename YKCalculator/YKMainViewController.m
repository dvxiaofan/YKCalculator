//
//  YKMainViewController.m
//  YKCalculator
//
//  Created by xiaofans on 16/6/22.
//  Copyright © 2016年 xiaofan. All rights reserved.
//

#import "YKMainViewController.h"


#define SCREEN [UIScreen mainScreen].bounds.size
#define STA_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define far 1
#define btnH (SCREEN.height - STA_HEIGHT - far * 5) / 7
#define btnW (SCREEN.width - far * 5) / 4
#define labelHeight (btnH * 2)


@interface YKMainViewController ()

@end

@implementation YKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLabel];
    
    [self creatButtons];
    self.msgText = [NSMutableString stringWithCapacity:9];
    self.preMsg = [[NSString alloc] init];
    self.signStr = [[NSString alloc] init];
    
    
}

#pragma mark - 创建显示标签

- (void)createLabel {
    
    //创建计算器显示标签
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, STA_HEIGHT, SCREEN.width, labelHeight)];
    self.showLabel.text = @"0";
    self.showLabel.font = [UIFont systemFontOfSize:60];
    self.showLabel.textAlignment = NSTextAlignmentRight;
    self.showLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.showLabel];
}

#pragma mark - 创建按键

-(void)creatButtons {
    NSArray *titlesArray = @[@"C", @"+/-", @"%", @"÷", @"7", @"8", @"9", @"×", @"4", @"5", @"6", @"-", @"1", @"2", @"3", @"+", @"0", @"", @".", @"="];
    SEL actions[20] = {@selector(btclear), @selector(btsiging), @selector(btmod), @selector(btsign:), @selector(number:), @selector(number:), @selector(number:), @selector(btsign:), @selector(number:), @selector(number:), @selector(number:), @selector(btsign:), @selector(number:), @selector(number:), @selector(number:), @selector(btsign:), @selector(zero), @selector(unuse), @selector(piont), @selector(btequal)};
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(far + (btnW + far) * j, STA_HEIGHT + labelHeight + (btnH + far) * i, btnW, btnH)];
            if (i * 4 + j == 16) {
                [btn setFrame:CGRectMake(far + (btnW + far) * j, STA_HEIGHT + labelHeight + (btnH + far) * i, btnW * 2 + far, btnH)];
            }
            if (i * 4 + j == 17) {
                [btn setFrame:CGRectMake(far + (btnW + far) * j, STA_HEIGHT + (btnH + far) + (btnH + far) * i, 0, 0)];
            }
            if (i == 0) {
                btn.backgroundColor = [UIColor lightGrayColor];
            }
            else {
                btn.backgroundColor = [UIColor grayColor];
            }
            //设置第四列颜色为橙色
            if ((i * 4 + j + 1) % 4 == 0) {
                btn.backgroundColor = [UIColor orangeColor];
                [btn setFrame:CGRectMake(far + (btnW + far) * j, STA_HEIGHT + labelHeight + (btnH + far) * i, btnW, btnH)];
            }
            //设置按钮显示文本
            [btn setTitle:titlesArray[i * 4 + j] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:20.0];
            [btn addTarget:self action:actions[i * 4 + j] forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
    }
}

#pragma mark - 各个符号按键

/**
 *  清除
 */
-(void)btclear {
    NSRange range = {0, self.msgText.length};
    [self.msgText deleteCharactersInRange:range];
    self.showLabel.text = @"0";
}

/**
 *  正负号
 */
-(void)btsiging {
    if (self.msgText.length == 0) {
        return;
    }
    if ([self.msgText characterAtIndex:0] == '-') {
        NSRange range = {0,1};
        [self.msgText replaceCharactersInRange:range withString:@""];
        self.showLabel.text = self.msgText;
    }
    else {
        NSString * str = [NSString stringWithFormat:@"-%@", self.msgText];
        [self.msgText setString:str];
        self.showLabel.text = self.msgText;
    }
}

/**
 *  百分号
 */
-(void)btmod {
    if (self.msgText.length == 0) {
        return;
    }
    else {
        double temp = [self.msgText doubleValue];
        temp = temp / 100;
        NSString * str = [NSString stringWithFormat:@"%g", temp];
        self.showLabel.text = str;
    }
}

/**
 *  计算符号
 */
-(void)btsign:(UIButton *)sender {
    self.preMsg = [self.msgText copy];
    [self.msgText setString:@""];
    self.signStr = sender.titleLabel.text;
}

/**
 *  数字
 */
-(void)number:(UIButton *)sender {
    [self.msgText appendString:sender.titleLabel.text];
    self.showLabel.text = self.msgText;
}

/**
 *  0
 */
-(void)zero {
    if (self.msgText.length == 0) {
        return;
    }
    else {
        [self.msgText appendString:@"0"];
        self.showLabel.text = self.msgText;
    }
}
-(void)unuse {
    NSLog(@"0");
}

/**
 *  小数点
 */
-(void)piont {
    if (self.msgText.length == 0) {
        [self.msgText setString:@"0"];
        self.showLabel.text = self.msgText;
    }
    else {
        NSRange range = [self.msgText rangeOfString:@"."];
        if (range.location == NSNotFound) {
            [self.msgText appendString:@"."];
            self.showLabel.text = self.msgText;
        }
        else {
            return;
        }
    }
}

/**
 *  等号
 */
-(void)btequal {
    double num1 = [self.preMsg doubleValue];
    double num2 = [self.msgText doubleValue];
    double sum = 0;
    if ([self.signStr isEqualToString:@"+"]) {
        sum = num1 + num2;
    }
    else if ([self.signStr isEqualToString:@"-"]) {
        sum = num1 - num2;
    }
    else if ([self.signStr isEqualToString:@"×"]) {
        sum = num1 * num2;
    }
    else if([self.signStr isEqualToString:@"÷"]) {
        sum = num1 / num2;
    }
    NSString *str = [NSString stringWithFormat:@"%g", sum];
    self.showLabel.text = str;
    [self.msgText setString:@""];
}



@end












