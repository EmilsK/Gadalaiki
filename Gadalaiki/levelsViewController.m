//
//  levelsViewController.m
//  Gadalaiki
//
//  Created by Emils Kraucis on 6/1/13.
//  Copyright (c) 2013 Emils. All rights reserved.
//

#import "levelsViewController.h"
#import "GameViewController.h"
#import "ViewController.h"

@interface levelsViewController ()

@end

@implementation levelsViewController

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
- (IBAction)toLevel1:(id)sender //dodas uz 1 līmeni
    {
    GameViewController *gameView = [[GameViewController alloc] initWithLevel:1];
    [self.navigationController pushViewController:gameView animated:YES];
    }
- (IBAction)toLevel2:(id)sender //dodas uz otro līmeni
{
    GameViewController *gameView = [[GameViewController alloc] initWithLevel:2];
    [self.navigationController pushViewController:gameView animated:YES];
}
- (IBAction)toLevel3:(id)sender //dodas uz trešo līmeni
{
    GameViewController *gameView = [[GameViewController alloc] initWithLevel:3];
    [self.navigationController pushViewController:gameView animated:YES];
}
- (IBAction)toLevel4:(id)sender //dodas uz 4 līmeni
{
    GameViewController *gameView = [[GameViewController alloc] initWithLevel:4];
    [self.navigationController pushViewController:gameView animated:YES];
}
- (IBAction)back:(id)sender //dodas uz 5 līmeni
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
