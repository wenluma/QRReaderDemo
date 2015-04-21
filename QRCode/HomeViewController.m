//
//  HomeViewController.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/20.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewController.h"
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
    };
    [DetectQRStillImage dectorSourceImage:[UIImage imageNamed:@"qr"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *vc = (ViewController *)segue.destinationViewController;
    vc.QR = _QRCode;
}

@end
