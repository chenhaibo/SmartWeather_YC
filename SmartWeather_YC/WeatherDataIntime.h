//
//  WeatherDataIntime.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-4.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataIntime : NSObject

//对应接口数据 http://www.weather.com.cn/data/sk/101010100.html

@property (nonatomic,copy)NSString *temp;                       //当日实况温度
@property (nonatomic,copy)NSString *WD;                         //当日风向
@property (nonatomic,copy)NSString *WS;                         //当日风速级别
@property (nonatomic,copy)NSString *SD;                         //湿度
@property (nonatomic,copy)NSString *time;                       //发布时间

-(id)initWithJsonData2:(NSData *)jsonData2;

@end
