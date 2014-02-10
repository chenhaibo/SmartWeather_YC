//
//  WeatherData.m
//  SmartWeather
//
//  Created by haibo chen on 13-11-9.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData
@synthesize city,cityid,city_en,week,date_y,fchh,fl1,fl2,fl3,fl4,fl5,fl6,fx1,fx2,img_title1,img_title10,img_title11,img_title12,img_title2,img_title3,img_title4,img_title5,img_title6,img_title7,img_title8,img_title9,img_title_single,index,index48,index48_d,index48_uv,index_ag,index_cl,index_co,index_d,index_ls,index_tr,index_uv,index_xc,SD,temp,temp1,temp2,temp3,temp4,temp5,temp6,time,WD,weather1,weather2,weather3,weather4,weather5,weather6,wind1,wind2,wind3,wind4,wind5,wind6,WS;
-(id)initWithJsonData1:(NSData *)jsonData1 AndJsonData2:(NSData *)jsonData2{
    if (self==nil) {
        self=[super init];
    }
    if (self) {
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSError *error;
        NSDictionary *weatherDir1 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherInfo1 = [weatherDir1 objectForKey:@"weatherinfo"];
        
        NSDictionary *weatherDir2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherInfo2 = [weatherDir2 objectForKey:@"weatherinfo"];
        
        self.date_y=[weatherInfo1 objectForKey:@"date_y"];
        self.week=[weatherInfo1 objectForKey:@"week"];
        self.city=[weatherInfo1 objectForKey:@"city"];
        self.fchh=[weatherInfo1 objectForKey:@"fchh"];
        self.city_en=[weatherInfo1 objectForKey:@"city_en"];
        self.cityid=[weatherInfo1 objectForKey:@"cityid"];
        self.temp1=[weatherInfo1 objectForKey:@"temp1"];
        self.temp2=[weatherInfo1 objectForKey:@"temp2"];
        self.temp3=[weatherInfo1 objectForKey:@"temp3"];
        self.temp4=[weatherInfo1 objectForKey:@"temp4"];
        self.temp5=[weatherInfo1 objectForKey:@"temp5"];
        self.temp6=[weatherInfo1 objectForKey:@"temp6"];
        self.weather1=[weatherInfo1 objectForKey:@"weather1"];
        self.weather2=[weatherInfo1 objectForKey:@"weather2"];
        self.weather3=[weatherInfo1 objectForKey:@"weather3"];
        self.weather4=[weatherInfo1 objectForKey:@"weather4"];
        self.weather5=[weatherInfo1 objectForKey:@"weather5"];
        self.weather6=[weatherInfo1 objectForKey:@"weather6"];
        self.img_title_single=[weatherInfo1 objectForKey:@"img_title_single"];
        self.img_title1=[weatherInfo1 objectForKey:@"img_title1"];
        self.img_title2=[weatherInfo1 objectForKey:@"img_title2"];
        self.img_title3=[weatherInfo1 objectForKey:@"img_title3"];
        self.img_title4=[weatherInfo1 objectForKey:@"img_title4"];
        self.img_title5=[weatherInfo1 objectForKey:@"img_title5"];
        self.img_title6=[weatherInfo1 objectForKey:@"img_title6"];
        self.img_title7=[weatherInfo1 objectForKey:@"img_title7"];
        self.img_title8=[weatherInfo1 objectForKey:@"img_title8"];
        self.img_title9=[weatherInfo1 objectForKey:@"img_title9"];
        self.img_title10=[weatherInfo1 objectForKey:@"img_title10"];
        self.img_title11=[weatherInfo1 objectForKey:@"img_title11"];
        self.img_title12=[weatherInfo1 objectForKey:@"img_title12"];
        self.wind1=[weatherInfo1 objectForKey:@"wind1"];
        self.wind2=[weatherInfo1 objectForKey:@"wind2"];
        self.wind3=[weatherInfo1 objectForKey:@"wind3"];
        self.wind4=[weatherInfo1 objectForKey:@"wind4"];
        self.wind5=[weatherInfo1 objectForKey:@"wind5"];
        self.wind6=[weatherInfo1 objectForKey:@"wind6"];
        self.fx1=[weatherInfo1 objectForKey:@"fx1"];
        self.fx2=[weatherInfo1 objectForKey:@"fx2"];
        self.fl1=[weatherInfo1 objectForKey:@"fl1"];
        self.fl2=[weatherInfo1 objectForKey:@"fl2"];
        self.fl3=[weatherInfo1 objectForKey:@"fl3"];
        self.fl4=[weatherInfo1 objectForKey:@"fl4"];
        self.fl5=[weatherInfo1 objectForKey:@"fl5"];
        self.fl6=[weatherInfo1 objectForKey:@"fl6"];
        self.index=[weatherInfo1 objectForKey:@"index"];
        self.index_d=[weatherInfo1 objectForKey:@"index_d"];
        self.index48=[weatherInfo1 objectForKey:@"index48"];
        self.index48_d=[weatherInfo1 objectForKey:@"index48_d"];
        self.index_uv=[weatherInfo1 objectForKey:@"index_uv"];
        self.index48_uv=[weatherInfo1 objectForKey:@"index48_uv"];
        self.index_xc=[weatherInfo1 objectForKey:@"index_xc"];
        self.index_tr=[weatherInfo1 objectForKey:@"index_tr"];
        self.index_co=[weatherInfo1 objectForKey:@"index_co"];
        self.index_cl=[weatherInfo1 objectForKey:@"index_cl"];
        self.index_ls=[weatherInfo1 objectForKey:@"index_ls"];
        self.index_ag=[weatherInfo1 objectForKey:@"index_ag"];
        
        
        self.temp=[weatherInfo2 objectForKey:@"temp"];
        self.WD=[weatherInfo2 objectForKey:@"WD"];
        self.WS=[weatherInfo2 objectForKey:@"WS"];
        self.time=[weatherInfo2 objectForKey:@"time"];
        
    }
    return self;
}

-(id)initWithJsonData1:(NSData *)jsonData1{
    
    if (self==nil) {
        self=[super init];
    }
    if (self) {
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSError *error;
        NSDictionary *weatherDir1 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherInfo1 = [weatherDir1 objectForKey:@"weatherinfo"];
        
        self.date_y=[weatherInfo1 objectForKey:@"date_y"];
        self.week=[weatherInfo1 objectForKey:@"week"];
        self.city=[weatherInfo1 objectForKey:@"city"];
        self.city_en=[weatherInfo1 objectForKey:@"city_en"];
        self.fchh=[weatherInfo1 objectForKey:@"fchh"];
        self.cityid=[weatherInfo1 objectForKey:@"cityid"];
        self.temp1=[weatherInfo1 objectForKey:@"temp1"];
        self.temp2=[weatherInfo1 objectForKey:@"temp2"];
        self.temp3=[weatherInfo1 objectForKey:@"temp3"];
        self.temp4=[weatherInfo1 objectForKey:@"temp4"];
        self.temp5=[weatherInfo1 objectForKey:@"temp5"];
        self.temp6=[weatherInfo1 objectForKey:@"temp6"];
        self.weather1=[weatherInfo1 objectForKey:@"weather1"];
        self.weather2=[weatherInfo1 objectForKey:@"weather2"];
        self.weather3=[weatherInfo1 objectForKey:@"weather3"];
        self.weather4=[weatherInfo1 objectForKey:@"weather4"];
        self.weather5=[weatherInfo1 objectForKey:@"weather5"];
        self.weather6=[weatherInfo1 objectForKey:@"weather6"];
        self.img_title_single=[weatherInfo1 objectForKey:@"img_title_single"];
        self.img_title1=[weatherInfo1 objectForKey:@"img_title1"];
        self.img_title2=[weatherInfo1 objectForKey:@"img_title2"];
        self.img_title3=[weatherInfo1 objectForKey:@"img_title3"];
        self.img_title4=[weatherInfo1 objectForKey:@"img_title4"];
        self.img_title5=[weatherInfo1 objectForKey:@"img_title5"];
        self.img_title6=[weatherInfo1 objectForKey:@"img_title6"];
        self.img_title7=[weatherInfo1 objectForKey:@"img_title7"];
        self.img_title8=[weatherInfo1 objectForKey:@"img_title8"];
        self.img_title9=[weatherInfo1 objectForKey:@"img_title9"];
        self.img_title10=[weatherInfo1 objectForKey:@"img_title10"];
        self.img_title11=[weatherInfo1 objectForKey:@"img_title11"];
        self.img_title12=[weatherInfo1 objectForKey:@"img_title12"];
        self.wind1=[weatherInfo1 objectForKey:@"wind1"];
        self.wind2=[weatherInfo1 objectForKey:@"wind2"];
        self.wind3=[weatherInfo1 objectForKey:@"wind3"];
        self.wind4=[weatherInfo1 objectForKey:@"wind4"];
        self.wind5=[weatherInfo1 objectForKey:@"wind5"];
        self.wind6=[weatherInfo1 objectForKey:@"wind6"];
        self.fx1=[weatherInfo1 objectForKey:@"fx1"];
        self.fx2=[weatherInfo1 objectForKey:@"fx2"];
        self.fl1=[weatherInfo1 objectForKey:@"fl1"];
        self.fl2=[weatherInfo1 objectForKey:@"fl2"];
        self.fl3=[weatherInfo1 objectForKey:@"fl3"];
        self.fl4=[weatherInfo1 objectForKey:@"fl4"];
        self.fl5=[weatherInfo1 objectForKey:@"fl5"];
        self.fl6=[weatherInfo1 objectForKey:@"fl6"];
        self.index=[weatherInfo1 objectForKey:@"index"];
        self.index_d=[weatherInfo1 objectForKey:@"index_d"];
        self.index48=[weatherInfo1 objectForKey:@"index48"];
        self.index48_d=[weatherInfo1 objectForKey:@"index48_d"];
        self.index_uv=[weatherInfo1 objectForKey:@"index_uv"];
        self.index48_uv=[weatherInfo1 objectForKey:@"index48_uv"];
        self.index_xc=[weatherInfo1 objectForKey:@"index_xc"];
        self.index_tr=[weatherInfo1 objectForKey:@"index_tr"];
        self.index_co=[weatherInfo1 objectForKey:@"index_co"];
        self.index_cl=[weatherInfo1 objectForKey:@"index_cl"];
        self.index_ls=[weatherInfo1 objectForKey:@"index_ls"];
        self.index_ag=[weatherInfo1 objectForKey:@"index_ag"];
        
        }
    return self;
}
-(id)initWithJsonData2:(NSData *)jsonData2{
    if (self==nil) {
        self=[super init];
    }
    if (self) {
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSError *error;
        NSDictionary *weatherDir2 = [NSJSONSerialization JSONObjectWithData:jsonData2 options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *weatherInfo2 = [weatherDir2 objectForKey:@"weatherinfo"];
        
        self.temp=[weatherInfo2 objectForKey:@"temp"];
        self.WD=[weatherInfo2 objectForKey:@"WD"];
        self.WS=[weatherInfo2 objectForKey:@"WS"];
        self.time=[weatherInfo2 objectForKey:@"time"];
        
    }
    return self;
}


@end
