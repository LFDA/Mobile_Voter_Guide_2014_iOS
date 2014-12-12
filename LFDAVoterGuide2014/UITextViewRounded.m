//
//  UITextViewRounded.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/5/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A custom UITextView that we can style AND that can be set to GROW with the content it contains!

#import "UITextViewRounded.h"

@implementation UITextViewRounded

// Initialilze our custom UITextView
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

// Sets the text and after the system figures out the height required (sizeThatFits), changes the HEIGHT constraint for the
// object (set originally in IB) as sets it as needed so that the UITextView fits our content!
- (void)setTextWithGrowingFrame:(NSString *)text{
    self.text = text;
    CGSize sizeThatShouldFitTheContent = [self sizeThatFits:self.frame.size];
    for (NSLayoutConstraint *c in self.constraints) {
        if (c.firstAttribute==NSLayoutAttributeHeight){
            // Ok, it's a height constraint, so we reset it BUT only if we're growing (we don't want to reduce)
            if (sizeThatShouldFitTheContent.height > c.constant) c.constant = sizeThatShouldFitTheContent.height;
        }
    }
    self.scrollEnabled=NO;
}

@end
