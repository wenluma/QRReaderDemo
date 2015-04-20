//
//  UIView+MGLConstaint.h
//  LayoutDemo
//
//  Created by kaxiaoer on 15/4/16.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MGLConstaint)
// default to self to super view

- (void)setEdge:(UIEdgeInsets)edge;
- (void)setFrameLayout:(CGRect)frame;

- (void)startLayout:(BOOL)start;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;
- (void)setHeight:(CGFloat)height;
- (void)setWidth:(CGFloat)width;

- (void)setCenterX:(CGFloat)constant;
- (void)setCenterY:(CGFloat)constant;
- (void)setCenterX:(CGFloat)constant multiplier:(CGFloat)multiplier;
- (void)setCenterY:(CGFloat)constant multiplier:(CGFloat)multiplier;
- (void)setCenterX:(CGFloat)constant withView:(UIView *)secondItem;
- (void)setCenterY:(CGFloat)constant withView:(UIView *)secondItem;
- (void)centerXY:(NSLayoutAttribute)centerXY
        withView:(UIView *)secondItem
 secondAttribute:(NSLayoutAttribute)secondAttribute
        constant:(CGFloat)constant
      multiplier:(CGFloat)multipliter;

- (void)sameWidthHeight:(CGFloat)constant;

//aspect ratio
- (void)setRotia:(CGFloat)ratio
 layoutAttribute:(NSLayoutAttribute)attribute
        withView:(UIView *)secondItem;

- (void)equalAttribute:(NSLayoutAttribute)attribute withView:(UIView *)secondItem;
- (void)flusAttribute:(NSLayoutAttribute)attribute withView:(UIView *)secondItem;

//lab1-lab2  左右上下关系，相对位置关系
- (void)setAlignView:(UIView *)secondItem
         ofAttribute:(NSLayoutAttribute)attribute
           constant:(CGFloat)offset;

@end

@interface UIView (VisualLagnuageConstraint)
//    V: 则用 NSLayoutFormatAlignAllLeft, NSLayoutFormatAlignAllRight, NSLayoutFormatAlignAllLeading
//    NSLayoutFormatAlignAllTrailing， NSLayoutFormatAlignAllCenterX

//    如果 H 则，要用 垂直方向的 AttributeBottom,Top,BaseLine, centerY
//    bottom 已 lab1 的 alignRect.bottom 为准，

- (void)relateViewBings:(NSDictionary *)bings
                 visual:(NSString *)predite
          formatOptions:(NSLayoutFormatOptions)option;

@end