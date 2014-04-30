//
//  JRNLocalNotificationCenterTest.m
//  JRNLocalNotificationCenterTest
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import "JRNLocalNotificationCenterTest.h"
#import "JRNLocalNotificationCenter.h"

@implementation JRNLocalNotificationCenterTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[JRNLocalNotificationCenter defaultCenter] setLocalNotificationHandler:nil];
    [[JRNLocalNotificationCenter defaultCenter] cancelAllLocalNotifications];
}

#pragma mark -
#pragma mark - Scheduling Post

- (void)testPostScheduledNotificationCountAfterPosting
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 1, @"LocalNotification count is different.");
}

- (void)testPostScheduledNotificationCountAfterCancelingCorrectKey
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] cancelLocalNotificationForKey:@"test"];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 0, @"couldn't cancel by correct key.");
}

- (void)testPostScheduledNotificationCountAfterCancelingWrongKey
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] cancelLocalNotificationForKey:@"uopoxo"];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 1, @"canceled by wrong key.");
}


- (void)testPostScheduledNotificationCountAfterCancelingAll
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] cancelAllLocalNotifications];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 0, @"couldn't cancel correctly.");
}

- (void)testScheduleMultipleLocalNotificationCount
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test1"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test2"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 2, @"manage unique with key");
}

- (void)testScheduleSameKeyLocalNotificationCount
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:15.0]
                                                            forKey:@"test"
                                                         alertBody:@"JRNLocalNotificationTest"
                                                       alertAction:@"Cancel"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"test-key": @"test-value"}
                                                        badgeCount:1
                                                    repeatInterval:0];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 1, @"don't schedule same key");
}

#pragma mark -
#pragma mark - Post Now

- (void)testPostNotificationCountAfterPosting
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOnNowForKey:@"test"
                                                                  alertBody:@"JRNLocalNotificationTest"
                                                                alertAction:@"Cancel"
                                                                  soundName:nil
                                                                launchImage:nil
                                                                   userInfo:@{@"test-key": @"test-value"}
                                                                 badgeCount:1
                                                             repeatInterval:0];
    
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 1, @"LocalNotification count is different.");
}

- (void)testPostNotificationCountAfterCancelingCorrectKey
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOnNowForKey:@"test"
                                                                  alertBody:@"JRNLocalNotificationTest"
                                                                alertAction:@"Cancel"
                                                                  soundName:nil
                                                                launchImage:nil
                                                                   userInfo:@{@"test-key": @"test-value"}
                                                                 badgeCount:1
                                                             repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] cancelLocalNotificationForKey:@"test"];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 0, @"couldn't cancel by correct key.");
}

- (void)testPostNotificationCountAfterCancelingWrongKey
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOnNowForKey:@"test"
                                                                  alertBody:@"JRNLocalNotificationTest"
                                                                alertAction:@"Cancel"
                                                                  soundName:nil
                                                                launchImage:nil
                                                                   userInfo:@{@"test-key": @"test-value"}
                                                                 badgeCount:1
                                                             repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] cancelLocalNotificationForKey:@"uopoxo"];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 1, @"canceled by wrong key.");
}


- (void)testPostNotificationCountAfterCancelingAll
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOnNowForKey:@"test"
                                                                  alertBody:@"JRNLocalNotificationTest"
                                                                alertAction:@"Cancel"
                                                                  soundName:nil
                                                                launchImage:nil
                                                                   userInfo:@{@"test-key": @"test-value"}
                                                                 badgeCount:1
                                                             repeatInterval:0];
    [[JRNLocalNotificationCenter defaultCenter] cancelAllLocalNotifications];
    XCTAssertTrue([[[JRNLocalNotificationCenter defaultCenter] localNotifications] count] == 0, @"couldn't cancel correctly.");
}


#pragma mark -
#pragma mark - Handling

- (void)testHandlingWhenPostWithCorrectKey
{
    [[JRNLocalNotificationCenter defaultCenter] setLocalNotificationHandler:^(NSString *key, NSDictionary *userInfo) {
        XCTAssertTrue([key isEqualToString:@"test"], @"posted key is different when handler fire.");
        XCTAssertTrue([userInfo[@"test-key"] isEqualToString:@"test-value"], @"posted userInfo is different when handler fire.");
    }];
    
    NSDictionary *userInfo = @{JRNLocalNotificationHandlingKeyName: @"test", @"test-key": @"test-value"};
    [[JRNLocalNotificationCenter defaultCenter] didReceiveLocalNotificationUserInfo:userInfo];
}

- (void)testHandlingWhenHandlerIsNil
{
    [[JRNLocalNotificationCenter defaultCenter] setLocalNotificationHandler:nil];
    
    NSDictionary *userInfo = @{JRNLocalNotificationHandlingKeyName: @"test", @"test-key": @"test-value"};
    XCTAssertNoThrow([[JRNLocalNotificationCenter defaultCenter] didReceiveLocalNotificationUserInfo:userInfo], @"can not receive local notification when handler is nil");
}


#pragma mark -
#pragma mark - Badge Count

//How can I test UIApplication? [UIApplication sharedApplication] return always nil.
/*
- (void)testApplicationBadgeCountAfterPosting
{
    [[JRNLocalNotificationCenter defaultCenter] postNotificationOnNowForKey:@"test"
                                                                  alertBody:@"JRNLocalNotificationTest"
                                                                alertAction:@"Cancel"
                                                                  soundName:nil
                                                                launchImage:nil
                                                                   userInfo:@{@"test-key": @"test-value"}
                                                                 badgeCount:1];
    STAssertTrue([UIApplication sharedApplication].applicationIconBadgeNumber == 1, @"badge count is different.");
}
*/

@end
