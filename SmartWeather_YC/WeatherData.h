//
//  WeatherData.h
//  SmartWeather
//
//  Created by haibo chen on 13-11-9.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject


//对应接口数据 http://m.weather.com.cn/data/xxxx.html

@property (nonatomic,copy)NSString *date_y;                     //日期
@property (nonatomic,copy)NSString *week;                       //星期
@property (nonatomic,copy)NSString *city;                       //城市名
@property (nonatomic,copy)NSString *fchh;                       //发布时间
@property (nonatomic,copy)NSString *cityid;                     //城市id
@property (nonatomic,copy)NSString *city_en;                    //城市拼音
@property (nonatomic,copy)NSString *temp1;                      //当日气温范围
@property (nonatomic,copy)NSString *temp2;                      //第二天气温范围
@property (nonatomic,copy)NSString *temp3;                      //第三天气温范围
@property (nonatomic,copy)NSString *temp4;                      //第四天气温范围
@property (nonatomic,copy)NSString *temp5;                      //第五天气温范围
@property (nonatomic,copy)NSString *temp6;                      //第六天气温范围
@property (nonatomic,copy)NSString *weather1;                   //当日天气描述
@property (nonatomic,copy)NSString *weather2;                   //第二天天气描述
@property (nonatomic,copy)NSString *weather3;                   //第三天天气描述
@property (nonatomic,copy)NSString *weather4;                   //第四天天气描述
@property (nonatomic,copy)NSString *weather5;                   //第五天天气描述
@property (nonatomic,copy)NSString *weather6;                   //第六天天气描述

@property (nonatomic,copy)NSString *img_title_single;           //当日天气描述概述
@property (nonatomic,copy)NSString *img_title1;                 //当日天气描述1
@property (nonatomic,copy)NSString *img_title2;                 //当日天气描述2
@property (nonatomic,copy)NSString *img_title3;                 //第二天天气描述1
@property (nonatomic,copy)NSString *img_title4;                 //第二天天气描述2
@property (nonatomic,copy)NSString *img_title5;                 //第三天天气描述1
@property (nonatomic,copy)NSString *img_title6;                 //第三天天气描述2
@property (nonatomic,copy)NSString *img_title7;                 //第四天天气描述1
@property (nonatomic,copy)NSString *img_title8;                 //第四天天气描述2
@property (nonatomic,copy)NSString *img_title9;                 //第五天天气描述1
@property (nonatomic,copy)NSString *img_title10;                //第五天天气描述2
@property (nonatomic,copy)NSString *img_title11;                //第六天天气描述1
@property (nonatomic,copy)NSString *img_title12;                //第六天天气描述2

@property (nonatomic,copy)NSString *wind1;                      //当日风向风力描述
@property (nonatomic,copy)NSString *wind2;                      //第二天风向风力描述
@property (nonatomic,copy)NSString *wind3;                      //第三天风向风力描述
@property (nonatomic,copy)NSString *wind4;                      //第四天风向风力描述
@property (nonatomic,copy)NSString *wind5;                      //第五天风向风力描述
@property (nonatomic,copy)NSString *wind6;                      //第六天风向风力描述
@property (nonatomic,copy)NSString *fx1;                        //当日风向1
@property (nonatomic,copy)NSString *fx2;                        //当日风向2
@property (nonatomic,copy)NSString *fl1;                        //当日风力描述
@property (nonatomic,copy)NSString *fl2;                        //第二天风力描述
@property (nonatomic,copy)NSString *fl3;                        //第三天风力描述
@property (nonatomic,copy)NSString *fl4;                        //第四天风力描述
@property (nonatomic,copy)NSString *fl5;                        //第五天风力描述
@property (nonatomic,copy)NSString *fl6;                        //第六天风力描述
@property (nonatomic,copy)NSString *index;                      //冷热感觉
@property (nonatomic,copy)NSString *index_d;                    //穿衣建议
@property (nonatomic,copy)NSString *index48;                    //48小时内冷热感觉
@property (nonatomic,copy)NSString *index48_d;                  //48小时内穿衣建议
@property (nonatomic,copy)NSString *index_uv;                   //紫外线强度
@property (nonatomic,copy)NSString *index48_uv;                 //48小时内紫外线强度
@property (nonatomic,copy)NSString *index_xc;                   //洗车
@property (nonatomic,copy)NSString *index_tr;                   //旅游
@property (nonatomic,copy)NSString *index_co;                   //舒适
@property (nonatomic,copy)NSString *index_cl;                   //晨练
@property (nonatomic,copy)NSString *index_ls;                   //晾晒
@property (nonatomic,copy)NSString *index_ag;                   //过敏易发度


//对应接口数据 http://www.weather.com.cn/data/sk/101010100.html

@property (nonatomic,copy)NSString *temp;                       //当日实况温度
@property (nonatomic,copy)NSString *WD;                         //当日风向
@property (nonatomic,copy)NSString *WS;                         //当日风速级别
@property (nonatomic,copy)NSString *SD;                         //湿度
@property (nonatomic,copy)NSString *time;                       //发布时间

-(id)initWithJsonData1:(NSData *)jsonData1 AndJsonData2:(NSData *)jsonData2;
-(id)initWithJsonData1:(NSData *)jsonData1;
-(id)initWithJsonData2:(NSData *)jsonData2;
@end
