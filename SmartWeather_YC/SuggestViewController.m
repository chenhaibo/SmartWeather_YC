//
//  SuggestViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-18.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "SuggestViewController.h"
#import "DataSource.h"
#import "WeatherData.h"
#import "IIViewDeckController.h"
@interface SuggestViewController ()

@end

@implementation SuggestViewController
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
    
    [self.view setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"MainView_backgroud"]]];
	myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    myTableView.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"suggestBg"]];
    
    [myTableView setAllowsSelection:NO];
    [myTableView setScrollEnabled:NO];
    [myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UISwipeGestureRecognizer *swipGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(clickBackBtn)];
    swipGesture.direction=UISwipeGestureRecognizerDirectionRight;
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"topSuggestView" owner:self options:nil];
        
        NSString *cellId=@"topSuggestView";
        
        UILabel *cityName;
        UIButton *backBtn;
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=views[0];
            
            cityName=(UILabel *)[cell viewWithTag:1];
            
            
            cityName.text=myWeatherData.city;
            
            backBtn=(UIButton *)[cell viewWithTag:2];
            [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
            [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_highlighted"] forState:UIControlStateHighlighted];
            return cell;
        }
        
    }else{
        NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"suggestionCell" owner:self options:nil];
        
        NSString *cellId=@"suggestionCell";
        UIImageView *imageShow;
        UILabel *title;
        UILabel *content;
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=views[0];
            imageShow=(UIImageView *)[cell viewWithTag:1];
            title=(UILabel *)[cell viewWithTag:2];
            content=(UILabel *)[cell viewWithTag:3];
            
            [imageShow setImage:[UIImage imageNamed:[self getImgWithIndex:indexPath.row]]];
            title.text=[self getTitleWithIndex:indexPath.row];
            content.text=[self getContentWithIndex:indexPath.row];
            
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 88;
    }
    else{
        return 63;
    }
}


-(NSString *)getTitleWithIndex:(int)index{
    if (index==1) {
        return @"穿衣指数";
    }
    if (index==2) {
        return @"晾晒指数";
    }
    if (index==3) {
        return @"晨练指数";
    }
    if (index==4) {
        return @"出行指数";
    }
    if (index==5) {
        return @"洗车指数";
    }
    if (index==6) {
        return @"紫外线指数";
    }
    if (index==7) {
        return @"过敏指数";
    }
    return nil;
}

-(NSString *)getContentWithIndex:(int)index{
    if (index==1) {
        return myWeatherData.index;
    }
    if (index==2) {
        return myWeatherData.index_ls;
    }
    if (index==3) {
        return myWeatherData.index_cl;
    }
    if (index==4) {
        return myWeatherData.index_tr;
    }
    if (index==5) {
        return myWeatherData.index_xc;
    }
    if (index==6) {
        return myWeatherData.index_uv;
    }
    if (index==7) {
        return myWeatherData.index_ag;
    }
    return nil;
}

-(NSString *)getImgWithIndex:(int)index{
    if (index==1) {
        return @"index1";
    }
    if (index==2) {
        return @"index2";
    }
    if (index==3) {
        return @"index3";
    }
    if (index==4) {
        return @"index4";
    }
    if (index==5) {
        return @"index5";
    }
    if (index==6) {
        return @"index6";
    }
    if (index==7) {
        return @"index7";
    }
    return nil;
}


-(void)clickBackBtn{
    
//    [UIView  beginAnimations:nil context:NULL];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelay:0.375];
//    //[self.navigationController popToRootViewControllerAnimated:NO];
//    [self.navigationController popViewControllerAnimated:YES];
//    [UIView commitAnimations];
//    NSLog(@"------->%@",self.navigationController.viewControllers);
    
     [self.viewDeckController closeOpenView];
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
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [myTableView reloadData];
    [self.view addSubview:myTableView];
}



@end
