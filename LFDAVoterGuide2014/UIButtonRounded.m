//
//  UIButtonRounded.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/6/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Styles UIButton in a specific way, among other things, places the image to the RIGHT of the button

#import "UIButtonRounded.h"

@implementation UIButtonRounded

// Initialilze our custom UIButton
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor grayColor].CGColor;
        self.layer.backgroundColor=[UIColor whiteColor].CGColor;
        self.layer.cornerRadius=5.0; // rounded rectangle
        self.layer.masksToBounds=YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left;
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    return frame;
}

@end
