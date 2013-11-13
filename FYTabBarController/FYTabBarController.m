//
//  FYTabBarController.m
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/13/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import "FYTabBarController.h"
#import "FYTabBar.h"

@interface FYTabBarController ()
- (void)updateTabBar;
- (void)updateLayout;
@end

CGFloat kDefaultTabBarHeight = 50.0;

@implementation FYTabBarController

@synthesize viewControllers=_viewControllers;
@synthesize selectedViewController=_selectedViewController;
@synthesize selectedIndex=_selectedIndex;
@synthesize tabBar=_tabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarHeight = kDefaultTabBarHeight;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.tabBarHeight = kDefaultTabBarHeight;
    }
    return self;
}

- (void)loadView {
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:screenFrame];
    self.view.backgroundColor = [UIColor clearColor];
    self.container = [[UIView alloc] initWithFrame:screenFrame];
    self.container.backgroundColor = [UIColor clearColor];
    self.container.opaque = NO;
    self.container.clipsToBounds = YES;
    [self.view addSubview:self.container];
    [self.view addSubview:self.tabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.container) {
        self.container = [[UIView alloc] init];
        self.container.backgroundColor = [UIColor clearColor];
        self.container.opaque = NO;
        self.container.clipsToBounds = YES;
        [self.view addSubview:self.container];
    }
    
    [self.view bringSubviewToFront:self.tabBar];
    [self updateLayout];
    
    [self showViewController:self.viewControllers[0] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

+ (Class)tabBarClass {
    return [FYTabBar class];
}

- (void)showViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // Don't support animation
    animated = NO;
    
    NSInteger tabIndex = [self.viewControllers indexOfObject:viewController];
    if (NSNotFound == tabIndex) {
        NSLog(@"Error; requested to show view controller not in self.viewControllers");
        return;
    }
    
    if (self.selectedViewController != viewController) {
        UIViewController *previousViewController = self.selectedViewController;
        
        [previousViewController willMoveToParentViewController:nil];
        [self addChildViewController:viewController];

        [viewController viewWillAppear:animated];
        [previousViewController viewWillDisappear:animated];
        [previousViewController.view removeFromSuperview];
        [self.container addSubview:viewController.view];
        [previousViewController viewDidDisappear:animated];
        [viewController viewDidAppear:animated];
        
        [self willChangeValueForKey:@"selectedIndex"];
        [self willChangeValueForKey:@"selectedViewController"];
        _selectedIndex = tabIndex;
        _selectedViewController = self.viewControllers[tabIndex];
        self.tabBar.selectedIndex = tabIndex;
        [self didChangeValueForKey:@"selectedIndex"];
        [self didChangeValueForKey:@"selectedViewController"];
        
        [viewController didMoveToParentViewController:self];
        [previousViewController removeFromParentViewController];
    }
    
}

- (NSString *)titleForTabAtIndex:(NSInteger)tabIndex {
    if (self.tabTitles.count > tabIndex) {
        return self.tabTitles[tabIndex];
    } else {
        return nil;
    }
}

- (NSString *)imageNameForTabAtIndex:(NSInteger)tabIndex {
    if (self.tabImageNames.count > tabIndex) {
        return self.tabImageNames[tabIndex];
    } else {
        return nil;
    }
}

- (NSString *)selectedImageNameForTabAtIndex:(NSInteger)tabIndex {
    if (self.selectedTabImageNames.count > tabIndex) {
        return self.selectedTabImageNames[tabIndex];
    } else {
        return nil;
    }
}

#pragma mark - Properties

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers != _viewControllers) {
        [self willChangeValueForKey:@"viewControllers"];
        _viewControllers = viewControllers;
        [self updateTabBar];
        [self didChangeValueForKey:@"viewControllers"];
    }
}

- (void)setTabTitles:(NSArray *)tabTitles {
    if (tabTitles != _tabTitles) {
        [self willChangeValueForKey:@"tabTitles"];
        _tabTitles = tabTitles;
        [self updateTabBar];
        [self didChangeValueForKey:@"tabTitles"];
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    [self showViewController:selectedViewController animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self showViewController:self.viewControllers[selectedIndex] animated:NO];
}

- (FYTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[[[self class] tabBarClass] alloc] init];
        [self.view addSubview:_tabBar];
        _tabBar.delegate = self;
        _tabBar.dataSource = self;
    }
    return _tabBar;
}

#pragma mark - Private methods

- (void)updateTabBar {
    [self.tabBar reloadTabs];
}

- (void)updateLayout {
    CGRect bounds = self.view.bounds;
    CGRect containerFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height - self.tabBarHeight);
    self.container.frame = containerFrame;
    CGRect tabFrame = CGRectMake(0, bounds.size.height - self.tabBarHeight, bounds.size.width, self.tabBarHeight);
    self.tabBar.frame = tabFrame;
}

#pragma mark - UITabBarDataSource

- (NSInteger)numberOfTabsInTabBar:(FYTabBar *)tabBar {
    return self.viewControllers.count;
}

- (NSString *)tabBar:(FYTabBar *)tabBar titleForTabAtIndex:(NSInteger)tabIndex {
    return [self titleForTabAtIndex:tabIndex];
}

- (NSString *)tabBar:(FYTabBar *)tabBar imageNameForTabAtIndex:(NSInteger)tabIndex {
    return [self imageNameForTabAtIndex:tabIndex];
}

- (NSString *)tabBar:(FYTabBar *)tabBar selectedImageNameForTabAtIndex:(NSInteger)tabIndex {
    return [self selectedImageNameForTabAtIndex:tabIndex];
}

#pragma mark - UITabBarDelegate

- (BOOL)tabBar:(FYTabBar *)tabBar shouldSelectTabAtIndex:(NSInteger)tabIndex {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        return [self.delegate tabBarController:self shouldSelectViewController:self.viewControllers[tabIndex]];
    } else {
        return YES;
    }
}

- (void)tabBar:(FYTabBar *)tabBar didSelectTabAtIndex:(NSInteger)tabIndex {
    self.selectedIndex = tabIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [self.delegate tabBarController:self didSelectViewController:self.viewControllers[tabIndex]];
    }
}

@end
