//
//  ViewController.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/17.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//  ZBarReaderController, 识别二维码

#import "ViewController.h"
#import "UIView+MGLConstaint.h"
#import "MGLScannerQRView.h"


#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) dispatch_queue_t outputQueue;

@property (weak, nonatomic) UIView *videoView;
@property (weak, nonatomic) MGLScannerQRView *anchorView;
@property (weak, nonatomic) UILabel *showLab;
@property (copy, nonatomic) NSString *QRCode;
@end

@implementation ViewController

- (void)startReading{
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
        [self addPreLayer];
        [_session startRunning];
    }
}

-(void)stopReading{
    [self cleanUp];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cleanUp{
    if (_session) {
        [_session stopRunning];
        _session = nil;
        [_previewLayer removeFromSuperlayer];
        _previewLayer = nil;
        _QR(self.QRCode);
        _outputQueue = nil;
        [_anchorView stopAnimation];
    }
}

- (void)dealloc{
    [self cleanUp];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [self creatVideoView];
    [self startReading];
}
// when use layoutcontraint  can  use viewDidLayoutSubviews to place layer.frame
- (void)viewDidLayoutSubviews{
    _previewLayer.frame = _videoView.bounds;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//    create view to show Video display
- (void)creatVideoView{
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:videoView];
    videoView.translatesAutoresizingMaskIntoConstraints = NO;
    videoView.backgroundColor = [UIColor darkGrayColor];
    
    [videoView setEdge:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.videoView = videoView;
    
    [self addMyAnchorView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:lab];
    lab.translatesAutoresizingMaskIntoConstraints = NO;
    [lab setTop:20];
    [lab setCenterX:0];
    _showLab = lab;
}
- (void)addPreLayer{
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    _previewLayer = previewLayer;
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoView.layer addSublayer:_previewLayer];
    [_videoView.layer insertSublayer:_previewLayer atIndex:0];
}
- (void)addMyAnchorView{
    MGLScannerQRView *anchorView = [[MGLScannerQRView alloc] initWithDesc:@"将二维码置框内" withScanner:YES];
    [self.videoView addSubview:anchorView];
    anchorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [anchorView sameWidthHeight:200];
    [anchorView setCenterY:-40];
    [anchorView setCenterX:0];
    
    _anchorView = anchorView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *rco = metadataObjects[0];
        if ([[rco type] isEqualToString:AVMetadataObjectTypeQRCode]) {
//            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
//            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
//            _isReading = NO;
            
            self.QRCode = [rco stringValue];
            [_showLab performSelector:@selector(setText:) onThread:[NSThread mainThread] withObject:self.QRCode  waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        }
    }
}
@end
