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
@property (nonatomic, copy) JRNLocalNotificationHandler localNotificationHandler;

+ (instancetype)defaultCenter;
- (NSArray *)localNotifications;


//Handling
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification;


//Cancel
- (void)cancelAllLocalNotifications;
- (void)cancelLocalNotification:(UILocalNotification *)localNotification;
- (void)cancelLocalNotificationForKey:(NSString *)key;


//Post on now

- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                                           alertBody:(NSString *)alertBody;

- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                                           alertBody:(NSString *)alertBody
                                            userInfo:(NSDictionary *)userInfo;


- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                                           alertBody:(NSString *)alertBody
                                         alertAction:(NSString *)alertAction
                                           soundName:(NSString *)soundName
                                         launchImage:(NSString *)launchImage
                                            userInfo:(NSDictionary *)userInfo
                                          badgeCount:(NSUInteger)badgeCount
                                      repeatInterval:(NSCalendarUnit)repeatInterval;


//Post on specified date

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                     forKey:(NSString *)key
                                  alertBody:(NSString *)alertBody;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                     forKey:(NSString *)key
                                  alertBody:(NSString *)alertBody
                                   userInfo:(NSDictionary *)userInfo;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                     forKey:(NSString *)key
                                  alertBody:(NSString *)alertBody
                                   userInfo:(NSDictionary *)userInfo
                                 badgeCount:(NSInteger)badgeCount;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                     forKey:(NSString *)key
                                  alertBody:(NSString *)alertBody
                                alertAction:(NSString *)alertAction
                                  soundName:(NSString *)soundName
                                launchImage:(NSString *)launchImage
                                   userInfo:(NSDictionary *)userInfo
                                 badgeCount:(NSUInteger)badgeCount
                             repeatInterval:(NSCalendarUnit)repeatInterval;

@end
