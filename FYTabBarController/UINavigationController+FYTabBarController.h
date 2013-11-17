//
//  UINavigationController+FYTabBarController.h
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/17/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYTabBarController.h"

@interface UINavigationController (FYTabBarController)

- (FYTabBarController *)customTabBarController;
- (void)setCustomTabBarController:(FYTabBarController *)customTabBarController;

@end
