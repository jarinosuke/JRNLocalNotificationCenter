//
//  JRNLocalNotificationCenter.h
//  DemoApp
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const JRNLocalNotificationHandlingKeyName;
extern NSString *const JRNApplicationDidReceiveLocalNotification;

typedef void (^JRNLocalNotificationHandler)(NSString *key, NSDictionary *userInfo);

@interface JRNLocalNotificationCenter : NSObject
@property (assign, nonatomic) JRNLocalNotificationHandler localNotificationHandler;

+ (JRNLocalNotificationCenter *)defaultCenter;
- (NSArray *)localNotifications;


//Handling
- (void)didReceiveLocalNotificationUserInfo:(NSDictionary *)userInfo;


//Cancel
- (void)cancelAllLocalNotifications;
- (void)cancelLocalNotification:(UILocalNotification *)localNotification;
- (void)cancelLocalNotificationForKey:(NSString *)key;


//Post on now

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody;

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                           userInfo:(NSDictionary *)userInfo;

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSInteger)badgeCount;

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                        alertAction:(NSString *)alertAction
                          soundName:(NSString *)soundName
                        launchImage:(NSString *)launchImage
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSUInteger)badgeCount;


//Post on specified date

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody;

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
                  userInfo:(NSDictionary *)userInfo;

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSInteger)badgeCount;

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
               alertAction:(NSString *)alertAction
                 soundName:(NSString *)soundName
               launchImage:(NSString *)launchImage
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSUInteger)badgeCount;

@end
