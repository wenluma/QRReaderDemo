//
//  MGLScannerQR.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/22.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "MGLScannerQR.h"
#import <AVFoundation/AVFoundation.h>

@interface MGLScannerQR ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) dispatch_queue_t outputQueue;
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
    return self;
}

- (void)adjustLayerWithFrame:(CGRect)frame{
    _previewLayer.frame = frame;
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
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *rco = metadataObjects[0];
        if ([[rco type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelector:@selector(setQRMessage:) onThread:[NSThread mainThread] withObject:[rco stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        }
    }
}

@end
