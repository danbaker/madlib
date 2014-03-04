//
//  MADEmailer.h
//  madlib
//
//  Created by Dan Baker on 12/24/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//
#ifdef MAD_INCLUDE_EMAILER
#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MADEmailer : NSObject <MFMailComposeViewControllerDelegate>
@property (nonatomic, retain) NSString *to;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, assign) BOOL bodyIsHtml;
- (void)presentEmailViewViaController:(UIViewController*)viewController;

@end
#endif
