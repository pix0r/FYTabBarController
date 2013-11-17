//
//  UINavigationController+FYTabBarController.m
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/17/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import "UINavigationController+FYTabBarController.h"
#import <objc/runtime.h>

const static NSString *kFYTabBarControllerAssociatedObjectKey = @"FYTabBarController";

@implementation UINavigationController (FYTabBarController)

- (FYTabBarController *)customTabBarController {
    FYTabBarController *customTabBarController = objc_getAssociatedObject(self, &kFYTabBarControllerAssociatedObjectKey);
    return customTabBarController;
}

- (void)setCustomTabBarController:(FYTabBarController *)customTabBarController {
    objc_setAssociatedObject(self, &kFYTabBarControllerAssociatedObjectKey, customTabBarController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
