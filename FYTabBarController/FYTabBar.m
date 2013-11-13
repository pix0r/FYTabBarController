//
//  FYTabBar.m
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/13/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import "FYTabBar.h"
#import <MGImageUtilities/UIImage+Tint.h>

@interface FYTabBar () {
    NSInteger _numberOfTabs;
}
@property (nonatomic, strong) NSArray *tabViews;
- (IBAction)tabPressed:(id)sender;
@end

@implementation FYTabBar

@synthesize selectedIndex=_selectedIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.tabTitleColor = [UIColor whiteColor];
        self.selectedTabTitleColor = [UIColor blueColor];
        self.selectedTabTintColor = [UIColor blueColor];
        self.tabTitleSpacing = 5.0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    
    // Remove current tabs
    for (UIButton *tabView in self.tabViews) {
        [tabView removeTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tabView removeFromSuperview];
    }
    
    self.tabViews = nil;
    
    // Reload number of tabs
    _numberOfTabs = [self.dataSource numberOfTabsInTabBar:self];
    if (0 == _numberOfTabs) {
        NSLog(@"Error- no tabs to display");
        return;
    }
    
    CGFloat tabWidth = self.bounds.size.width / (CGFloat)_numberOfTabs;
    NSMutableArray *tabViews = [NSMutableArray arrayWithCapacity:_numberOfTabs];
    CGRect tabFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, tabWidth, self.bounds.size.height);
    for (int tabIdx = 0; tabIdx < _numberOfTabs; tabIdx++) {
        UIView *tabView = [self viewForTabAtIndex:tabIdx];
        tabView.frame = tabFrame;
        NSLog(@"set tab %d frame to %@", tabIdx, NSStringFromCGRect(tabFrame));
        tabFrame.origin.x += tabWidth;
        [tabViews addObject:tabView];
        [self addSubview:tabView];
    }
    self.tabViews = [NSArray arrayWithArray:tabViews];
}

#pragma mark - Public methods

- (void)reloadTabs {
    [self setNeedsLayout];
}

- (UIView *)viewForTabAtIndex:(NSInteger)tabIndex {
    UIButton *tabView = [UIButton buttonWithType:UIButtonTypeCustom];
    tabView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    tabView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tabView.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *title = [self.dataSource tabBar:self titleForTabAtIndex:tabIndex];

    if (title) {
        [tabView setTitle:title forState:UIControlStateNormal];
    }
    
    UIImage *tabImage = nil;
    UIColor *titleColor = self.tabTitleColor;
    UIImage *backgroundImage = nil;

    if (tabIndex == self.selectedIndex) {
        titleColor = self.selectedTabTitleColor;
        
        NSString *imageName = [self.dataSource tabBar:self imageNameForTabAtIndex:tabIndex];
        NSString *selectedImageName = [self.dataSource tabBar:self selectedImageNameForTabAtIndex:tabIndex];
        if (selectedImageName) {
            tabImage = [UIImage imageNamed:selectedImageName];
        } else if (imageName) {
            tabImage = [UIImage imageNamed:imageName];
            if (self.selectedTabTintColor) {
                tabImage = [tabImage imageTintedWithColor:self.selectedTabTintColor];
            }
        }
        if (self.selectedTabBackgroundImage) {
            backgroundImage = self.selectedTabBackgroundImage;
        } else if (self.tabBackgroundImage) {
            backgroundImage = self.tabBackgroundImage;
        }
    } else {
        NSString *imageName = [self.dataSource tabBar:self imageNameForTabAtIndex:tabIndex];
        if (imageName) {
            tabImage = [UIImage imageNamed:imageName];
        }
        if (self.tabBackgroundImage) {
            backgroundImage = self.tabBackgroundImage;
        }
    }
    
    [tabView setTitleColor:titleColor forState:UIControlStateNormal];
    if (tabImage) {
        [tabView setImage:tabImage forState:UIControlStateNormal];
        
        // TODO: Center text; see http://stackoverflow.com/a/7199529/72
        /*
        CGSize imageSize = tabImage.size;
        tabView.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height - self.tabTitleSpacing), 0.0);
        CGSize titleSize = tabView.titleLabel.frame.size;
        tabView.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + self.tabTitleSpacing), 0.0, 0.0, -titleSize.width);
         */
    }
    if (backgroundImage) {
        [tabView setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    [tabView addTarget:self action:@selector(tabPressed:) forControlEvents:UIControlEventTouchUpInside];
    return tabView;
}

#pragma mark - Properties

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex != _selectedIndex) {
        [self willChangeValueForKey:@"selectedIndex"];
        _selectedIndex = selectedIndex;
        [self didChangeValueForKey:@"selectedIndex"];
        [self setNeedsLayout];
    }
}

#pragma mark - Private methods

- (IBAction)tabPressed:(id)sender {
    NSInteger tabIdx = [self.tabViews indexOfObject:sender];
    BOOL shouldChange = NO;
    if (NSNotFound != tabIdx) {
        if ([self.delegate respondsToSelector:@selector(tabBar:shouldSelectTabAtIndex:)]) {
            if ([self.delegate tabBar:self shouldSelectTabAtIndex:tabIdx]) {
                shouldChange = YES;
            }
        } else {
            shouldChange = YES;
        }
    }
    if (shouldChange) {
        self.selectedIndex = tabIdx;
        if ([self.delegate respondsToSelector:@selector(tabBar:didSelectTabAtIndex:)]) {
            [self.delegate tabBar:self didSelectTabAtIndex:tabIdx];
        }
    }
}

@end
