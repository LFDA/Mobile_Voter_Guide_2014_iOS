//
//  UILabelPadded.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/4/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A custom UILabel that we can style

#import "UILabelPadded.h"

@implementation UILabelPadded

// Initialilze our custom label
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        self.topInset = 3;
        self.rightInset = 3;
        self.bottomInset = 3;
        self.leftInset = 3;
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor grayColor].CGColor;
        self.layer.backgroundColor=[UIColor whiteColor].CGColor;
        self.layer.cornerRadius=3.0; // rounded rectangle
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

// Correctly adjusts position and width to handle the insets
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = {self.topInset, self.leftInset, self.bottomInset, self.rightInset};
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

// Adds inset (padding) to the UILabel
- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {self.topInset, self.leftInset, self.bottomInset, self.rightInset};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
