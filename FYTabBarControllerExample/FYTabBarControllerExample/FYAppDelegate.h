//
//  FYAppDelegate.h
//  FYTabBarControllerExample
//
//  Created by Mike Matz on 11/13/13.
//  Copyright (c) 2013 Flying Yeti, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
