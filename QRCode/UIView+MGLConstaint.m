//
//  UIView+MGLConstaint.m
//  LayoutDemo
//
//  Created by kaxiaoer on 15/4/16.
//  Copyright (c) 2015年 miaogaoliang. All rights reserved.
//

#import "UIView+MGLConstaint.h"
static const BOOL usingLayout = YES;

@implementation UIView (MGLConstaint)
- (void)startLayout:(BOOL)start{
    self.translatesAutoresizingMaskIntoConstraints = !start;
}

- (void)setLeft:(CGFloat)left{
    [self setSuperEdgeType:NSLayoutAttributeLeading constant:left];
}

- (void)setRight:(CGFloat)right{
    [self setSuperEdgeType:NSLayoutAttributeTrailing constant:-right];
}

- (void)setTop:(CGFloat)top{
    [self setSuperEdgeType:NSLayoutAttributeTop constant:top];
}

- (void)setBottom:(CGFloat)bottom{
    [self setSuperEdgeType:NSLayoutAttributeBottom constant:-bottom];
}

// Edge :top,left,bottom,right
- (void)setEdge:(UIEdgeInsets)edge{
    [self setLeft:edge.left];
    [self setRight:edge.right];
    [self setTop:edge.top];
    [self setBottom:edge.bottom];
}
- (void)setFrameLayout:(CGRect)frame{
    [self setLeft:CGRectGetMinX(frame)];
    [self setTop:CGRectGetMinY(frame)];
    [self setWidth:CGRectGetWidth(frame)];
    [self setHeight:CGRectGetHeight(frame)];
}
- (void)setHeight:(CGFloat)height{
    [self setAttribute:NSLayoutAttributeHeight withConstant:height];
}
- (void)setWidth:(CGFloat)width{
    [self setAttribute:NSLayoutAttributeWidth withConstant:width];
}

- (void)setCenterX:(CGFloat)constant{
    [self setCenterX:constant withView:self.superview];
}
- (void)setCenterY:(CGFloat)constant{
    [self setCenterY:constant withView:self.superview];
}

- (void)setCenterX:(CGFloat)constant multiplier:(CGFloat)multiplier{
    [self centerXY:NSLayoutAttributeCenterX
          withView:self.superview
   secondAttribute:NSLayoutAttributeCenterX
          constant:constant
        multiplier:multiplier];
}
- (void)setCenterY:(CGFloat)constant multiplier:(CGFloat)multiplier{
    [self centerXY:NSLayoutAttributeCenterX
          withView:self.superview
   secondAttribute:NSLayoutAttributeCenterX
          constant:constant
        multiplier:multiplier];
}

- (void)setCenterX:(CGFloat)constant withView:(UIView *)secondItem{
    [self centerXY:NSLayoutAttributeCenterX
          withView:secondItem
    secondAttribute:NSLayoutAttributeCenterX
          constant:constant
        multiplier:1];
}

- (void)setCenterY:(CGFloat)constant withView:(UIView *)secondItem{
    [self centerXY:NSLayoutAttributeCenterY
          withView:secondItem
   secondAttribute:NSLayoutAttributeCenterY
          constant:constant multiplier:1];
}

- (void)centerXY:(NSLayoutAttribute)centerXY
        withView:(UIView *)secondItem
 secondAttribute:(NSLayoutAttribute)secondAttribute
        constant:(CGFloat)constant
      multiplier:(CGFloat)multipliter{
    NSLayoutConstraint *layoutContraint = [self checkSuperViewContaint:centerXY secondItem:secondItem secondAttribute:secondAttribute];
    if (layoutContraint) {
        layoutContraint.constant = constant;
        return;
    }
    layoutContraint = [NSLayoutConstraint constraintWithItem:self attribute:centerXY relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:secondAttribute multiplier:multipliter constant:constant];
    [self.superview addConstraint:layoutContraint];
}

- (void)sameWidthHeight:(CGFloat)constant{
    [self setHeight:constant];
    [self setWidth:constant];
}

// radio add to super View
- (void)setRotia:(CGFloat)ratio layoutAttribute:(NSLayoutAttribute)attribute withView:(UIView *)secondItem{
    
     NSLayoutConstraint *constaint = [self checkSuperViewContaint:attribute secondItem:secondItem secondAttribute:attribute];
    if (constaint) {
        [self.superview removeConstraint:constaint];
    }
    constaint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:attribute multiplier:ratio constant:0];
    [self.superview addConstraint:constaint];
}

// 2 views constraint add to super view, relate calculate on superview
- (void)equalAttribute:(NSLayoutAttribute)attribute withView:(UIView *)secondItem{
    
    NSLayoutConstraint *layoutConstaint = [self checkSuperViewContaint:attribute secondItem:secondItem secondAttribute:attribute];
    if (layoutConstaint) {
        return;
    }
    
    layoutConstaint =[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:attribute multiplier:1 constant:0];
    [self.superview addConstraint:layoutConstaint];
}

- (void)flusAttribute:(NSLayoutAttribute)attribute withView:(UIView *)secondItem{
    [self equalAttribute:attribute withView:secondItem];
}

- (void)setSuperEdgeType:(NSLayoutAttribute)attribute constant:(CGFloat)constant{
    NSAssert(self.superview, @"请添加到superview");
    NSAssert(!self.translatesAutoresizingMaskIntoConstraints,@"should set  translatesAutoresizingMaskIntoConstraints = NO");
    switch (attribute) {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTop:
        case NSLayoutAttributeBottom:
        case NSLayoutAttributeLeading:
        case NSLayoutAttributeTrailing:
        case NSLayoutAttributeCenterX:
        case NSLayoutAttributeCenterY:
        {
            NSLayoutConstraint *layoutConstraint = [self checkSuperViewContaint:attribute secondItem:self.superview secondAttribute:attribute];
            if (layoutConstraint) {
                layoutConstraint.constant = constant;
                return;
            }
            layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attribute multiplier:1 constant:constant];
            [self.superview addConstraint:layoutConstraint];
        }break;
            
        default:
            break;
    }
}

- (void)setAlignView:(UIView *)secondItem
       ofAttribute:(NSLayoutAttribute)attribute
         constant:(CGFloat)constant{
    
    NSLayoutAttribute firstAttr = attribute%2? attribute+1 : attribute-1;
    NSLayoutConstraint *layoutConstraint = [self checkSuperViewContaint:firstAttr secondItem:secondItem secondAttribute:attribute];
    if (layoutConstraint) {
        layoutConstraint.constant = constant;
        return;
    }
    
    layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:firstAttr relatedBy:NSLayoutRelationEqual toItem:secondItem attribute:attribute multiplier:1 constant:constant];
    [self.superview addConstraint:layoutConstraint];
}
- (NSLayoutConstraint *)checkSuperViewContaint:(NSLayoutAttribute)firstAttribute
                                    secondItem:(UIView *)secondItem
                               secondAttribute:(NSLayoutAttribute)secondAttribute{
    [self startLayout:usingLayout];
    NSLayoutConstraint * __block existConstaint = nil;
    BOOL __block isAdd = NO;
    if(secondItem){
        [self.superview.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
            if(obj.firstAttribute == firstAttribute
               && obj.firstItem == self
               && obj.secondItem == secondItem
               && obj.secondAttribute == secondAttribute){
                existConstaint = obj;
                isAdd = YES;
                *stop = YES;
            }
        }];
    }else{
        [self.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
            if(obj.firstAttribute == firstAttribute
               && obj.firstItem == self){
                existConstaint = obj;
                isAdd = YES;
                *stop = YES;
            }
        }];
    }
    
    if (isAdd && existConstaint){
        return existConstaint;
    }else{
        return nil;
    }
}
- (void)setAttribute:(NSLayoutAttribute)attribute withConstant:(CGFloat)constant{
    NSLayoutConstraint *layoutConstraint = [self checkSuperViewContaint:attribute secondItem:nil secondAttribute:attribute];
    if (layoutConstraint) {
        layoutConstraint.constant = constant;
        return;
    }
    layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:attribute multiplier:1 constant:constant];
    [self addConstraint:layoutConstraint];
}
@end

@implementation UIView (VisualLagnuageConstraint)

//@"H:|-100-[lab1(==100)]"        水平方法，x 轴上， left = 100 ，width = 100

//@"H:|-100-[lab1]-0-[lab2(==lab1)]-100-|      水平方法，left=right=100, lab2.width = lab1.widht,lab1.right = lab2.left

//containt View
//@"V:|-100-[lab2]-0-[lab1]-0-[lab3]-50-|

//@"H:|-100-[lab1]-0-[lab2]-100-|"
//predite = @"H:|-10-[view1]-20-[view2]-10-|"
//@"V:|-100-[lab2]-0-[lab1]-0-[lab3]-50-|"
//@"V:|-[lab1][lab2(==lab1)][lab3(==lab1)]-|"
//@"V:|-10-[lab1(==100)][lab2][lab3(==lab2)]-|"

- (void)relateViewBings:(NSDictionary *)bings
                 visual:(NSString *)predite
          formatOptions:(NSLayoutFormatOptions)option{
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:predite options:option metrics:nil views:bings];
    [self addConstraints:constraints];
}

@end