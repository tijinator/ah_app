//
//  AppDelegate.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NavigationViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "IIViewDeckController.h"
#import "FitmooHelper.h"

@interface FitmooAppDelegate : UIResponder <UIApplicationDelegate, IIViewDeckControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic)  LeftViewController *leftView;
@property (strong, nonatomic)  RightViewController *rightView;
@property (strong, nonatomic) NavigationViewController *navigateView;
@property (strong, nonatomic) IIViewDeckController *deckController;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

