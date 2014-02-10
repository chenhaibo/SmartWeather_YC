//
//  MainViewController.h
//  SmartWeather_YC
//
//  Created by haibo chen on 13-11-25.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "IIViewDeckController.h"
#import <CoreLocation/CoreLocation.h>
@class WeatherData;
@class WeatherDataIntime;
@interface MainViewController : UIViewController<UIScrollViewDelegate,HandleWeatherDataDelegate,CLLocationManagerDelegate,IIViewDeckControllerDelegate>
{
    @private
    NSMutableArray *savedCityList;
    NSMutableDictionary *myDataSet;
    NSMutableDictionary *myDataIntimeSet;
    WeatherData *weatherData;
    WeatherDataIntime *weatherDataIntime;
    float offx;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *viewsPageControl;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
- (IBAction)next5Show:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)suggestIndexShow:(id)sender;
- (IBAction)addCityShow:(id)sender;

@end
