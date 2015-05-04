//
//  AppDelegate.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FitmooAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FitmooAppDelegate ()

@end

@implementation FitmooAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FBLoginView class];
    
    NSManagedObjectContext * context = [self managedObjectContext];
    [[FitmooHelper sharedInstance] setContext:context];
    [[FitmooHelper sharedInstance] setScreenSizeView:self.window];
    [[UserManager sharedUserManager] setContext:context];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _leftView = [mainStoryboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    _rightView = [mainStoryboard instantiateViewControllerWithIdentifier:@"RightViewController"];
    _navigateView = [mainStoryboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    _popupView = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    
//    _deckController =  [[IIViewDeckController alloc] initWithCenterViewController:_navigateView                                                           leftViewController:_leftView                                                                rightViewController:_rightView];
//    _deckController.delegate = self;
//    [_deckController setLeftSize:60.0f];
//    [_deckController setRightSize:110.0f];
//    
//    [_deckController setEnabled:NO];
//    
//    [_deckController shouldAutorotate];
//    [_deckController preferredInterfaceOrientationForPresentation];
//    [_deckController supportedInterfaceOrientations];
//    self.window.rootViewController = _deckController;

    _sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:_navigateView
                                                                    leftMenuViewController:_leftView
                                                                   rightMenuViewController:_rightView];

    _sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars.png"];
    _sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    _sideMenuViewController.delegate = self;
    _sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    _sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    _sideMenuViewController.contentViewShadowOpacity = 0.6;
    _sideMenuViewController.contentViewShadowRadius = 12;
    _sideMenuViewController.contentViewShadowEnabled = YES;
    _sideMenuViewController.contentViewInPortraitOffsetCenterX=-20;
    self.window.rootViewController = _sideMenuViewController;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self createObservers];

    // Override point for customization after application launch.
    return YES;
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnableSlideView:) name:@"EnableSlideView" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSideMenu:) name:@"openSideMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPopup:) name:@"openPopup" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSideMenu:) name:@"hideSideMenu" object:nil];
}

-(void)openSideMenu:(NSNotification*)note{
   [_deckController toggleLeftViewAnimated:YES];
    
}

-(void)hideSideMenu:(NSNotification*)note{
    [_sideMenuViewController hideMenuViewController];
    
}

- (void) EnableSlideView: (NSNotification * ) note
{
    NSString * flag= [note object];
    if ([flag isEqualToString:@"YES"]) {
           [_deckController setEnabled:YES];
    }else
    {
           [_deckController setEnabled:NO];
    }
}

-(void)openPopup:(NSNotification*)note{
    
    _popupView= [note object];
    [_deckController.view addSubview:_popupView.view];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication];
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return (UIInterfaceOrientationMaskPortrait);
//}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.fitmoo.project.fitmoo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"fitmoo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"fitmoo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - IIViewDeckControllerDelegate
- (void)viewDeckController:(IIViewDeckController *)viewDeckController applyShadow:(CALayer *)shadowLayer withBounds:(CGRect)rect {
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowRadius = 0;
    shadowLayer.shadowOpacity = 0;
    shadowLayer.shadowColor = nil;
    shadowLayer.shadowOffset = CGSizeZero;
    shadowLayer.shadowPath = nil;
}

@end
