//
//  MGLScannerQRView.m
//  QRCode
//
//  Created by kaxiaoer on 15/4/20.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "MGLScannerQRView.h"
#import "UIView+MGLConstaint.h"

@interface MGLScannerQRView ()
@property (assign, nonatomic) BOOL isScanner;
@property (weak, nonatomic) UILabel *descLab;
@property (weak, nonatomic) CAGradientLayer *gradientlayer;
@end

@implementation MGLScannerQRView
- (instancetype)initWithDesc:(NSString *)desc withScanner:(BOOL)scanner{
    self = [super initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        [self initStatus];
        self.desc = desc;
        self.isScanner = scanner;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initStatus];
    }
    return self;
}
- (void)initStatus{
    [self addMyDescLab];
    [self addMyGradientlayer];
    self.layer.masksToBounds = YES;
    _isScanner = YES;
}
- (void)setDesc:(NSString *)desc{
    _desc = [desc copy];
    _descLab.text = _desc;
}
- (void)addMyDescLab{
    UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:descLab];
    _descLab = descLab;
    _descLab.textColor = [UIColor whiteColor];
    [_descLab setCenterX:0];
    [_descLab setCenterY:0];
}
- (void)addMyGradientlayer{
    CAGradientLayer *gradientlayer = [CAGradientLayer layer];
    [self.layer addSublayer:gradientlayer];
//    gradientlayer.backgroundColor = [[UIColor greenColor] CGColor];
    _gradientlayer = gradientlayer;
    NSMutableArray *mutAry = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i=80; i>0; i=i-4) {
        [mutAry addObject:[self gradientColor:i/255.f]];
    }
    _gradientlayer.colors = [NSArray arrayWithArray:mutAry];
    _gradientlayer.type = @"axial";
    _gradientlayer.startPoint = CGPointMake(0, 1);
    _gradientlayer.endPoint = CGPointZero;
    [self.layer insertSublayer:_gradientlayer atIndex:0];
    
}
- (id)gradientColor:(CGFloat)alpha{
    return (__bridge id)[[[UIColor greenColor] colorWithAlphaComponent:alpha] CGColor];
}
- (void)initGradientLayer{
    _gradientlayer.frame = CGRectMake(0, -CGRectGetHeight(self.bounds)*0.1, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)*0.1);
}
- (void)performAnimation{

    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.fromValue = @(0);
    animation.toValue = @(CGRectGetHeight(self.bounds));
    [animation setDuration:1.2];
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRepeatCount:MAXFLOAT];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [_gradientlayer addAnimation:animation forKey:@"animateGradient"];
}
- (void)layoutSubviews{
    [super layoutSubviews];//这个必须有，ios7
    [self initGradientLayer];
    [self performAnimation];
}
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (_isScanner) {
        [self performAnimation];
    }
}
- (void)stopAnimation{
    _isScanner = NO;
    [_gradientlayer removeAllAnimations];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef mutPath = CGPathCreateMutable();
    CGFloat h = CGRectGetHeight(rect);
    CGFloat w = CGRectGetWidth(rect);
    CGFloat lineL = 20;
    CGFloat lineW = 5;
    CGRect rects[] = {
        CGRectMake(0, 0, lineL, lineW),
        CGRectMake(h-lineL, 0, lineL, lineW),
        CGRectMake(0, h-lineW, lineL, lineW),
        CGRectMake(h-lineL, h-lineW, lineL, lineW),
        
        CGRectMake(0, 0, lineW, lineL),
        CGRectMake(w-lineW, 0, lineW, lineL),
        CGRectMake(0, w-lineL, lineW, lineL),
        CGRectMake(w-lineW, w-lineL, lineW, lineL),
                    };
    CGPathAddRects(mutPath, NULL, rects, 8);
    CGContextAddPath(context, mutPath);
    CGContextSetRGBFillColor(context, 10.f, 20.f, 30.f, 1);
    CGContextFillPath(context);
    CGPathRelease(mutPath);
}

@end
@interface MGLOverlayView ()
@property (weak, nonatomic) UIView *clearView;
@end
@implementation MGLOverlayView

- (instancetype)initWithView:(UIView *)view{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [view.superview addSubview:self];
        [self setEdge:UIEdgeInsetsZero];
        _clearView = view;
    }
    return self;
}

- (void)layoutSubviews{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect frame = rect;
    CGRect clearframe = _clearView.frame;
    
    CGFloat x1 = frame.origin.x;
    CGFloat x2 = clearframe.origin.x;
    CGFloat widht1 = frame.size.width;
    CGFloat height1 = frame.size.height;
    
    CGFloat y1 = frame.origin.y;
    CGFloat y2 = clearframe.origin.y;
    CGFloat width2 = clearframe.size.width;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(x1, y1, widht1, y2));
    CGPathAddRect(path, NULL, CGRectMake(x1, y1, x2-x1, height1));
    CGPathAddRect(path, NULL, CGRectMake(CGRectGetMaxX(clearframe), y1, widht1-width2-x2, height1));
    CGPathAddRect(path, NULL, CGRectMake(x1, CGRectGetMaxY(clearframe), widht1, height1 - CGRectGetMaxY(clearframe)));
    CGContextSetFillColorWithColor(ctx, [[[UIColor blackColor]  colorWithAlphaComponent:0.4] CGColor]);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CGPathRelease(path);
}

@end