//
//  MGLScannerQR.h
//  QRCode
//
//  Created by kaxiaoer on 15/4/22.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MGLScannerQR : NSObject
@property (strong, nonatomic) void(^QRMessage)(NSString *message);
- (void)adjustLayerWithFrame:(CGRect)frame clearFrame:(CGRect)clearframe;
- (instancetype)initStartReadingOnView:(UIView *)view;
@end
