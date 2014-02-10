//
//  SavedCityViewController.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-12.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *cityListView;
    NSMutableArray *savedCities;
    NSIndexPath *selectedIndexPath;
    NSNumber *selectedIndex;
    NSDictionary *dic;
}

@end
