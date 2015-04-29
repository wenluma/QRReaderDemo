//
//  MGLScannerQRView.h
//  QRCode
//
//  Created by kaxiaoer on 15/4/20.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGLScannerQRView : UIView
- (instancetype)initWithDesc:(NSString *)desc withScanner:(BOOL)scanner;
- (void)stopAnimation;
@property (copy, nonatomic) NSString *desc;
@end
@interface MGLOverlayView : UIView
- (instancetype)initWithView:(UIView *)view;
@end