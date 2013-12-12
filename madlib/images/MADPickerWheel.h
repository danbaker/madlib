//
//  MADPickerWheel.h
//  madlib
//
//  Created by Dan Baker on 12/11/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MADPickerWheel : UIView<UIPickerViewDelegate>

@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) NSUInteger indexSelectedItem;

- (void)onChangeTarget:(id)target action:(SEL)selector;

@end
