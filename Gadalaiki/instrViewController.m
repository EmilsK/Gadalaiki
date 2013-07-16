//
//  instrViewController.m
//  Gadalaiki
//
//  Created by Emils Kraucis on 6/1/13.
//  Copyright (c) 2013 Emils. All rights reserved.
//

#import "instrViewController.h"
#import "ViewController.h"

@interface instrViewController ()

@end

@implementation instrViewController

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
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)back:(id)sender //dodas atpakaļ uz galveno izvēlni
{
    ViewController *View = [[ViewController alloc] init];
    [self.navigationController pushViewController:View animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
