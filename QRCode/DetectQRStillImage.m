//
//  DetectQRStillImage.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/21.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "DetectQRStillImage.h"

@implementation DetectQRStillImage
+ (NSString *)dectorSourceImage:(UIImage *)sourceImage{
    NSDictionary *detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
    CIDetector *QRDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:detectorOptions];
    NSArray *features = [QRDetector featuresInImage:[CIImage imageWithCGImage:sourceImage.CGImage]
                                            options:@{CIDetectorImageOrientation:@(UIImageOrientationUp)}];
    CIQRCodeFeature *QR = features[0];
    if (QR) {
        return QR.messageString;
    }
    return nil;
}
@end
