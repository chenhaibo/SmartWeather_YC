//
//  Next5ViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-9.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "Next5ViewController.h"
#import "DataSource.h"
#import "WeatherData.h"
@interface Next5ViewController ()

@end

@implementation Next5ViewController
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
    myDateDic=[[DataSource shareInstance]getNext5DateNumberArrayWithStartDate:myWeatherData.date_y];
    dateNumArray=[myDateDic objectForKey:@"dateNumArray"];
    weekdayArray=[myDateDic objectForKey:@"weekdayArray"];

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
            
            [weatherImg1 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:[self getImagetitleByIndex:index*2+1]]]];
            [weatherImg2 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:[self getImagetitleByIndex:index*2+2]]]];

            [windDeriction setImage:[UIImage imageNamed:[[DataSource shareInstance]getWindDirectionImgFromData:[self getWindDirectionByIndex:index+1]]]];
            
            
            
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
        return 110;
    }
    else{
        return 90;
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
        [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:YES];
    
    [UIView commitAnimations];
    NSLog(@"------->%@",self.navigationController.viewControllers);

}

@end
