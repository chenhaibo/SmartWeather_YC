//
//  Forecast5ViewController.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-18.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherData;
@interface Forecast5ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    WeatherData *myWeatherData;
    NSDictionary *myDateDic;
    NSMutableArray *dateNumArray;
    NSMutableArray *weekdayArray;
    UITableView *myTableView;
}
@property (nonatomic,copy)NSString *theCity;

@end
