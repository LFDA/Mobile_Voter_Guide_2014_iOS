//
//  UIAlertViewWithCallback.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/6/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A wrapper around the UIAlertView that vies us a callback block (by implementing it's own delegate that calls our block)
//  This allows us to include a UIAlertView in any view without needing to implement a delegate for UIAlertView in the view we're using this
//
//  Based on https://stackoverflow.com/questions/9661900/is-there-easy-way-to-handle-uialertview-result-without-delegation/9662147#9662147

#import "UIAlertViewWithCallback.h"

@implementation UIAlertViewWithCallback

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.callback(buttonIndex);
}

+ (void)showAlertView:(UIAlertView *)alertView
         withCallback:(AlertViewCompletionBlock)callback {
    __block UIAlertViewWithCallback *delegate = [[UIAlertViewWithCallback alloc] init];
    alertView.delegate = delegate;
    delegate.callback = ^(NSInteger buttonIndex) {
        callback(buttonIndex);
        alertView.delegate = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        delegate = nil;
#pragma clang diagnostic pop
    };
    [alertView show];
}

@end
