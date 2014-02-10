//
//  DataSource.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-1.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>
#import "ASIHTTPRequest.h"
@class ASINetworkQueue;
@class AppDelegate;
@class WeatherData;
@class WeatherDataIntime;
@class Reachability;
@protocol HandleWeatherDataDelegate <NSObject>

-(void)handleWeatherData:(NSMutableDictionary *)dataSet AndDataIntime:(NSMutableDictionary *)dataIntimeSet;

@end



@interface DataSource : NSObject<ASIHTTPRequestDelegate,CLLocationManagerDelegate>
{
    @private
    AppDelegate *appDlg;
    WeatherData *weatherData;
    ASINetworkQueue *networkQueue;
    NSMutableArray *networkRequestFaildFlags;
    NSMutableArray *networkRequestFaildIntimeFlags;
    CLLocationManager *_currentLoaction;
    CLGeocoder *_geocoder;
    Reachability *hostReach;
    @public
    NSMutableDictionary *weatherDataSet;
    NSMutableDictionary *weatherDataIntimeSet;
}
@property (nonatomic,retain) NSMutableArray *savedCityList;
@property (nonatomic,retain) NSArray *cityData;
@property (nonatomic,retain)NSObject <HandleWeatherDataDelegate> *delegate;
@property (nonatomic,copy)NSString *currentCity;

+(DataSource*)shareInstance;
//请求天气数据
-(void)requestWeatherDataWithCityName:(NSString *)cityName;

//添加城市
-(void)addCityWithName:(NSString *)name;
//移除城市
-(void)removeCityWithName:(NSString *)name AndPosition:(int)index;

//初始化城市json
-(void)initWithJsonData;
-(NSString *)getCodeOfCity:(NSString *)sender_cityName;

//获取城市天气数据方法
-(void)startGettingWeatherDataOfCity:(NSString *)name;

-(NSString *)getSystemTime:(BOOL)detail;

//获取天气图表名称
-(NSString *)getWeatherImgNameWithData:(NSString *)data;
//获取城市天气数据
-(WeatherData *)getCityDataWithName:(NSString *)cityName;
//获取城市天气时时数据
-(WeatherDataIntime *)getCityDataIntimeWithName:(NSString *)cityName;
//获取未来5天的日期号及星期
-(NSDictionary *)getNext5DateNumberArrayWithStartDate:(NSString *)date;

-(void)updateSavedCity;
//获取风向图
-(NSString *)getWindDirectionImgFromData:(NSString *)data;


-(NSString *)reFormDate:(NSString *)date;


//检测数据更新
-(void)checkDataUpdate;



@end
