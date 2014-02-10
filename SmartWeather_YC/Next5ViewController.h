//
//  Next5ViewController.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-9.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeatherData;
@interface Next5ViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    WeatherData *myWeatherData;
    NSDictionary *myDateDic;
    NSMutableArray *dateNumArray;
    NSMutableArray *weekdayArray;
}
@property (nonatomic,copy)NSString *theCity;

@end
