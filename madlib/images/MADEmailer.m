//
//  MADEmailer.m
//  madlib
//
//  Created by Dan Baker on 12/24/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "MADEmailer.h"

@interface MADEmailer ()
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation MADEmailer

- (id)init
{
    self = [super init];
    self.subject = @"";
    self.body = @"";
    self.bodyIsHtml = NO;
    return self;
}

- (void)presentEmailViewViaController:(UIViewController*)viewController
{
    if (!viewController)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        viewController = window.rootViewController;
    }
    self.viewController = viewController;
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller)
    {
        controller.mailComposeDelegate = self;
        [controller setSubject:self.subject];
        [controller setMessageBody:self.body isHTML:self.bodyIsHtml];
        if (self.to) {
            [controller setToRecipients:@[self.to]];
        }
        [self.viewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent)
    {
        NSLog(@"Email sent");
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
