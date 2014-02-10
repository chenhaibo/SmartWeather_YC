//
//  SuggestIndexViewController.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-11.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherData;
@interface SuggestIndexViewController : UITableViewController
{
    WeatherData *myWeatherData;
}
@property (nonatomic,copy)NSString *theCity;
@end
