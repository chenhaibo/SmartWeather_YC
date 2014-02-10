//
//  SavedCityViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-12.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "SavedCityViewController.h"
#import "DataSource.h"
#import "IIViewDeckController.h"
#import "FXLabel.h"

@interface SavedCityViewController ()

@end

@implementation SavedCityViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI) name:@"savedCityChangedNotification" object:nil];
     [self.view setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"2-3screen"]]];
    savedCities = [[DataSource shareInstance]savedCityList];
    cityListView=[[UITableView alloc]initWithFrame:CGRectMake(0, 202, 320, 379)];
    cityListView.backgroundColor=[UIColor clearColor];
    [cityListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [cityListView setScrollEnabled:NO];
    cityListView.delegate=self;
    cityListView.dataSource=self;
    [self.view addSubview:cityListView];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[cityListView reloadData];
}

//设置tableview是否可以被编辑
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    if (cityListView.editing) {
        [cityListView setEditing:NO animated:YES];
        
    }else{
        
        [cityListView setEditing:YES animated:YES];
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *cityName=savedCities[indexPath.row];
        //[savedCities removeObjectAtIndex:indexPath.row];
        [[DataSource shareInstance]removeCityWithName:cityName AndPosition:indexPath.row] ;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
    }
    
}

//设置表格中某一行是否可以被编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==savedCities.count) {
//        return false;
//    }
    return true;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return savedCities.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        NSArray *views=[[NSBundle mainBundle] loadNibNamed:@"savedCityCell" owner:self options:nil];
        UIImageView *cityImage;
        NSString *cellId=@"savedCityCell";
        
        FXLabel *cityName;
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=views[0];
            
            cityImage=(UIImageView *)[cell viewWithTag:1];
            cityName=(FXLabel *)[cell viewWithTag:2];
            
            
//            cityName.shadowColor = [UIColor blackColor];
//            cityName.shadowOffset = CGSizeZero;
//            cityName.shadowBlur = 20.0f;
//            cityName.innerShadowColor = [UIColor yellowColor];
//            cityName.innerShadowOffset = CGSizeMake(1.0f, 2.0f);
//            cityName.gradientStartColor = [UIColor redColor];
//            cityName.gradientEndColor = [UIColor yellowColor];
//            cityName.gradientStartPoint = CGPointMake(0.0f, 0.5f);
//            cityName.gradientEndPoint = CGPointMake(1.0f, 0.5f);
//            cityName.oversampling = 2;
//            cityName.text=savedCities[indexPath.row];
            
            cityName.shadowColor = nil;
            cityName.shadowOffset = CGSizeMake(0.0f, 2.0f);
            cityName.shadowColor = [UIColor colorWithWhite:100.0f alpha:0.75f];
            cityName.shadowBlur = 5.0f;
            cityName.text=savedCities[indexPath.row];
            
        }
        return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewDeckController closeBottomViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        selectedIndex=[[NSNumber alloc]initWithInt:indexPath.row];
        
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:selectedIndex,@"index", nil];
        [[NSNotificationCenter defaultCenter]postNotification:[[NSNotification alloc]initWithName:@"showAppointCityNoti" object:nil userInfo:dic]];
    }];
}


-(void)updateUI{
    [cityListView reloadData];
}

@end
