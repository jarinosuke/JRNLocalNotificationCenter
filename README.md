[![Build Status](https://travis-ci.org/jarinosuke/JRNLocalNotificationCenter.png?branch=master)](https://travis-ci.org/jarinosuke/JRNLocalNotificationCenter)

## Requirements

- iOS 5.0 or later.
- ARC

## Features

- make easier to post UILocalNotification and handle it.
- cancellation after application process has been dead by specifying key when posted.

## Files

- `JRNLocalNotificationCenter/`  
JRNLocalNotificationCenter files.

- `JRNLocalNotificationCenterTests/`  
unit test files.

- `DemoApp/`  
files for sample application which lists scheduled local notifications.

## Usage

- 1.Add files in `JRNLocalNotificationCenter/` to your Xcode project.
- 2.Import JRNLocalNotificationCenter.

```objectivec
#import "JRNLocalNotificationCenter.h"
```

- post scheduled local notification.

```objectivec
[[JRNLocalNotificationCenter defaultCenter] postNotificationOn:[NSDate dateWithTimeIntervalSinceNow:30.0]
                                                            forKey:@"test"
                                                         alertBody:@"This is JRNLocalNotificationCenter sample"
                                                       alertAction:@"Open"
                                                         soundName:nil
                                                       launchImage:nil
                                                          userInfo:@{@"time": @"12"}
                                                        badgeCount:[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1
                                                    repeatInterval:NSCalendarUnitDay];
```

- cancel scheduled local notification. 

```objectivec
[[JRNLocalNotificationCenter defaultCenter] cancelLocalNotificationForKey:@"test"];
```

- handle local notification.

```objectivec
###application:didFinishLaunchingWithOptions:
[[JRNLocalNotificationCenter defaultCenter] setLocalNotificationHandler:^(NSString *key, NSDictionary *userInfo) {
    if ( [key isEqualToString:@"test"] ) {
        //implement handling method for "test"
    }
}];

###application:didReceiveLocalNotification:
[[JRNLocalNotificationCenter defaultCenter] didReceiveLocalNotificationUserInfo:notification.userInfo];
```

## Install
Using [CocoaPods](http://cocoapods.org) is the best way.

```
pod 'JRNLocalNotificationCenter'
```

### I don't want to use CocoaPods.
OK, please D&D JRNLocalNotificationCenter folder into your project.

## License

Copyright (c) 2013 Naoki Ishikawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
