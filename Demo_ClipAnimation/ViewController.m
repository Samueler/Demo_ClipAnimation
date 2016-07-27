//
//  ViewController.m
//  Demo_ClipAnimation
//
//  Created by 陈天宇 on 16/7/27.
//  Copyright © 2016年 Angry_Rookie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CAShapeLayer *_layer;
    BOOL animating;
}
@property (weak, nonatomic) IBOutlet UIView *whiteView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)draw:(id)sender {
    if (animating == YES) {
        return;
    }
    animating = YES;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(90, 90)];
    [path addLineToPoint:CGPointMake(90, 40)];
    
    [path addArcWithCenter:CGPointMake(65, 40) radius:25 startAngle:0 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(40, 90)];
    [path addArcWithCenter:CGPointMake(55, 90) radius:15 startAngle:M_PI endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(70, 50)];
    [path addArcWithCenter:CGPointMake(62, 50) radius:8 startAngle:0 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(54, 120)];
    
    _layer = [CAShapeLayer layer];
    _layer.path = path.CGPath;
    _layer.lineWidth = 5.0f;
    _layer.lineCap = kCALineCapRound;
    _layer.lineJoin = kCALineJoinRound;
    _layer.fillColor = [UIColor clearColor].CGColor;
    _layer.strokeColor = [UIColor greenColor].CGColor;
    [self.whiteView.layer addSublayer:_layer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.duration = 1.5f;
    animation.delegate = self;
    [_layer addAnimation:animation forKey:@"animationStrokeEnd"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    // 判断动画的类型
    if ([anim isEqual:[_layer animationForKey:@"animationStrokeEnd"]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CABasicAnimation *animationStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
            animationStart.fromValue = @(0.0f);
            animationStart.toValue = @(1.0f);
            animationStart.duration = 1.5f;
            animationStart.delegate = self;
            animationStart.fillMode = kCAFillModeForwards;
            animationStart.removedOnCompletion = NO;
            [_layer addAnimation:animationStart forKey:@"animationStrokeStart"];
        });
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isEqual:[_layer animationForKey:@"animationStrokeStart"]]) {
        [_layer removeAllAnimations];
        [_layer removeFromSuperlayer];
        animating = NO;
    }
}
@end
