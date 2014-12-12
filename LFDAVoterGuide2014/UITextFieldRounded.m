//
//  UITextFieldRounded.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/5/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A custom UITextField that we can style

#import "UITextFieldRounded.h"

@implementation UITextFieldRounded

// Initialilze our custom UITextField
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

@end
