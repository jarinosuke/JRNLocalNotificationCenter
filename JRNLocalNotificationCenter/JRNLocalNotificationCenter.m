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
@property (nonatomic) NSMutableDictionary<NSString *, UILocalNotification *> *mutableScheduledLocalNotificationsByKey;
@property (nonatomic) BOOL checkRemoteNotificationAvailability;
@end

@implementation JRNLocalNotificationCenter

+ (instancetype)defaultCenter {
    static JRNLocalNotificationCenter *defaultCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCenter = [[JRNLocalNotificationCenter alloc] init];
    });
    return defaultCenter;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableScheduledLocalNotificationsByKey = [NSMutableDictionary new];
        _checkRemoteNotificationAvailability = NO;
        _localNotificationHandler = nil;
        [self loadScheduledLocalPushNotificationsFromApplication];
    }
    return self;
}

#pragma mark - Getters

- (NSDictionary<NSString *,UILocalNotification *> *)scheduledLocalNotificationsByKey {
    return [NSDictionary dictionaryWithDictionary:self.mutableScheduledLocalNotificationsByKey];
}

#pragma mark - Private

- (void)loadScheduledLocalPushNotificationsFromApplication {
    NSArray<UILocalNotification *> *scheduleLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in scheduleLocalNotifications) {
        if (localNotification.userInfo[JRNLocalNotificationHandlingKeyName]) {
            [self.mutableScheduledLocalNotificationsByKey setObject:localNotification forKey:localNotification.userInfo[JRNLocalNotificationHandlingKeyName]];
        }
    }
}

- (BOOL)isLocalNotificationScheduledForKey:(NSString *)key {
    return (self.mutableScheduledLocalNotificationsByKey[key] != nil);
}

- (NSDate *)fireDateForExistingScheduledNotificationForKey:(NSString *)key {
    UILocalNotification *notification = self.mutableScheduledLocalNotificationsByKey[key];
    if (notification) {
        return notification.fireDate;
    }
    return nil;
}

- (void)didReceiveLocalNotificationUserInfo:(NSDictionary *)userInfo
{
    NSString *key = userInfo[JRNLocalNotificationHandlingKeyName];
    if (!key) {
        return;
    }
    [self.mutableScheduledLocalNotificationsByKey removeObjectForKey:key];
    
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
    [self.mutableScheduledLocalNotificationsByKey removeAllObjects];
}

- (void)cancelLocalNotification:(UILocalNotification *)localNotification
{
    if (!localNotification) {
        return;
    }
    
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    if (localNotification.userInfo[JRNLocalNotificationHandlingKeyName]) {
        [self.mutableScheduledLocalNotificationsByKey removeObjectForKey:localNotification.userInfo[JRNLocalNotificationHandlingKeyName]];
    }
}

- (void)cancelLocalNotificationForKey:(NSString *)key
{
    if (!self.mutableScheduledLocalNotificationsByKey[key]) {
        return;
    }
    
    UILocalNotification *localNotification = self.mutableScheduledLocalNotificationsByKey[key];
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    [self.mutableScheduledLocalNotificationsByKey removeObjectForKey:key];
}

#pragma mark -
#pragma mark - Post on now

- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                                           alertBody:(NSString *)alertBody
{
    return [self postNotificationOnNow:YES
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

- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                           userInfo:(NSDictionary *)userInfo
{
    return [self postNotificationOnNow:YES
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

- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSInteger)badgeCount
{
    return [self postNotificationOnNow:YES
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

- (UILocalNotification *)postNotificationOnNowForKey:(NSString *)key
                          alertBody:(NSString *)alertBody
                        alertAction:(NSString *)alertAction
                          soundName:(NSString *)soundName
                        launchImage:(NSString *)launchImage
                           userInfo:(NSDictionary *)userInfo
                         badgeCount:(NSUInteger)badgeCount
                     repeatInterval:(NSCalendarUnit)repeatInterval
{
    return [self postNotificationOnNow:YES
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

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
{
    return [self postNotificationOnNow:NO
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

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
                  userInfo:(NSDictionary *)userInfo
{
    return [self postNotificationOnNow:NO
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

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSInteger)badgeCount
{
    return [self postNotificationOnNow:NO
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

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                    forKey:(NSString *)key
                 alertBody:(NSString *)alertBody
               alertAction:(NSString *)alertAction
                 soundName:(NSString *)soundName
               launchImage:(NSString *)launchImage
                  userInfo:(NSDictionary *)userInfo
                badgeCount:(NSUInteger)badgeCount
            repeatInterval:(NSCalendarUnit)repeatInterval
{
    return [self postNotificationOnNow:NO
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

- (UILocalNotification *)postNotificationOnNow:(BOOL)presentNow
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
    if (self.mutableScheduledLocalNotificationsByKey[key]) {
        //same key already exists
        return self.mutableScheduledLocalNotificationsByKey[key];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (!localNotification) {
        return nil;
    }
    
    //return nil, if user denied app's notification requirement
    
    NSUInteger notificationType; //UIUserNotificationType(>= iOS8) and UIRemoteNotificatioNType(< iOS8) use same value
    UIApplication *application = [UIApplication sharedApplication];
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        notificationType = [[application currentUserNotificationSettings] types];
    } else {
        notificationType = [application enabledRemoteNotificationTypes];
    }
    if (self.checkRemoteNotificationAvailability && notificationType == UIRemoteNotificationTypeNone) {
        return nil;
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
        [self.mutableScheduledLocalNotificationsByKey setObject:localNotification forKey:key];
        return localNotification;
    } else {
        return nil;
    }
}
@end
