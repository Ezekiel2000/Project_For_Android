//
//  SANavigationController.m
//  SandArtApp
//
//  Created by Calvin on 2014. 1. 25..
//  Copyright (c) 2014년 CCC Korea. All rights reserved.
//

#import "SANavigationController.h"

@interface SANavigationController ()

@end

@implementation SANavigationController

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
	// Do any additional setup after loading the view.
}

- (void)setSelectedTabBarItemImage:(NSString *)name
{
    // Changes SelectedTabBarItem Image
    self.tabBarItem.selectedImage = [UIImage imageNamed:name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
