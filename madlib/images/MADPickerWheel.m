//
//  MADPickerWheel.m
//  madlib
//
//  Created by Dan Baker on 12/11/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "MADPickerWheel.h"
#import "UIScreen+MAD.h"
#import "AGWindowView.h"

@interface MADPickerWheel ()
@property (nonatomic, retain) AGWindowView *wndView;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@end

@implementation MADPickerWheel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        [self addSubview:self.label];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tgr];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [self updateLabel];
}
-(void)setIndexSelectedItem:(NSUInteger)indexSelectedItem
{
    _indexSelectedItem = indexSelectedItem;
    [self updateLabel];
}

- (void)onChangeTarget:(id)target action:(SEL)selector
{
    self.target = target;
    self.selector = selector;
}

- (void)updateLabel
{
    NSString *item = @"";
    if (self.indexSelectedItem < self.items.count)
    {
        item = [self.items objectAtIndex:self.indexSelectedItem];
        if (self.target && self.selector)
        {
            [self.target performSelector:self.selector withObject:nil];
        }
    }
    if ([item isKindOfClass:[NSString class]])
    {
        self.label.text = item;
    }
}


- (void)tapGesture:(UIGestureRecognizer*)gr
{
    [self showPicker];
}

- (void)showPicker
{
    if (!self.picker)
    {
        self.wndView = [[AGWindowView alloc] initAndAddToKeyWindow];
        self.wndView.supportedInterfaceOrientations = AGInterfaceOrientationMaskAll;
        CGPoint rootZero = [self convertPoint:self.frame.origin toView:self.superview.superview];
        CGRect frame = self.frame;
        frame.origin.y = rootZero.y - 100;
        frame.origin.x -= 20;
        self.picker = [[UIPickerView alloc] initWithFrame:frame];
        self.picker.delegate = self;
        self.picker.showsSelectionIndicator = YES;
        self.picker.backgroundColor = [UIColor redColor];
        [self.wndView addSubview:self.picker];
        [self.picker selectRow:self.indexSelectedItem inComponent:0 animated:NO];
    } else {
        [self hidePicker];
    }
}
- (void)hidePicker
{
    [self.picker removeFromSuperview];
    self.picker = nil;
    [self.wndView removeFromSuperview];
    self.wndView = nil;
}


#pragma mark - Picker Delegate Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    // Handle the selection
    NSLog(@"SELECTED: %i  %@", row, [self.items objectAtIndex:row]);
    self.indexSelectedItem = row;
    [self hidePicker];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = self.items.count;
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    title = [self.items objectAtIndex:row];
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = self.bounds.size.width;
    return sectionWidth;
}

@end
