//
//  HomeViewController.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/20.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "HomeViewController.h"
#import "QRViewController.h"
#import "DetectQRStillImage.h"


@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showMessage;
@property (strong, nonatomic) void(^QRCode)(NSString *);
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * __weak lab = _showMessage;
    lab.numberOfLines = 0;
    _QRCode = ^(NSString *info){
        lab.text = info;
//        NSURL *url = [NSURL URLWithString:@"http://211.95.3.194:11113/webpage/webpage/aa.do?token=%@&random=%@"];
        
    };
//    [DetectQRStillImage dectorSourceImage:[UIImage imageNamed:@"qr"]];
    
//    CAShapeLayer *mask = [CAShapeLayer layer];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, CGRectMake(50, 100, 100, 100));
//    mask.path = path;
//    [self.view.layer setMask:mask];
    
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 400)];
//    view.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:view];
//    
//    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
//    layer.frame = view.bounds;
//    layer.fillColor = [[UIColor blackColor] CGColor];
//    
//    layer.path = CGPathCreateWithRect(CGRectMake(10, 10, 30, 30), NULL);
//    
//    view.layer.mask = layer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QRViewController *vc = (QRViewController *)segue.destinationViewController;
    vc.QR = _QRCode;
}

@end
