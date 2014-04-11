//
//  JRNLocalNotificationCenter.m
//  DemoApp
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import "JRNLocalNotificationCenter.h"

NSString *const JRNLocalNotificationHandlingKeyName = @"JRN_KEY";
NSString *const JRNApplicationDidReceiveLocalNotification = @"JRNApplicationDidReceiveLocalNotification";

@interface JRNLocalNotificationCenter()
@property (nonatomic) NSMutableDictionary *localPushDictionary;
@property (nonatomic) BOOL checkRemoteNotificationAvailability;
@end

static JRNLocalNotificationCenter *defaultCenter;

@implementation JRNLocalNotificationCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCenter = [JRNLocalNotificationCenter new];
        defaultCenter.localPushDictionary = [NSMutableDictionary new];
        [defaultCenter loadScheduledLocalPushNotificationsFromApplication];
        defaultCenter.checkRemoteNotificationAvailability = NO;
        defaultCenter.localNotificationHandler = nil;
    });
    return defaultCenter;
}

- (void)loadScheduledLocalPushNotificationsFromApplication
{
    NSArray *scheduleLocalPushNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in scheduleLocalPushNotifications) {
        if (localNotification.userInfo[JRNLocalNotificationHandlingKeyName]) {
            [self.localPushDictionary setObject:localNotification forKey:localNotification.userInfo[JRNLocalNotificationHandlingKeyName]];
        }
    }
}

- (NSArray *)localNotifications
{
    return [[NSArray alloc] initWithArray:[self.localPushDictionary allValues]];
}


- (void)didReceiveLocalNotificationUserInfo:(NSDictionary *)userInfo
{
    if (!userInfo[JRNLocalNotificationHandlingKeyName]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JRNApplicationDidReceiveLocalNotification
                                                        object:nil
                                                      userInfo:userInfo];
    
    if (self.localNotificationHandler) {
        self.localNotificationHandler(userInfo[JRNLocalNotificationHandlingKeyName], userInfo);
    }
}


- (void)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.localPushDictionary removeAllObjects];
}

- (void)cancelLocalNotification:(UILocalNotification *)localNotification
{
    if (!localNotification) {
        return;
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    if (localNotification.userInfo[JRNLocalNotificationHandlingKeyName]) {
        [self.localPushDictionary removeObjectForKey:localNotification.userInfo[JRNLocalNotificationHandlingKeyName]];
    }
}

- (void)cancelLocalNotificationForKey:(NSString *)key
{
    if (!self.localPushDictionary[key]) {
        return;
    }
    
    UILocalNotification *localNotification = self.localPushDictionary[key];
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    [self.localPushDictionary removeObjectForKey:key];
}

#pragma mark -
#pragma mark - Post on now

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
{
    [self postNotificationOnNow:YES
                       fireDate:nil
                         forKey:key
                      alertBody:alertBody
                    alertAction:nil
                      soundName:nil
                    launchImage:nil
                       userInfo:nil
                     badgeCount:0
                 repeatInterval:0];
}

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                           userInfo:(NSDictionary *)userInfo
{
    [self postNotificationOnNow:YES
                       fireDate:nil
                         forKey:key
                      alertBody:alertBody
                    alertAction:nil
                      soundName:nil
                    launchImage:nil
                       userInfo:userInfo
                     badgeCount:0
                 repeatInterval:0];
}

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSInteger)badgeCount
{
    [self postNotificationOnNow:YES
                       fireDate:nil
                         forKey:key
                      alertBody:alertBody
                    alertAction:nil
                      soundName:nil
                    launchImage:nil
                       userInfo:userInfo
                     badgeCount:badgeCount
                 repeatInterval:0];
}

- (void)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                        alertAction:(NSString *)alertAction
                          soundName:(NSString *)soundName
                        launchImage:(NSString *)launchImage
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSUInteger)badgeCount
                     repeatInterval:(NSCalendarUnit)repeatInterval
{
    [self postNotificationOnNow:YES
                       fireDate:nil
                         forKey:key
                      alertBody:alertBody
                    alertAction:alertAction
                      soundName:soundName
                    launchImage:launchImage
                       userInfo:userInfo
                     badgeCount:badgeCount
                 repeatInterval:repeatInterval];
}


#pragma mark -
#pragma mark - Post on specified date

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
{
    [self postNotificationOnNow:NO
                       fireDate:fireDate
                         forKey:key
                      alertBody:alertBody
                    alertAction:nil
                      soundName:nil
                    launchImage:nil
                       userInfo:nil
                     badgeCount:0
                 repeatInterval:0];
}

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
                  userInfo:(NSDictionary *)userInfo
{
    [self postNotificationOnNow:NO
                       fireDate:fireDate
                         forKey:key
                      alertBody:alertBody
                    alertAction:nil
                      soundName:nil
                    launchImage:nil
                       userInfo:userInfo
                     badgeCount:0
                 repeatInterval:0];
}

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSInteger)badgeCount
{
    [self postNotificationOnNow:NO
                       fireDate:fireDate
                         forKey:key
                      alertBody:alertBody
                    alertAction:nil
                      soundName:nil
                    launchImage:nil
                       userInfo:userInfo
                     badgeCount:badgeCount
                 repeatInterval:0];
}

- (void)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
               alertAction:(NSString *)alertAction
                 soundName:(NSString *)soundName
               launchImage:(NSString *)launchImage
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSUInteger)badgeCount
            repeatInterval:(NSCalendarUnit)repeatInterval
{
    [self postNotificationOnNow:NO
                       fireDate:fireDate
                         forKey:key
                      alertBody:alertBody
                    alertAction:alertAction
                      soundName:soundName
                    launchImage:launchImage
                       userInfo:userInfo
                     badgeCount:badgeCount
                 repeatInterval:repeatInterval];
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
               repeatInterval:(NSCalendarUnit)repeatInterval;
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification) {
        return;
    }
    
    UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (self.checkRemoteNotificationAvailability && notificationType == UIRemoteNotificationTypeNone) {
        return;
    }
    
    
    BOOL needsNotify = NO;
    
    //Alert
    if (self.checkRemoteNotificationAvailability && (notificationType & UIRemoteNotificationTypeAlert) != UIRemoteNotificationTypeAlert) {
        needsNotify = NO;
    } else {
        needsNotify = YES;
    }
    //add key name for handling it.
    NSMutableDictionary *userInfoAddingHandlingKey = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [userInfoAddingHandlingKey setObject:key forKey:JRNLocalNotificationHandlingKeyName];
    localNotification.userInfo         = userInfoAddingHandlingKey;
    localNotification.alertBody        = alertBody;
    localNotification.alertAction      = alertAction;
    localNotification.alertLaunchImage = launchImage;
    localNotification.repeatInterval   = repeatInterval;
    
    //Sound
    if (self.checkRemoteNotificationAvailability && (notificationType & UIRemoteNotificationTypeSound) != UIRemoteNotificationTypeSound) {
        needsNotify = NO;
    } else {
        needsNotify = YES;
    }
    if (soundName) {
        localNotification.soundName = soundName;
    } else {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    
    //Badge
    if (self.checkRemoteNotificationAvailability && (notificationType & UIRemoteNotificationTypeBadge) != UIRemoteNotificationTypeBadge) {
    } else {
        localNotification.applicationIconBadgeNumber = badgeCount;
    }
    
    
    if (needsNotify) {
        if (presentNow && !fireDate) {
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
