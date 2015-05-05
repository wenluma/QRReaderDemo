//
//  ViewController.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/17.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//  ZBarReaderController, 识别二维码

#import "QRViewController.h"
#import "UIView+MGLConstaint.h"
#import "MGLScannerQRView.h"
#import "MGLScannerQR.h"

#import <AVFoundation/AVFoundation.h>

@interface QRViewController ()
@property (strong, nonatomic) MGLScannerQR *scanner;
@property (weak, nonatomic) UIView *videoView;
@property (weak, nonatomic) MGLScannerQRView *anchorView;
@property (weak, nonatomic) UILabel *showLab;
@property (copy, nonatomic) NSString *QRCode;
@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatVideoView];
    self.scanner = [[MGLScannerQR alloc] initStartReadingOnView:self.videoView];
    QRViewController * __weak weakSelf = self;
    _scanner.QRMessage = ^(NSString *message){
        [weakSelf finishedScanner:message];
    };
}
- (void)finishedScanner:(NSString *)message{
    _QR(message);
    [self.navigationController popToRootViewControllerAnimated:YES];
}
// when use layoutcontraint  can  use viewDidLayoutSubviews to place layer.frame
- (void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
    [_scanner adjustLayerWithFrame:self.videoView.bounds clearFrame:(CGRect)_anchorView.frame];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

//    create view to show Video display
- (void)creatVideoView{
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:videoView];
    videoView.translatesAutoresizingMaskIntoConstraints = NO;
    videoView.backgroundColor = [UIColor clearColor];
    
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

- (void)addMyAnchorView{
    MGLScannerQRView *anchorView = [[MGLScannerQRView alloc] initWithDesc:@"将二维码置框内" withScanner:YES];
    [self.videoView addSubview:anchorView];
    anchorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [anchorView sameWidthHeight:200];
    [anchorView setCenterY:-40];
    [anchorView setCenterX:0];
    
    _anchorView = anchorView;
    MGLOverlayView * overlay= [[MGLOverlayView alloc] initWithView:_anchorView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc{
    [_anchorView stopAnimation];
    [_anchorView removeFromSuperview];
}
@end
