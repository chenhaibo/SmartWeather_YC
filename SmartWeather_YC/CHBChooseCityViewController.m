//
//  CHBChooseCityViewController.m
//  SmartWeather
//
//  Created by haibo chen on 13-10-18.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "CHBChooseCityViewController.h"
#import "DataSource.h"
#import "DataForSearchCity.h"
#import "WeatherData.h"
#import "WeatherDataIntime.h"

@interface CHBChooseCityViewController ()

@end

@implementation CHBChooseCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"MainView_backgroud"]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    searchResultTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 65, 320, ScreenHeight-45)];
    searchResultTable.hidden=YES;
    searchResultTable.alpha=0;
    searchResultTable.delegate=self;
    searchResultTable.dataSource=self;
    [self.view addSubview:searchResultTable];
    
    [_cancelBtn addTarget:self action:@selector(go_back) forControlEvents:UIControlEventTouchUpInside];
   [_saveBtn addTarget:self action:@selector(saveCity) forControlEvents:UIControlEventTouchUpInside];
    
    cc=[DataSource shareInstance];
    _selectedCityLabel.text=@"北京";
    
    _searchBar.placeholder=@"请输入城市名称";
    _searchBar.delegate=self;
    _searchBar.showsCancelButton=NO;
    _selectedCityPYLabel.text=@"";
    results=[[NSMutableArray alloc]init];
    
    _tempLabel.text=@"";
    _tempRangeLabel.text=@"";
    [_selectedCityPYLabel setAdjustsFontSizeToFitWidth:YES];
    [_tempLabel setAdjustsFontSizeToFitWidth:YES];
    [_tempRangeLabel setAdjustsFontSizeToFitWidth:YES];
    [_selectedCityLabel setAdjustsFontSizeToFitWidth:YES];
    
    [_changeSign setImage:[UIImage imageNamed:@"weatherChangeFlag"]];
    [_changeSign setHidden:YES];
    [_tempLogo setHidden:YES];
    dfs=[[DataForSearchCity alloc]init];
    [dfs setDelegate:self];
    [dfs startGettingWeatherDataOfCity:_selectedCityLabel.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- pickerViewDatasource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) {
        
        return cc.cityData.count;
        
    }else{
        
        int province_index=[pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDic=cc.cityData[province_index];
        NSArray *citiesArray=[provinceDic objectForKey:@"市"];
        return citiesArray.count;
    
        
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
   
    
    if (component==0) {
        NSDictionary *province=cc.cityData[row];
        return [province objectForKey:@"省"];
        
    }else{
        
        int province_index=[pickerView selectedRowInComponent:0];
        
        NSDictionary *provinceDic=cc.cityData[province_index];
        NSArray *citiesArray=[provinceDic objectForKey:@"市"];
        if (row>=citiesArray.count) {
            return @"读取中...";
        }
        NSDictionary *cityDic=citiesArray[row];
        
        return [cityDic objectForKey:@"市名"];
        
        
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     NSLog(@"row : %d  in compoint: %d",row,component);
    if (component==0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        row1=row;
        _selectedCityLabel.text=[self getPickViewTitleAtRow1:row1 AndRow2:0];
        [dfs startGettingWeatherDataOfCity:_selectedCityLabel.text];
    }else{
        _selectedCityLabel.text=[self getPickViewTitleAtRow1:row1 AndRow2:row];
        
        [dfs startGettingWeatherDataOfCity:_selectedCityLabel.text ];
        
        
    }
    
    
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return 120;
    }
    else{
        return 200;
    }
}



-(void)go_back{
    
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"DISMISS");}];
    
}
-(void)saveCity{
    
    NSMutableArray *savedCities=cc.savedCityList;
    BOOL isFind=NO;
    for (int i=0; i<savedCities.count; i++) {
        if ([_selectedCityLabel.text isEqualToString:savedCities[i]]) {
            isFind=YES;
            [self dismissViewControllerAnimated:YES completion:^{NSLog(@"DISMISS");}];
            break;
        }
    }
    if (!isFind) {
        if (savedCities.count>=8) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法收藏" message:@"达到8个最大收藏城市数量" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
            
            [alertView show];
            
        }else{
            [cc addCityWithName:_selectedCityLabel.text];
            [self dismissViewControllerAnimated:YES completion:^{NSLog(@"DISMISS");}];
        }
    }
    
    
}

//取得对应行的值
-(NSString *)getPickViewTitleAtRow1:(NSInteger)row AndRow2:(NSInteger)row2{
    
        NSDictionary *provinceDic=cc.cityData[row];
        NSArray *citiesArray=[provinceDic objectForKey:@"市"];
        NSDictionary *cityDic=citiesArray[row2];
        return [cityDic objectForKey:@"市名"];
    
}



#pragma mark-requestCityData delegate

-(void)reportWeatherData:(WeatherData *)data AndDataIntime:(WeatherDataIntime *)dataIntime{
    
    _selectedCityPYLabel.text=data.city_en;
    _tempLabel.text=dataIntime.temp;
    _tempRangeLabel.text=data.temp1;

    [_weatherImg1 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:data.img_title1]]];
    [_weatherImg2 setImage:[UIImage imageNamed:[[DataSource shareInstance]getWeatherImgNameWithData:data.img_title2]]];
    [_changeSign setHidden:NO];
    [_weatherImg1 setHidden:NO];
    [_weatherImg2 setHidden:NO];
    [_tempLogo setHidden:NO];
}

-(void)netAccessFailed{
   
    _selectedCityPYLabel.text=@"";
    _tempLabel.text=@"";
    _tempRangeLabel.text=@"";
    [_changeSign setHidden:YES];
    [_weatherImg1 setHidden:YES];
    [_weatherImg2 setHidden:YES];
    [_tempLogo setHidden:YES];
}


#pragma mark-UiAlerview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"DISMISS");}];
}


#pragma mark-UisearcherBar delegate


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [UIView animateWithDuration:0.4 animations:^{
        _searchBar.frame=CGRectMake(0, 20, 320, 44);
        searchResultTable.hidden=NO;
        searchResultTable.alpha=1;
    }completion:^(BOOL finished) {
         _searchBar.showsCancelButton=YES;
    }];
    return YES;
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchCityWithCityName:searchText];
}
//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0); // called before text changes
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
//- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar;                   // called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
 
    [UIView animateWithDuration:0.4 animations:^{
        _searchBar.showsCancelButton=NO;
        _searchBar.frame=CGRectMake(0, 228, 320, 44);
        searchResultTable.alpha=0;
    } completion:^(BOOL finished) {
        searchResultTable.hidden=YES;
    }];
}



-(void)searchCityWithCityName:(NSString *)name{
    if (![[cc getCodeOfCity:name] isEqualToString:@"null_code"]) {
        [results removeAllObjects];
        [results addObject:name];
        [searchResultTable reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    
    if (results.count>0) {
        cell.textLabel.text =results[indexPath.row];
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
     [cc addCityWithName:cell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"DISMISS");
    }];
}
@end
