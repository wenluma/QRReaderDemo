//
//  ViewController.h
//  QRCode
//
//  Created by kaxiaoer on 15/4/17.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRViewController : UIViewController
@property (strong, nonatomic) void(^QR)(NSString *);
@end

