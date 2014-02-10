//
//  AppDelegate.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-11-25.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    @private
     Reachability *hostReach;
   
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)BOOL isNetworkReachable;
@end
