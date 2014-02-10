//
//  SuggestViewController.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-18.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherData;
@interface SuggestViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    WeatherData *myWeatherData;
    UITableView *myTableView;
}
@property (nonatomic,copy)NSString *theCity;
@end
