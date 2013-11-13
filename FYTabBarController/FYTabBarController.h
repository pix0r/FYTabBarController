//
//  FYTabBarController.h
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/13/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYTabBar.h"

@class FYTabBarController;

@protocol FYTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(FYTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(FYTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface FYTabBarController : UIViewController <FYTabBarDataSource, FYTabBarDelegate>

@property (nonatomic, strong) id<FYTabBarControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray *tabTitles;
@property (nonatomic, strong) NSArray *tabImageNames;
@property (nonatomic, strong) NSArray *selectedTabImageNames;

@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet FYTabBar *tabBar;

@property (nonatomic, assign) CGFloat tabBarHeight;

+ (Class)tabBarClass;

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (NSString *)titleForTabAtIndex:(NSInteger)tabIndex;
- (NSString *)imageNameForTabAtIndex:(NSInteger)tabIndex;
- (NSString *)selectedImageNameForTabAtIndex:(NSInteger)tabIndex;

@end
