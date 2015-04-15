//
//  UserManagerTests.m
//  fitmoo
//
//  Created by hongjian lin on 4/15/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UserManager.h"
#import "ViewController.h"
#import "User.h"

@interface UserManagerTests : XCTestCase
@property (nonatomic) ViewController *vcToTest;
@end

@implementation UserManagerTests

- (void)setUp {
    [super setUp];
    self.vcToTest= [[ViewController alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLogin {
    
    User * u= [[User alloc] init];
    
    u.email=@"hongjianlin1989@gmail.com";
    u.password=@"lin22549010";
    
    [[UserManager sharedUserManager] performLogin:u];
    u= [[UserManager sharedUserManager] performLogin:u];
 
    if (u.user_id==nil) {
        XCTAssert(YES, @"Pass");
    }else
    {
         XCTAssert(NO, @"fail");
    }
    
 
}

- (void)testSignUp {
    
}

@end
