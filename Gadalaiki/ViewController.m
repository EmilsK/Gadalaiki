//
//  ViewController.m
//  Gadalaiki
//
//  Created by Emils Kraucis on 5/30/13.
//  Copyright (c) 2013 Emils Kraucis. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"
#import "levelsViewController.h"
#import "instrViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)startGame:(id)sender // dodas uz spēles sākšanu GameViewController 1 līmeni
{
   /* GameViewController *gameView = [[GameViewController alloc] init];
    [self.navigationController pushViewController:gameView animated:YES]; */
    
    GameViewController *gameView = [[GameViewController alloc] initWithLevel:1];
    [self.navigationController pushViewController:gameView animated:YES];
}

- (IBAction)toLevels:(id)sender // Ivēlnes iespēja līmeņi. Dodas uz līmeņu izvēles ekrānu levelsViewController
{
    levelsViewController *levelsView = [[levelsViewController alloc] init];
    [self.navigationController pushViewController:levelsView animated:YES];
}

- (IBAction)toInstr:(id)sender // Izvēlnes iespēja Instrukcija. Dodas uz instrukcijas klasi instrViewController
{
    instrViewController *instrView = [[instrViewController alloc] init];
    [self.navigationController pushViewController:instrView animated:YES];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
