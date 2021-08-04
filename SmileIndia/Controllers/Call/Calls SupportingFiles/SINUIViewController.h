//
//  SINLocalNotification.h
//  SinchCallingApp
//
//  Created by Arjun  on 26/02/20.
//  Copyright © 2020 Drove&Pace. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SINUIViewController : UIViewController

@property (nonatomic, readonly, assign) BOOL isAppearing;
@property (nonatomic, readonly, assign) BOOL isDisappearing;

- (void)dismiss;

@end
