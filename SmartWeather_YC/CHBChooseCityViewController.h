//
//  CHBChooseCityViewController.h
//  SmartWeather
//
//  Created by haibo chen on 13-10-18.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataForSearchCity.h"
@class DataSource;
@interface CHBChooseCityViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate,requestCityDataDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    @private
    DataSource *cc;
    int row1;
    DataForSearchCity *dfs;
    UITableView *searchResultTable;
    NSMutableArray *results;
}

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedCityLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *selectedCityPYLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempRangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg1;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg2;

@property (weak, nonatomic) IBOutlet UIImageView *changeSign;
@property (weak, nonatomic) IBOutlet UIImageView *tempLogo;


@end
