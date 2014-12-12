//
//  UIImage+Overlay.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/24/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Code from https://stackoverflow.com/questions/19274789/change-image-tintcolor-in-ios7
//
//  This is an extension to UIImage so that we can TINT an image with a specific color. It was
//  originally created to be used in MainTabBarViewController to be able to tint our tab bar icons white!
//  

#import "UIImage+Overlay.h"

@implementation UIImage (Overlay)

// Tint an image with a specified color
- (UIImage *)imageWithColor:(UIColor *)color1
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color1 setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
