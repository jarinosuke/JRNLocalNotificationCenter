//
//  JRNLocalNotificationCenter.m
//  DemoApp
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import "JRNLocalNotificationCenter.h"

NSString *const JRNLocalNotificationHandlingKeyName = @"JRN_KEY";

@interface JRNLocalNotificationCenter()
@property NSMutableDictionary *localPushDictionary;
@property BOOL checkRemoteNotificationAvailability;
@end

static JRNLocalNotificationCenter *defaultCenter;

@implementation JRNLocalNotificationCenter

+ (JRNLocalNotificationCenter *)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCenter = [[JRNLocalNotificationCenter alloc] init];
        defaultCenter.localPushDictionary = [[NSMutableDictionary alloc] init];
        [defaultCenter loadScheduledLocalPushNotificationsFromApplication];
        defaultCenter.checkRemoteNotificationAvailability = NO;
    });
    return defaultCenter;
}

- (void)loadScheduledLocalPushNotificationsFromApplication
{
    NSArray *scheduleLocalPushNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in scheduleLocalPushNotifications) {
        if ( localNotification.userInfo[JRNLocalNotificationHandlingKeyName] ) {
            [self.localPushDictionary setObject:localNotification forKey:localNotification.userInfo[JRNLocalNotificationHandlingKeyName]];
        }
    }
}

- (void)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.localPushDictionary removeAllObjects];
}

- (void)cancelLocalNotificationForKey:(NSString *)key
{
    if ( !self.localPushDictionary[key] ) {
        return;
    }
    
    UILocalNotification *localNotification = self.localPushDictionary[key];
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    [self.localPushDictionary removeObjectForKey:key];
}

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                        alertAction:(NSString *)alertAction
                          soundName:(NSString *)soundName
                        launchImage:(NSString *)launchImage
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSUInteger)badgeCount
{
    [self postNotificationOnNow:YES
                       fireDate:nil
                         forKey:key
                      alertBody:alertBody
                    alertAction:alertAction
                      soundName:soundName
                    launchImage:launchImage
                       userInfo:userInfo
                     badgeCount:badgeCount];
}


- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
               alertAction:(NSString *)alertAction
                 soundName:(NSString *)soundName
               launchImage:(NSString *)launchImage
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSUInteger)badgeCount
{
    [self postNotificationOnNow:NO
                       fireDate:fireDate
                         forKey:key
                      alertBody:alertBody
                    alertAction:alertAction
                      soundName:soundName
                    launchImage:launchImage
                       userInfo:userInfo
                     badgeCount:badgeCount];
}

- (void)postNotificationOnNow:(BOOL)presentNow
                     fireDate:(NSDate *)fireDate
                       forKey:(NSString *)key
                    alertBody:(NSString *)alertBody
                  alertAction:(NSString *)alertAction
                    soundName:(NSString *)soundName
                  launchImage:(NSString *)launchImage
                     userInfo:(NSDictionary *)userInfo
                   badgeCount:(NSUInteger)badgeCount
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if ( !localNotification ) {
        return;
    }
    
    UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if ( self.checkRemoteNotificationAvailability && notificationType == UIRemoteNotificationTypeNone ) {
        return;
    }
    
    
    BOOL needsNotify = NO;
    
    //Alert
    if ( self.checkRemoteNotificationAvailability && (notificationType & UIRemoteNotificationTypeAlert) != UIRemoteNotificationTypeAlert ) {
        needsNotify = NO;
    } else {
        needsNotify = YES;
    }
    //add key name for handling it.
    NSMutableDictionary *userInfoAddingHandlingKey = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [userInfoAddingHandlingKey setObject:key forKey:JRNLocalNotificationHandlingKeyName];
    localNotification.userInfo         = userInfo;
    localNotification.alertBody        = alertBody;
    localNotification.alertAction      = alertAction;
    localNotification.alertLaunchImage = launchImage;
    
    
    //Sound
    if ( self.checkRemoteNotificationAvailability && (notificationType & UIRemoteNotificationTypeSound) != UIRemoteNotificationTypeSound ) {
        needsNotify = NO;
    } else {
        needsNotify = YES;
    }
    if ( soundName ) {
        localNotification.soundName = soundName;
    } else {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    
    //Badge
    if ( self.checkRemoteNotificationAvailability && (notificationType & UIRemoteNotificationTypeBadge) != UIRemoteNotificationTypeBadge ) {
    } else {
        localNotification.applicationIconBadgeNumber = badgeCount;
    }
    
    
    if ( needsNotify ) {
        if ( presentNow && !fireDate ) {
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        } else {
            localNotification.fireDate = fireDate;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        [self.localPushDictionary setObject:localNotification forKey:key];
    }
}
@end
