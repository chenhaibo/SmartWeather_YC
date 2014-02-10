//
//  Forecast5ViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-18.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "Forecast5ViewController.h"
#import "DataSource.h"
#import "IIViewDeckController.h"

#import "WeatherData.h"
#import <mach/mach_time.h>
@interface Forecast5ViewController ()

@end

@implementation Forecast5ViewController
@synthesize theCity;
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReady) name:@"DataReadyNotification" object:nil];
    
	myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    myTableView.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"next5bg"]];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [myTableView setAllowsSelection:NO];
    [myTableView setScrollEnabled:NO];
    myTableView.delegate=self;
    myTableView.dataSource=self;
     [self.view addSubview:myTableView];

    UISwipeGestureRecognizer *swipGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackBtn)];
    swipGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"TopWeatherViewCell" owner:self options:nil];
        
        NSString *cellId=@"TopWeatherViewCell";
        
        UILabel *cityName;
        UILabel *cityNamePY;
        UIButton *backBtn;
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=views[0];
            
            cityName=(UILabel *)[cell viewWithTag:1];
            cityNamePY=(UILabel *)[cell viewWithTag:2];
            [cityName setAdjustsFontSizeToFitWidth:YES];
            [cityNamePY setAdjustsFontSizeToFitWidth:YES];
            
            cityName.text=myWeatherData.city;
            cityNamePY.text=myWeatherData.city_en;
            
            backBtn=(UIButton *)[cell viewWithTag:3];
            [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_highlighted"] forState:UIControlStateHighlighted];
            
            return cell;
        }
        
    }else{
        int index=indexPath.row;
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"WeatherInfoCell" owner:self options:nil];
        
        NSString *cellId=@"WeatherInfoCell";
        
        UILabel *dateNumber;
        UILabel *week;
        UILabel *weatherImgTitle1;
        UILabel *weatherImgTitle2;
        UILabel *tempRange;
        UIImageView *weatherImg1;
        UIImageView *weatherImg2;
        UIImageView *windDeriction;
        UILabel *wind;
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            
            
            
            cell=views[0];
            
            weatherImg1=(UIImageView *)[cell viewWithTag:3];
            weatherImg2=(UIImageView *)[cell viewWithTag:5];
            windDeriction=(UIImageView *)[cell viewWithTag:8];
            dateNumber=(UILabel *)[cell viewWithTag:1];
            week=(UILabel *)[cell viewWithTag:2];
            weatherImgTitle1=(UILabel *)[cell viewWithTag:4];
            weatherImgTitle2=(UILabel *)[cell viewWithTag:6];
            tempRange=(UILabel *)[cell viewWithTag:7];
            wind=(UILabel *)[cell viewWithTag:10];
            
            [dateNumber setAdjustsFontSizeToFitWidth:YES];
            [weatherImgTitle1 setAdjustsFontSizeToFitWidth:YES];
            [weatherImgTitle2 setAdjustsFontSizeToFitWidth:YES];
            [tempRange setAdjustsFontSizeToFitWidth:YES];
            [week setAdjustsFontSizeToFitWidth:YES];
            [wind setAdjustsFontSizeToFitWidth:YES];
            
            CGFloat time;
            
            time = BNRTimeBlock(^{
                
                [weatherImg1 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:[self getImagetitleByIndex:index*2+1]]]];
                
            });
            printf ("1111isEqual: time: %f\n", time);
            
            
            time = BNRTimeBlock(^{
                [weatherImg2 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:[self getImagetitleByIndex:index*2+2]]]];
                
            });
            printf ("2222isEqual: time: %f\n", time);
            
            
            time = BNRTimeBlock(^{
                [windDeriction setImage:[UIImage imageNamed:[[DataSource shareInstance]getWindDirectionImgFromData:[self getWindDirectionByIndex:index+1]]]];
            });
            printf ("333isEqual: time: %f\n", time);

            
            
            
            
            
            wind.text=[self getWindDirectionByIndex:index+1];
            weatherImgTitle1.text=[self getImagetitleByIndex:index*2+1];
            weatherImgTitle2.text=[self getImagetitleByIndex:index*2+2];
            dateNumber.text=dateNumArray[index-1];
            week.text=weekdayArray[index-1];
            tempRange.text=[self getTempByIndex:index+1];
            
        }
        
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 108;
    }
    else{
        return 85;
    }
}

-(NSString *)getImagetitleByIndex:(int)index{
    
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"img_title%d",index]);
    NSString *imgTitle;
    if ([myWeatherData respondsToSelector:selector]) {
        imgTitle=[myWeatherData performSelector:selector];
    }
    return imgTitle;
}
-(NSString *)getTempByIndex:(int)index{
    
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"temp%d",index]);
    NSString *temp;
    if ([myWeatherData respondsToSelector:selector]) {
        temp=[myWeatherData performSelector:selector];
    }
    return temp;
}

-(NSString *)getWindDirectionByIndex:(int)index{
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"wind%d",index]);
    NSString *temp;
    if ([myWeatherData respondsToSelector:selector]) {
        temp=[myWeatherData performSelector:selector];
    }
    return temp;
}


-(void)clickBackBtn{
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelay:0.375];
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    [UIView commitAnimations];
//    NSLog(@"------->%@",self.navigationController.viewControllers);

    [self.viewDeckController closeOpenView];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
}


-(void)dataReady{
    
    NSLog(@"2222222");
    
    theCity=[[DataSource shareInstance]currentCity];
    if (theCity==nil) {
        return;
    }
    myWeatherData=[[DataSource shareInstance]getCityDataWithName:theCity];
    
    if (myWeatherData==nil) {
        return;
    }
    
    myDateDic=[[DataSource shareInstance]getNext5DateNumberArrayWithStartDate:myWeatherData.date_y];
    dateNumArray=[myDateDic objectForKey:@"dateNumArray"];
    weekdayArray=[myDateDic objectForKey:@"weekdayArray"];
    
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [myTableView reloadData];
    [self.view addSubview:myTableView];
    
    
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
////        __block WeatherData *re_weatherData;
////        __block NSDictionary *re_dataDic;
////        __block NSMutableArray *date;
////        __block NSMutableArray *week;
//        
//        dispatch_group_t group=dispatch_group_create();
//        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
//            myWeatherData=[[DataSource shareInstance]getCityDataWithName:theCity];
//            myDateDic=[[DataSource shareInstance]getNext5DateNumberArrayWithStartDate:myWeatherData.date_y];
//            dateNumArray=[myDateDic objectForKey:@"dateNumArray"];
//            weekdayArray=[myDateDic objectForKey:@"weekdayArray"];
//            [myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//        });
//       
//        dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
//           
////            myWeatherData=re_weatherData;
////            myDateDic=re_dataDic;
////            dateNumArray=date;
////            weekdayArray=week;
//           
//           
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //[myTableView reloadData];
//                
//               
//                
//            });
//            
//        });
//        
//        
//        
//    });

    
}


CGFloat BNRTimeBlock (void (^block)(void)){
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    return (CGFloat)nanos / NSEC_PER_SEC;
    
}






@end
