//
//  MGLScannerQR.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/22.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "MGLScannerQR.h"
#import <AVFoundation/AVFoundation.h>
#import "ZXingObjC.h"

@interface MGLScannerQR ()<AVCaptureMetadataOutputObjectsDelegate,ZXCaptureDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) dispatch_queue_t outputQueue;
@property (strong, nonatomic) ZXCapture *capture;
@end
@implementation MGLScannerQR

- (void)addPreLayerOnView:(UIView *)view{
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer = previewLayer;
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [view.layer addSublayer:_previewLayer];
    [view.layer insertSublayer:_previewLayer atIndex:0];
}

- (instancetype)initStartReadingOnView:(UIView *)view{
    self = [super init];
    if (self) {
        if([[[UIDevice currentDevice] systemVersion] intValue] < 9.0){
            self.capture = [[ZXCapture alloc] init];
            self.capture.camera = self.capture.back;
            self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            self.capture.rotation = 90.0f;
            self.capture.layer.frame = view.bounds;
            [view.layer addSublayer:self.capture.layer];
            [view.layer insertSublayer:self.capture.layer atIndex:0];
            self.capture.delegate = self;
            return self;
        }else{
            //    获取设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //    建立输入源
            NSError * __autoreleasing err = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&err];
            if (err) {
                NSLog(@"%@", [err localizedDescription]);
                NSLog(@"建立输入源，失败");
            }else{
                //        建立程序桥梁，session:input,output
                AVCaptureSession *session = [[AVCaptureSession alloc] init];
                _session = session;
                if([session canAddInput:input]){
                    [session addInput:input];
                }
                AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
                if([session canAddOutput:output]){
                    [session addOutput:output];
                    
                    _outputQueue = dispatch_queue_create("avoutput", DISPATCH_QUEUE_SERIAL);
                    [output setMetadataObjectsDelegate:self queue:_outputQueue];
                    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
                }
                [self addPreLayerOnView:view];
                [_session startRunning];
            }
        }
    }
    return self;
}

- (void)adjustLayerWithFrame:(CGRect)frame{
    _previewLayer.frame = frame;
    self.capture.layer.frame = frame;
}
-(void)stopReading{
    [self cleanUp];
}

- (void)cleanUp{
    if (_session) {
        [_session stopRunning];
        _session = nil;
        [_previewLayer removeFromSuperlayer];
        _previewLayer = nil;
        _outputQueue = nil;
    }
    if (_capture) {
        [self.capture stop];
    }
}
- (void)dealloc{
    [self cleanUp];
}
- (void)sendMessage:(NSString *)message{
    _QRMessage(message);
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *rco = metadataObjects[0];
        if ([[rco type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(sendMessage:) withObject:[rco stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        }
    }
}

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    // We got a result. Display information about the result onscreen.
//        NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
//        NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    if (result.barcodeFormat == kBarcodeFormatQRCode) {
        [self performSelectorOnMainThread:@selector(sendMessage:) withObject:result.text waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
    }
    
    
    // Vibrate
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self.capture start];
//    });
}

@end
