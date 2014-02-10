//
//  SuggestIndexViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-11.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "SuggestIndexViewController.h"
#import "DataSource.h"
#import "WeatherData.h"
@interface SuggestIndexViewController ()

@end

@implementation SuggestIndexViewController
@synthesize theCity;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor=[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"MainView_backgroud"]];
    myWeatherData=[[DataSource shareInstance]getCityDataWithName:theCity];
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
        return 70;
    }
    else{
        return 58;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


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
   
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
    NSLog(@"------->%@",self.navigationController.viewControllers);
}

@end
