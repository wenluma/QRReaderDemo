//
//  DetectQRStillImage.h
//  QRCode
//
//  Created by kaxiaoer on 15/4/21.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DetectQRStillImage : NSObject
+ (NSString *)dectorSourceImage:(UIImage *)sourceImage __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_8_0);
@end
