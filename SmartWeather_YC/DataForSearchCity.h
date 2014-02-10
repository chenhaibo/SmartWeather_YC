//
//  DataForSearchCity.h
//  SmartWeather_YC
//
//  Created by haibo chen on 14-1-7.
//  Copyright (c) 2014年 haibo chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@class ASINetworkQueue;
@class WeatherData;
@class WeatherDataIntime;
@class DataSource;
@protocol requestCityDataDelegate <NSObject>

-(void)reportWeatherData:(WeatherData *)data AndDataIntime:(WeatherDataIntime *)dataIntime;
-(void)netAccessFailed;
@end


@interface DataForSearchCity : NSObject
{
    @private
    ASINetworkQueue *networkQueue;
    NSMutableArray *networkRequestFaildFlags;
    NSMutableArray *networkRequestFaildIntimeFlags;
    WeatherData *myData;
    WeatherDataIntime *myDataIntime;
    DataSource *cc;
}
//获取城市天气数据方法
-(void)startGettingWeatherDataOfCity:(NSString *)name;
@property (nonatomic,retain)NSObject <requestCityDataDelegate> *delegate;
@end
