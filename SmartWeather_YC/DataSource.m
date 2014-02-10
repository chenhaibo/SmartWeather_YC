//
//  DataSource.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-1.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "DataSource.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "WeatherData.h"
#import "ASINetworkQueue.h"
#import "WeatherDataIntime.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"
@implementation DataSource
static DataSource* shared = nil;

+(DataSource *) shareInstance{
    @synchronized(self){
        if (shared == nil) {
            shared = [[self alloc] init];
        }
    }
    return  shared;
}


-(id)init{
    [self initWithJsonData];

    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    
   _savedCityList=[[NSUserDefaults standardUserDefaults]objectForKey:@"savedCities"];
    if (_savedCityList.count==0|_savedCityList==nil) {
        if (_savedCityList==nil) {
            _savedCityList=[[NSMutableArray alloc]init];
        }
       // [self getLocationCity];
        
    }else{
        // [self requestSavedCityData:_savedCityList];
    }
    
    networkRequestFaildFlags=[[NSMutableArray alloc]init];
    networkRequestFaildIntimeFlags=[[NSMutableArray alloc]init];
    
    
    weatherDataSet=[[NSMutableDictionary alloc]init];
    weatherDataIntimeSet=[[NSMutableDictionary alloc]init];
    
    //注册动态监听网络状态的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach=[Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [hostReach startNotifier];

    
    return [super init];
}

-(void)getLocationCity{
    _currentLoaction = [[CLLocationManager alloc] init];
    _currentLoaction.delegate=self;
    _geocoder=[[CLGeocoder alloc] init];
    [_currentLoaction startUpdatingLocation];
}

-(void)requestSavedCityData:(NSMutableArray *)savedCityList{
    
	if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue reset];
        [networkQueue setRequestDidFinishSelector:@selector(weatherDataFetchComplete:)];
        [networkQueue setRequestDidFailSelector:@selector(weatherDataFetchFailed:)];
        [networkQueue setQueueDidFinishSelector:@selector(netDataComplete)];
        [networkQueue setDelegate:self];

	}
    
    [networkRequestFaildIntimeFlags removeAllObjects];
    [networkRequestFaildFlags removeAllObjects];
    
    for (int i=0; i<savedCityList.count; i++) {
        NSString *cityName=savedCityList[i];
        NSString *cityCode=[self getCodeOfCity:cityName];
        NSString *urlString=[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityCode];
        NSString *urlString2=[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html",cityCode];
        NSURL *url=[NSURL URLWithString:urlString];
        NSURL *url2=[NSURL URLWithString:urlString2];
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:url];
        [request setCachePolicy:ASIUseDefaultCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@_more",cityName] forKey:@"name"]];
        [networkQueue addOperation:request];
        
        request = [ASIHTTPRequest requestWithURL:url2];
        [request setCachePolicy:ASIUseDefaultCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@_less",cityName] forKey:@"name"]];
        [networkQueue addOperation:request];
    }
    [networkQueue go];
    
}

- (void)weatherDataFetchComplete:(ASIHTTPRequest *)request
{
    
    
    NSLog(@"%@",[request.userInfo objectForKey:@"name"]);
    NSString *flag=[request.userInfo objectForKey:@"name"];
    NSArray *flags=[flag componentsSeparatedByString:@"_"];
    if (flags[1]&&[flags[1] isEqualToString:@"more"]) {
        WeatherData *data=[[WeatherData alloc]init];
        data=[data initWithJsonData1:request.responseData];
        [weatherDataSet setValue:data forKey:flags[0]];
    }
    
    if (flags[1]&&[flags[1] isEqualToString:@"less"]) {
        WeatherDataIntime *data=[[WeatherDataIntime alloc]init];
        data=[data initWithJsonData2:request.responseData];
        [weatherDataIntimeSet setValue:data forKey:flags[0]];
    }

}

- (void)weatherDataFetchFailed:(ASIHTTPRequest *)request
{
    NSString *flag=[request.userInfo objectForKey:@"name"];
    NSArray *flags=[flag componentsSeparatedByString:@"_"];
    if (flags[1]&&[flags[1] isEqualToString:@"more"]) {
        [networkRequestFaildFlags addObject:flags[0]];
       
        if ([request.downloadCache cachedResponseDataForURL:request.url]) {
             WeatherData *data=[[WeatherData alloc]init];
            data=[data initWithJsonData1:[request.downloadCache cachedResponseDataForURL:request.url]];
            [weatherDataSet setValue:data forKey:flags[0]];
        }
        
    }
    
    if (flags[1]&&[flags[1] isEqualToString:@"less"]) {
        [networkRequestFaildIntimeFlags addObject:flags[0]];
        if ([request.downloadCache cachedResponseDataForURL:request.url]) {
            WeatherDataIntime *data=[[WeatherDataIntime alloc]init];
            data=[data initWithJsonData2:[request.downloadCache cachedResponseDataForURL:request.url]];
            [weatherDataIntimeSet setValue:data forKey:flags[0]];
        }
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
        
    }
    
    [self.delegate handleWeatherData:weatherDataSet AndDataIntime:weatherDataIntimeSet];

}



-(void)requestWeatherDataWithCityName:(NSString *)cityName {

    if (!networkQueue) {
		networkQueue = [[ASINetworkQueue alloc] init];
        [networkQueue reset];
        [networkQueue setRequestDidFinishSelector:@selector(weatherDataFetchComplete:)];
        [networkQueue setRequestDidFailSelector:@selector(weatherDataFetchFailed:)];
        [networkQueue setQueueDidFinishSelector:@selector(netDataComplete)];
        [networkQueue setDelegate:self];
	}
    

        [networkRequestFaildIntimeFlags removeAllObjects];
        [networkRequestFaildFlags removeAllObjects];
        NSString *cityCode=[self getCodeOfCity:cityName];
        NSString *urlString=[NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityCode];
        
        NSString *urlString2=[NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/%@.html",cityCode];
    
        NSLog(@"%@",urlString);
        NSLog(@"%@",urlString2);
        
        NSURL *url=[NSURL URLWithString:urlString];
        NSURL *url2=[NSURL URLWithString:urlString2];
    
        ASIHTTPRequest *request;
        ASIHTTPRequest *request2;
        request = [ASIHTTPRequest requestWithURL:url];
        [request setCachePolicy:ASIUseDefaultCachePolicy];
        [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@_more",cityName] forKey:@"name"]];
        
        request2 = [ASIHTTPRequest requestWithURL:url2];
        [request2 setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@_less",cityName] forKey:@"name"]];
        [request2 setCachePolicy:ASIUseDefaultCachePolicy];
        [request2 setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setRequestMethod:@"GET"];
        [request setTimeOutSeconds:15];
        [request2 setRequestMethod:@"GET"];
        [request2 setTimeOutSeconds:15];
        
        [networkQueue addOperation:request];
        [networkQueue addOperation:request2];
        [networkQueue go];
    
}

-(void)updateSavedCity{
    
    [self requestSavedCityData:_savedCityList];
    
}

-(void)addCityWithName:(NSString *)name{
    [self.savedCityList addObject:name];
    [self startGettingWeatherDataOfCity:name];
}

-(void)removeCityWithName:(NSString *)name AndPosition:(int)index{
    [self.savedCityList removeObjectAtIndex:index];
    [self removeCityInWeatherDataSetWithCityName:name];
    [self removeCityInWeatherDataIntimeSetWithCityName:name];
   // [networkQueue ];
    [self.delegate handleWeatherData:weatherDataSet AndDataIntime:weatherDataIntimeSet];
}


-(void)removeCityInWeatherDataSetWithCityName:(NSString *)name{
    NSEnumerator *enumerator = [weatherDataSet keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject]))
    {
        NSArray *parts=[key componentsSeparatedByString:@"_"];
        if ([parts[0]isEqualToString:name]) {
            [weatherDataSet removeObjectForKey:key];
            break;
        }
    }
}

-(void)removeCityInWeatherDataIntimeSetWithCityName:(NSString *)name{
    NSEnumerator *enumerator = [weatherDataIntimeSet keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject]))
    {
        NSArray *parts=[key componentsSeparatedByString:@"_"];
        if ([parts[0]isEqualToString:name]) {
            [weatherDataIntimeSet removeObjectForKey:key];
            break;
        }
    }
}

-(void)initWithJsonData{
    
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *JsonFilePath =[NSString stringWithFormat:@"%@/cityCode.geojson",resourcePath];
        NSLog(@"%@",JsonFilePath);
        NSError *error;
        NSData *jsonData=[NSData dataWithContentsOfFile:JsonFilePath];
        
        
        NSDictionary *top=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
        
        self.cityData=[top objectForKey:@"城市代码"];
}


-(NSString *)getCodeOfCity:(NSString *)sender_cityName{
    
    for (int i=0; i<_cityData.count; i++) {
        
        NSDictionary *provinceDic=_cityData[i];
        NSArray *cities=[provinceDic objectForKey:@"市"];
        
        for (int j=0; j<cities.count; j++) {
            NSDictionary *cityDic=cities[j];
            NSString *cityName=[cityDic objectForKey:@"市名"];
            if ([sender_cityName isEqualToString:cityName]) {
                return [cityDic objectForKey:@"编码"];
            }
        }
    }
    
    return @"null_code";
}


-(void)startGettingWeatherDataOfCity:(NSString *)name{
    [self requestWeatherDataWithCityName:name];
}

//#pragma mark asihttp delegate
//- (void)requestFinished:(ASIHTTPRequest *)request{
//    
//    NSString *flag=[request.userInfo objectForKey:@"name"];
//    NSArray *flags=[flag componentsSeparatedByString:@"_"];
//    if (flags[1]&&[flags[1] isEqualToString:@"more"]) {
//        WeatherData *data=[[WeatherData alloc]init];
//        data=[data initWithJsonData1:request.responseData];
//        NSString *timeString=[self getSystemTime:NO];
//        [weatherDataSet setValue:data forKey:[NSString stringWithFormat:@"%@_%@",flags[0],timeString]];
//    }
//    
//    if (flags[1]&&[flags[1] isEqualToString:@"less"]) {
//        WeatherDataIntime *data=[[WeatherDataIntime alloc]init];
//        data=[data initWithJsonData2:request.responseData];
//        NSString *timeString=[self getSystemTime:YES];
//        [weatherDataIntimeSet setValue:data forKey:[NSString stringWithFormat:@"%@_%@",flags[0],timeString]];
//    }
//
//    [self.delegate handleWeatherData:weatherDataSet AndDataIntime:weatherDataIntimeSet];
//}
//-(void)requestFailed:(ASIHTTPRequest *)request{
//    NSLog(@"failed");
//}




-(NSString *)getSystemTime:(BOOL)detail{
    
     NSDate *  senddate=[NSDate date];
     NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
     NSString * timeString;
    if (detail) {
        [dateformatter setDateFormat:@"YYYY-MM-dd_HH:mm:ss"];
        timeString=[dateformatter stringFromDate:senddate];
        NSLog(@"%@",timeString);

    }else{
        [dateformatter setDateFormat:@"YYYY-MM-dd"];
        timeString=[dateformatter stringFromDate:senddate];
        NSLog(@"%@",timeString);
    }
    return timeString;
}


-(NSString *)getWeatherImgNameWithData:(NSString *)data{
    
    if ([data isEqualToString:@"霾"]) {
        return @"haze";
    }else if([data isEqualToString:@"晴"]){
        return @"sunDay";
    }else if([data isEqualToString:@"多云"]){
        return @"clouds";
    }else if([data isEqualToString:@"小雨"]){
        return @"littleRain";
    }else if([data isEqualToString:@"中雨"]){
        return @"middleRain";
    }else if([data isEqualToString:@"大雨"]){
        return @"bigRain";
    }else if([data isEqualToString:@"阵雨"]){
        return @"whileRain";
    }else if([data isEqualToString:@"阴"]){
        return @"overcast";
    }else if([data isEqualToString:@"小雪"]){
        return @"littleSnow";
    }else if([data isEqualToString:@"中雪"]){
        return @"middleSnow";
    }else if([data isEqualToString:@"大雪"]){
        return @"bigSnow";
    }else if([data isEqualToString:@"暴雪"]){
        return @"superSnow";
    }else if([data isEqualToString:@"暴雨"]){
        return @"superRain";
    }else if([data isEqualToString:@"阵雪"]){
        return @"middleSnow";
    }else if([data isEqualToString:@"雾"]){
        return @"flog";
    }else if([data isEqualToString:@"雨夹雪"]){
        return @"rainAndSnow";
    }else if([data isEqualToString:@"雷阵雨"]){
        return @"thunderRain";
    }else if([data isEqualToString:@"台风"]){
        return @"taifeng";
    }else if([data isEqualToString:@"霜冻"]){
        return @"forst";
    }else if([data isEqualToString:@"冰雹"]){
        return @"hail";
    }else if([data isEqualToString:@"冻雨"]){
        return @"forstRain";
    }
    
    return nil;
}




-(WeatherData *)getCityDataWithName:(NSString *)cityName{
   // NSString *timeNow=[self getSystemTime:NO];
    NSEnumerator *enumerator = [weatherDataSet keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject]))
    {
        NSLog(@">>>>>>>>>@@@>>>%@", key);
        NSArray *parts=[key componentsSeparatedByString:@"_"];
        if ([parts[0]isEqualToString:cityName]) {
            return [weatherDataSet objectForKey:key];
        }
        
    }
    
    return nil;
    
}

-(WeatherDataIntime *)getCityDataIntimeWithName:(NSString *)cityName{
   // NSString *timeNow=[self getSystemTime:NO];
    NSEnumerator *enumerator = [weatherDataIntimeSet keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject]))
    {
        NSLog(@">>>>>>>>>@@@>>>%@", key);
        NSArray *parts=[key componentsSeparatedByString:@"_"];
        if ([parts[0]isEqualToString:cityName]) {
            return [weatherDataIntimeSet objectForKey:key];
        }
        
    }
    
    return nil;
    
}



-(NSDictionary *)getNext5DateNumberArrayWithStartDate:(NSString *)date{
    NSMutableArray *dateNumArray=[[NSMutableArray alloc]init];
    NSMutableArray *weekdayArray=[[NSMutableArray alloc]init];
    NSDictionary *dateDic=[[NSDictionary alloc]initWithObjectsAndKeys:dateNumArray,@"dateNumArray", weekdayArray,@"weekdayArray",nil];
   
    NSString *year;
    NSString *month;
    NSString *day;
   // NSString *urlString = @"2013年12月8日";
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+" options:0 error:&error];
    
    if (regex != nil) {
        NSArray *matches=[regex matchesInString:date options:0 range:NSMakeRange(0, [date length])];
        if (matches[0]) {
            NSTextCheckingResult *match=matches[0];
            NSRange matchRange = [match range];
            year=[date substringWithRange:matchRange];
        }
        if (matches[1]) {
            NSTextCheckingResult *match=matches[1];
            NSRange matchRange = [match range];
            month=[date substringWithRange:matchRange];
        }
        if (matches[2]) {
            NSTextCheckingResult *match=matches[2];
            NSRange matchRange = [match range];
            day=[date substringWithRange:matchRange];
        }
    }
    NSString *date_en=[NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate  * oldDate=[dateformatter dateFromString:date_en];
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSWeekCalendarUnit;
    
    for (int i=0; i<5; i++) {
        NSTimeInterval someTime = 24 * 60 * 60 * (i+1);
        NSDate *newDate=[[NSDate alloc]initWithTimeInterval:someTime sinceDate:oldDate];
        
        NSDateComponents * conponent= [cal components:unitFlags fromDate:newDate];
        NSInteger day=[conponent day];
        NSInteger weekday = [conponent weekday];
        [dateNumArray addObject:[NSString stringWithFormat: @"%ld", (long)day]];
        [weekdayArray addObject:[self getWeekDayString:weekday]];
    }
    
    return dateDic;
//    NSTimeInterval secondsPerDay = 24 * 60 * 60 *2;
//    
//    NSDate *tomorrow = [[NSDate alloc] initWithTimeInterval:secondsPerDay sinceDate:oldDate];
//    
//    
//    
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit|NSWeekCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:tomorrow];
//    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
//    NSInteger day=[conponent day];
//    NSInteger weekday = [conponent weekday];
//    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
//    
//    NSLog(@"%@-%d",nsDateString,weekday);
    
}


-(NSString *)getWeekDayString:(NSInteger )number{
    if (number==1) {
        //return @"星期日";
        return @"Sun";
    }
    if (number==2) {
        //return @"星期一";
        return @"Mon";
    }
    if (number==3) {
        //return @"星期二";
        return @"Tue";
    }
    if (number==4) {
        //return @"星期三";
        return @"Wed";
    }
    if (number==5) {
       // return @"星期四";
        return @"Thu";
    }
    if (number==6) {
        //return @"星期五";
        return @"Fri";
    }
    if (number==7) {
       // return @"星期六";
        return @"Sat";
    }
    return nil;
}


-(NSString *)reFormDate:(NSString *)date{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate  * oldDate=[dateformatter dateFromString:date];
    [dateformatter setDateFormat:@"YYYY.MM.dd"];
    if ([dateformatter stringFromDate:oldDate]==nil) {
        return date;
    }
    return [dateformatter stringFromDate:oldDate];
}




-(NSString *)getWindDirectionImgFromData:(NSString *)data{

 //   NSArray *winds=[[NSArray alloc]initWithObjects:@"东风",@"南风",@"西风",@"北风",@"东南风",@"东北风",@"西南风",@"西北风", nil];
    
     NSArray *winds=[[NSArray alloc]initWithObjects:@"东南风",@"东北风",@"西南风",@"西北风",@"东风",@"南风",@"西风",@"北风", nil];
    
    
     NSString *destination = @"\n";
    for(int i=0;i<winds.count;i++){
        destination=winds[i];
        
        if ([data rangeOfString:destination].location != NSNotFound) {
            NSLog(@"有这个字符串");
            
            if (i==0) {
                return @"east_south";
            }
            if (i==1) {
                return @"east_north";
            }
            if (i==2) {
                return @"west_south";
            }
            if (i==3) {
                return @"west_north";
            }
            if (i==4) {
                return @"east";
            }
            if (i==5) {
                return @"south";
            }
            if (i==6) {
                return @"west";
            }
            if (i==7) {
                return @"north";
            }
        }
    }
    return @"north";
}


-(void)checkDataUpdate{
    if (_savedCityList.count==0|_savedCityList==nil) {
        if (_savedCityList==nil) {
            _savedCityList=[[NSMutableArray alloc]init];
        }
        [self getLocationCity];
    }else{
        [self requestSavedCityData:_savedCityList];
    }
}

#pragma mark - Location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locError:%@", error);
    
    if (_savedCityList.count>0) {
        [[NSUserDefaults standardUserDefaults]setObject:_savedCityList forKey:@"savedCities"];
        [self requestSavedCityData:_savedCityList];
    }else{
        [self.delegate handleWeatherData:weatherDataSet AndDataIntime:weatherDataIntimeSet];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [_currentLoaction stopUpdatingLocation];
    
    NSString *strLat = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.latitude];
    NSString *strLng = [NSString stringWithFormat:@"%.4f",newLocation.coordinate.longitude];
    NSLog(@"Lat: %@  Lng: %@", strLat, strLng);
    
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *_placeMark = [placemarks objectAtIndex:0];
        NSString *fullCityName=_placeMark.locality;
        NSString *cityName =[fullCityName substringToIndex:fullCityName.length-1];
        if (![[self getCodeOfCity:cityName]isEqualToString:@"null_code"]) {
            [_savedCityList addObject:cityName];
        }
        
        if (_savedCityList.count>0) {
            [[NSUserDefaults standardUserDefaults]setObject:_savedCityList forKey:@"savedCities"];
            [self requestSavedCityData:_savedCityList];
        }else{
            [self.delegate handleWeatherData:weatherDataSet AndDataIntime:weatherDataIntimeSet];
        }
        
        
    }];
}


-(void)reachabilityChanged:(NSNotification *)note{
    NetworkStatus status=[hostReach currentReachabilityStatus];
    if (status == NotReachable) {
        NSLog(@"网络不可用");
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络状态" message:@"网络连接断开" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alertView show];
    }
    else{
        NSLog(@"网络可用");
       
        if (_savedCityList.count==0|_savedCityList==nil) {
            if (_savedCityList==nil) {
                _savedCityList=[[NSMutableArray alloc]init];
            }
            [self getLocationCity];
        }else{
            [self requestSavedCityData:_savedCityList];
        }
    }
}


@end
