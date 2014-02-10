//
//  DataForSearchCity.m
//  SmartWeather_YC
//
//  Created by haibo chen on 14-1-7.
//  Copyright (c) 2014年 haibo chen. All rights reserved.
//

#import "DataForSearchCity.h"
#import "DataSource.h"
#import "ASINetworkQueue.h"
#import "WeatherData.h"
#import "WeatherDataIntime.h"
@implementation DataForSearchCity


-(id)init{
    cc=[DataSource shareInstance];
    return [super init];
}

-(void)startGettingWeatherDataOfCity:(NSString *)name{
    [self requestWeatherDataWithCityName:name];
}



-(void)requestWeatherDataWithCityName:(NSString *)cityName {
    
    
    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
	}
    [networkQueue reset];
	[networkQueue setRequestDidFinishSelector:@selector(weatherDataFetchComplete:)];
	[networkQueue setRequestDidFailSelector:@selector(weatherDataFetchFailed:)];
    [networkQueue setQueueDidFinishSelector:@selector(netDataComplete)];
	[networkQueue setDelegate:self];
    if (!networkRequestFaildFlags) {
        networkRequestFaildFlags=[[NSMutableArray alloc]init];
    }
    if (!networkRequestFaildIntimeFlags) {
        networkRequestFaildIntimeFlags=[[NSMutableArray alloc]init];
    }
    [networkRequestFaildIntimeFlags removeAllObjects];
    [networkRequestFaildFlags removeAllObjects];

    
    NSString *cityCode=[[DataSource shareInstance]getCodeOfCity:cityName];
    
    NSString *urlString=[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityCode];
    
    NSString *urlString2=[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html",cityCode];
    
    NSLog(@"%@",urlString);
    NSLog(@"%@",urlString2);
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURL *url2=[NSURL URLWithString:urlString2];
    
    ASIHTTPRequest *request;
    ASIHTTPRequest *request2;
    request = [ASIHTTPRequest requestWithURL:url];
    [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@_more",cityName] forKey:@"name"]];
    
    request2 = [ASIHTTPRequest requestWithURL:url2];
    [request2 setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@_less",cityName] forKey:@"name"]];
    
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:15];
    [request2 setRequestMethod:@"GET"];
    [request2 setTimeOutSeconds:15];
    
    [networkQueue addOperation:request];
    [networkQueue addOperation:request2];
    
    [networkQueue go];
}


- (void)weatherDataFetchComplete:(ASIHTTPRequest *)request
{
    
    NSLog(@"%@",[request.userInfo objectForKey:@"name"]);
    NSString *flag=[request.userInfo objectForKey:@"name"];
    NSArray *flags=[flag componentsSeparatedByString:@"_"];
    
    if (flags[1]&&[flags[1] isEqualToString:@"more"]) {
        myData=[[WeatherData alloc]init];
        myData=[myData initWithJsonData1:request.responseData];
        [cc->weatherDataSet setValue:myData forKey:flags[0]];
    }
    
    if (flags[1]&&[flags[1] isEqualToString:@"less"]) {
        myDataIntime=[[WeatherDataIntime alloc]init];
        myDataIntime=[myDataIntime initWithJsonData2:request.responseData];
        [cc->weatherDataIntimeSet setValue:myDataIntime forKey:flags[0]];
    }
    
}

- (void)weatherDataFetchFailed:(ASIHTTPRequest *)request
{
	
    NSString *flag=[request.userInfo objectForKey:@"name"];
    NSArray *flags=[flag componentsSeparatedByString:@"_"];
    if (flags[1]&&[flags[1] isEqualToString:@"more"]) {
        [networkRequestFaildFlags addObject:flags[0]];
    }
    
    if (flags[1]&&[flags[1] isEqualToString:@"less"]) {
        [networkRequestFaildIntimeFlags addObject:flags[0]];
    }
    
}

-(void)netDataComplete{
    NSLog(@"it's done");
    
    
    if (networkRequestFaildFlags.count>0|networkRequestFaildIntimeFlags.count>0) {
        NSString *title=@"";
        if (networkRequestFaildFlags.count>0) {
            NSString *citys=networkRequestFaildFlags[0];
            for (int i=1; i<networkRequestFaildFlags.count; i++) {
                citys=[citys stringByAppendingString:[NSString stringWithFormat:@",%@",networkRequestFaildFlags[i]]];
            }
            title=[[NSString alloc]initWithFormat:@"%@部分数据访问失败",citys];
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"数据异常" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alertView show];
        
        [self.delegate netAccessFailed];
    }else{
        [self.delegate reportWeatherData:myData AndDataIntime:myDataIntime];
    }
}




@end
