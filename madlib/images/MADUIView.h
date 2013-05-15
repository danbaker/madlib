//
//  MADUIView.h
//  HexGrid
//
//  Created by Dan Baker on 11/26/12.
//  Copyright (c) 2012 Mark Hamilton. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MADUIView;

@protocol MADUIViewProtocol <NSObject>

@end

@interface MADUIView : UIView

@property (nonatomic, weak) id<MADUIViewProtocol> delegate;
@property (nonatomic, unsafe_unretained) SEL delegateAction;

@end
