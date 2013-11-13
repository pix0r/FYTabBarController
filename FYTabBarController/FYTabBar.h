//
//  FYTabBar.h
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/13/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FYTabBar;

@protocol FYTabBarDataSource <NSObject>
@required
- (NSInteger)numberOfTabsInTabBar:(FYTabBar *)tabBar;
@optional
- (NSString *)tabBar:(FYTabBar *)tabBar titleForTabAtIndex:(NSInteger)tabIndex;
- (NSString *)tabBar:(FYTabBar *)tabBar imageNameForTabAtIndex:(NSInteger)tabIndex;
- (NSString *)tabBar:(FYTabBar *)tabBar selectedImageNameForTabAtIndex:(NSInteger)tabIndex;
@end

@protocol FYTabBarDelegate <NSObject>
- (BOOL)tabBar:(FYTabBar *)tabBar shouldSelectTabAtIndex:(NSInteger)tabIndex;
- (void)tabBar:(FYTabBar *)tabBar didSelectTabAtIndex:(NSInteger)tabIndex;
@end

@interface FYTabBar : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<FYTabBarDataSource> dataSource;
@property (nonatomic, weak) id<FYTabBarDelegate> delegate;

@property (nonatomic, strong) UIColor *tabTitleColor;
@property (nonatomic, strong) UIColor *selectedTabTitleColor;
@property (nonatomic, strong) UIColor *selectedTabTintColor;
@property (nonatomic, strong) UIImage *tabBackgroundImage;
@property (nonatomic, strong) UIImage *selectedTabBackgroundImage;
@property (nonatomic, assign) CGFloat tabTitleSpacing;

- (void)reloadTabs;
- (UIView *)viewForTabAtIndex:(NSInteger)tabIndex;

@end
