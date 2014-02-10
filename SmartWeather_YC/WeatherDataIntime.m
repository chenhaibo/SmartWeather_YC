//
//  WeatherDataIntime.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-4.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "WeatherDataIntime.h"

@implementation WeatherDataIntime
@synthesize SD,temp,time,WD,WS;


-(id)initWithJsonData2:(NSData *)jsonData2{
    if (self) {
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSError *error;
        NSDictionary *weatherDir2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherInfo2 = [weatherDir2 objectForKey:@"weatherinfo"];
        
        self.temp=[weatherInfo2 objectForKey:@"temp"];
        self.WD=[weatherInfo2 objectForKey:@"WD"];
        self.WS=[weatherInfo2 objectForKey:@"WS"];
        self.time=[weatherInfo2 objectForKey:@"time"];
        self.SD=[weatherInfo2 objectForKey:@"SD"];
        
    }
    return self;
}


@end
