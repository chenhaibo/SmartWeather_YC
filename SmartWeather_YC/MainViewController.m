//
//  MainViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-11-25.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "MainViewController.h"
#import "DataSource.h"
#import "WeatherData.h"
#import "WeatherDataIntime.h"
#import "Next5ViewController.h"
#import "SuggestIndexViewController.h"
#import "CHBChooseCityViewController.h"
#import "IIViewDeckController.h"
#define toRad(X) (X*M_PI/180.0)
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.viewDeckController.delegate = self;
    [self.view setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"MainView_backgroud"]]];
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netWorkChanged:) name:@"networkchangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAppointCityWithIndex:) name:@"showAppointCityNoti" object:nil];
    
    savedCityList=[[DataSource shareInstance]savedCityList];
    
    [self initViews];
    
     NSLog(@"------->%@",self.navigationController.viewControllers);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"networkchangeNotification" object:nil];
}


-(void)initViews{

    _scrollView.contentSize=CGSizeMake(320*savedCityList.count, 480);
    _scrollView.showsHorizontalScrollIndicator=YES;
    _scrollView.showsVerticalScrollIndicator=NO;
    
    _scrollView.delegate=self;
    _viewsPageControl.numberOfPages=savedCityList.count;
    _viewsPageControl.currentPage=0;
    _viewsPageControl.backgroundColor=[UIColor clearColor];
    offx=0;
    [[DataSource shareInstance]setDelegate:self];
   
}


-(void)initDefaultWeatherView{
    
}



#pragma mark scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (offx==scrollView.contentOffset.x) {
        
    }else{
        
         _viewsPageControl.currentPage=scrollView.contentOffset.x/320;
        [DataSource shareInstance].currentCity=savedCityList[_viewsPageControl.currentPage];

        offx=scrollView.contentOffset.x;
    }
   
    NSLog(@"%f",scrollView.contentOffset.x);
    
    
    
  }




//网络变化通知方法
-(void)netWorkChanged:(NSNotification *)notification{
    NSDictionary *userInfo=notification.userInfo;
    NSString *isReachable=[userInfo objectForKey:@"isReachable"];
    if ([isReachable isEqualToString:@"yes"]) {
//        [[DataSource shareInstance] requestWeatherDataWithCityName:[[NSUserDefaults standardUserDefaults]objectForKey:@"checkedCity"] Delegate:self];
        
        // [[DataSource shareInstance]startGettingWeatherDataOfCity:@"杭州"];
        
        self.title=@"网络已连接...";
        [UIView animateWithDuration:1 animations:^ {
            self.navigationController.navigationBar.alpha=0.5;
        } completion:^(BOOL finished) {
            self.navigationController.navigationBar.alpha=1;
        }];
        [self performSelector:@selector(setNavigationTitle) withObject:nil afterDelay:1];
    }else{
        self.title=@"网络断开...";
    }
}

-(void)setNavigationTitle{
    self.title=@"天气";
}



#pragma mark- handlerWeatherDataDelegate
-(void)handleWeatherData:(NSMutableDictionary *)dataSet AndDataIntime:(NSMutableDictionary *)dataIntimeSet{

    [self viewsInScrollViewClear];
    _scrollView.contentSize=CGSizeMake(320*savedCityList.count, 480);
    _viewsPageControl.numberOfPages=savedCityList.count;
    
    myDataSet=dataSet;
    myDataIntimeSet=dataIntimeSet;
    [self fillViews];
    
    if (savedCityList.count<=0) {
        [DataSource shareInstance].currentCity=@"noCity";
        [self.viewDeckController closeBottomViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            [self addCityShow:nil];
        } ];
    }else{
        [DataSource shareInstance].currentCity=savedCityList[_viewsPageControl.currentPage];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:savedCityList forKey:@"savedCities"];}

-(void)fillViews{
    for (int i=0; i<savedCityList.count; i++) {
        NSArray *views= [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
        UIView *weatherView=(UIView*)views[0];
        weatherView.frame=CGRectMake(320*i, 0, 320, 500);
        weatherData=[self getCityDataWithName:savedCityList[i]];
        weatherDataIntime=[self getCityDataIntimeWithName:savedCityList[i]];
        
        UILabel *cityName=(UILabel *)[weatherView viewWithTag:1];
        UILabel *cityNamePY=(UILabel *)[weatherView viewWithTag:2];
        UILabel *date=(UILabel *)[weatherView viewWithTag:3];
        UILabel *weekday=(UILabel *)[weatherView viewWithTag:4];
        UILabel *tempRange=(UILabel *)[weatherView viewWithTag:5];
        UILabel *weatherDescribe1=(UILabel *)[weatherView viewWithTag:8];
        UILabel *weatherDescribe2=(UILabel *)[weatherView viewWithTag:9];
        UILabel *wind=(UILabel *)[weatherView viewWithTag:21];
        UILabel *temp=(UILabel *)[weatherView viewWithTag:25];
        UILabel *pub=(UILabel *)[weatherView viewWithTag:26];
        
        UIImageView *weatherImage1=(UIImageView*)[weatherView viewWithTag:6];
        UIImageView *weatherImage2=(UIImageView*)[weatherView viewWithTag:7];
        UIImageView *arrowImage=(UIImageView*)[weatherView viewWithTag:20];
        
        
        [temp setAdjustsFontSizeToFitWidth:YES];
        [pub setAdjustsFontSizeToFitWidth:YES];
        [cityName setAdjustsFontSizeToFitWidth:YES];
        [cityNamePY setAdjustsFontSizeToFitWidth:YES];
        [date setAdjustsFontSizeToFitWidth:YES];
        [weekday setAdjustsFontSizeToFitWidth:YES];
        [tempRange setAdjustsFontSizeToFitWidth:YES];
        [weatherDescribe1 setAdjustsFontSizeToFitWidth:YES];
        [weatherDescribe2 setAdjustsFontSizeToFitWidth:YES];
        
        [arrowImage setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:[[DataSource shareInstance]getWindDirectionImgFromData:weatherData.wind1]]]];
        wind.text=weatherData.wind1;
        [wind setAdjustsFontSizeToFitWidth:YES];
        
        NSString *SD= weatherDataIntime.SD;
        NSArray *SDParts=[SD componentsSeparatedByString:@"%"];
        NSString *SDvalue=SDParts[0];
        int SDLeval=[SDvalue intValue]/20+1;
        if (SDLeval==5) {
            UIImageView *humidiy6=(UIImageView*)[weatherView viewWithTag:15];
            humidiy6.hidden=YES;
        }
        if (SDLeval==4) {
            UIImageView *humidiy6=(UIImageView*)[weatherView viewWithTag:15];
            UIImageView *humidiy5=(UIImageView*)[weatherView viewWithTag:14];
            humidiy6.hidden=YES;
            humidiy5.hidden=YES;
        }
        if (SDLeval==3) {
            UIImageView *humidiy6=(UIImageView*)[weatherView viewWithTag:15];
            UIImageView *humidiy5=(UIImageView*)[weatherView viewWithTag:14];
            UIImageView *humidiy4=(UIImageView*)[weatherView viewWithTag:13];
            humidiy6.hidden=YES;
            humidiy5.hidden=YES;
            humidiy4.hidden=YES;
        }
        if (SDLeval==2) {
            UIImageView *humidiy6=(UIImageView*)[weatherView viewWithTag:15];
            UIImageView *humidiy5=(UIImageView*)[weatherView viewWithTag:14];
            UIImageView *humidiy4=(UIImageView*)[weatherView viewWithTag:13];
            UIImageView *humidiy3=(UIImageView*)[weatherView viewWithTag:12];
            humidiy6.hidden=YES;
            humidiy5.hidden=YES;
            humidiy4.hidden=YES;
            humidiy3.hidden=YES;
        }
        if (SDLeval==1) {
            UIImageView *humidiy6=(UIImageView*)[weatherView viewWithTag:15];
            UIImageView *humidiy5=(UIImageView*)[weatherView viewWithTag:14];
            UIImageView *humidiy4=(UIImageView*)[weatherView viewWithTag:13];
            UIImageView *humidiy3=(UIImageView*)[weatherView viewWithTag:12];
            UIImageView *humidiy2=(UIImageView*)[weatherView viewWithTag:11];
            humidiy6.hidden=YES;
            humidiy5.hidden=YES;
            humidiy4.hidden=YES;
            humidiy3.hidden=YES;
            humidiy2.hidden=YES;
        }

        //天气图标
        [weatherImage1 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:weatherData.img_title1]]];
        [weatherImage2 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:weatherData.img_title2]]];
        
        [cityName setText:weatherData.city];
        [cityNamePY setText:weatherData.city_en];
        
        [date setText:[[DataSource shareInstance]reFormDate:weatherData.date_y]];
        
        [weekday setText:weatherData.week];
        [tempRange setText:weatherData.temp1];
        [weatherDescribe1 setText:weatherData.img_title1];
        [weatherDescribe2 setText:weatherData.img_title2];
        
        [temp setText:weatherDataIntime.temp];
        
         [_scrollView addSubview:weatherView];
    }
}


-(void)viewsInScrollViewClear{
    NSArray *viewsInScroll =[_scrollView subviews];
    if (viewsInScroll) {
        if (viewsInScroll.count>0) {
            for (int i=0; i<viewsInScroll.count; i++) {
                UIView *view=(UIView *)viewsInScroll[i];
                [view removeFromSuperview];
            }
        }
    }
}



-(WeatherData *)getCityDataWithName:(NSString *)cityName{
   // NSString *timeNow=[[DataSource shareInstance]getSystemTime:NO];
    NSEnumerator *enumerator = [myDataSet keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject]))
    {
        //NSLog(@">>>>>>>>>@@@>>>%@", key);
        NSArray *parts=[key componentsSeparatedByString:@"_"];
        if ([parts[0]isEqualToString:cityName]) {
            return [myDataSet objectForKey:key];
        }
        
    }

    return nil;
    
}

-(WeatherDataIntime *)getCityDataIntimeWithName:(NSString *)cityName{
    //NSString *timeNow=[[DataSource shareInstance]getSystemTime:NO];
    NSEnumerator *enumerator = [myDataIntimeSet keyEnumerator];
    NSString *key;
    
    while ((key = [enumerator nextObject]))
    {
        //NSLog(@">>>>>>>>>@@@>>>%@", key);
        NSArray *parts=[key componentsSeparatedByString:@"_"];
        if ([parts[0]isEqualToString:cityName]) {
            return [myDataIntimeSet objectForKey:key];
        }
        
    }
    
    return nil;

}

- (IBAction)next5Show:(id)sender {
    
    
    
//    Next5ViewController *next5=[[Next5ViewController alloc]init];
//    if ([next5 respondsToSelector:@selector(setTheCity:)]) {
//        [next5 setTheCity:savedCityList[_viewsPageControl.currentPage]];
//    }
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [self.navigationController pushViewController:next5 animated:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//    
//    NSLog(@"------->%@",self.navigationController.viewControllers);
    
    [self.viewDeckController openLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
         NSLog(@"2222222sfsfsf");
    }];
    
}
- (IBAction)suggestIndexShow:(id)sender {
    
   
    
//    SuggestIndexViewController *suggest=[[SuggestIndexViewController alloc]init];
//    if ([suggest respondsToSelector:@selector(setTheCity:)]) {
//        [suggest setTheCity:savedCityList[_viewsPageControl.currentPage]];
//    }
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [self.navigationController pushViewController:suggest animated:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
    
    // NSLog(@"------->%@",self.navigationController.viewControllers);
    
    [self.viewDeckController openRightView];
}

- (IBAction)addCityShow:(id)sender {
    
    CHBChooseCityViewController *addCity=[[CHBChooseCityViewController alloc]initWithNibName:@"CHBChooseCityViewController" bundle:nil];
    addCity.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:addCity animated:YES completion:^{NSLog(@"call back");}];
    
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter]postNotification:[[NSNotification alloc]initWithName:@"DataReadyNotification" object:nil userInfo:nil]];
    
    if (viewDeckSide==IIViewDeckBottomSide) {
        [[NSNotificationCenter defaultCenter]postNotification:[[NSNotification alloc]initWithName:@"savedCityChangedNotification" object:nil userInfo:nil]];
    }
}


-(void)showAppointCityWithIndex:(NSNotification *)notifi{
    
    NSNumber *theIndex=[notifi.userInfo objectForKey:@"index"];
    [_scrollView scrollRectToVisible:CGRectMake(320*[theIndex intValue], 0, 320, 500) animated:YES];
    _viewsPageControl.currentPage=[theIndex intValue];
    [DataSource shareInstance].currentCity=savedCityList[_viewsPageControl.currentPage];
}



@end
