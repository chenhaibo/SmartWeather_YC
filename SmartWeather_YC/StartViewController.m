//
//  StartViewController.m
//  SmartWeather_YC
//
//  Created by haibo chen on 13-12-12.
//  Copyright (c) 2013年 haibo chen. All rights reserved.
//

#import "StartViewController.h"
#import "IIViewDeckController.h"
#import "MainViewController.h"
#import "SavedCityViewController.h"
#import "SuggestViewController.h"
#import "Forecast5ViewController.h"
@interface StartViewController ()

@end

@implementation StartViewController

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
	
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController *centerController = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    
    SavedCityViewController *bottomController = (SavedCityViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SavedCityView"];
    
    Forecast5ViewController *leftController = (Forecast5ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"newNext5"];
    
    SuggestViewController *rightController =(SuggestViewController *)[storyboard instantiateViewControllerWithIdentifier:@"suggestView"];

    

   // containerController=[[IIViewDeckController alloc]initWithCenterViewController:centerController leftViewController:leftController rightViewController:rightController];
    
    containerController=[[IIViewDeckController alloc]initWithCenterViewController:centerController leftViewController:leftController rightViewController:rightController topViewController:nil bottomViewController:bottomController];
    
    containerController.leftSize = 0;
    containerController.rightSize=0;
    containerController.bottomSize=202;
    containerController.view.frame = self.view.bounds;
    [self.view addSubview:containerController.view];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
