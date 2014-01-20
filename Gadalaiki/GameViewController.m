//
//  GameViewController.m
//  Gadalaiki
//
//  Created by Emils Kraucis
//  Copyright (c) 2013 Emils Kraucis. All rights reserved.
//

#import "GameViewController.h"
#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()

@end

@implementation GameViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLevel:(int)level // padod int level kas ir līmenis, atiecīgi ielasa nepiecišamo plist failu
{
  self = [super init];
    self.l = level;
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      [NSString stringWithFormat:@"level%d", level] ofType:@"plist"];
    self.levelInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    self.gamePieces = [[NSMutableArray alloc] init];
    self.imageNames = [self.levelInfo objectForKey:@"Images"];
    if (self.l==4) {
        self.lastPosition = CGPointMake(115, 671);
        [self animationStartDelay];
    }
    else {
    self.lastPosition = CGPointMake(140, 671); // sākuma pozīcija bilžu rādīšanai
    [self animationStartDelay];
    }
     // izsauc funkciju kas aiztur kāršu rādīšanos, kamēr ekrāns ielādējas
return self;
}

-(void) animationStartDelay // Pēc attiecīga laika izsauc funkciju kas izveido bildes
{
    CGFloat startDelay = 0.6;
    [self performSelector:@selector(setupImages) withObject:self afterDelay:startDelay];
}

- (void)setupImages // funkcija, kas saliek ielasītos attēlus uz ekrāna lai varētu sākt tos kārtot
{
    CGFloat animationTimePerView = 0.20;
    CGFloat checkButtonDelay = 1.7;
    if (self.l == 1) //pirmajam līmenim ātrāk japarāda
    {
        checkButtonDelay = 0.8;
    }
    else if (self.l == 4)     {
        checkButtonDelay = 2.2;
    }
    else //pārējiem
    {
        checkButtonDelay = 1.7;
    }
    int i = 0;
    for (NSString *imageName in self.imageNames) //cikls bilžu ielasīšanai 
    {
        [self performSelector: @selector(addView:) withObject:imageName afterDelay: i*animationTimePerView];
        i++;
    }
    [self performSelector:@selector(showCheckButton) withObject:self afterDelay:checkButtonDelay]; //dodas uz funkciju kas aiztur pārbaudes pogas parādīšanos līdz ir parādijušies visi attēli
}

-(void) showCheckButton // pēc laika nobīdes parādas pārbaudes poga 
{
    _check.hidden = NO;
}

- (void)addView:(id)sender //kartīšu un mērķu darbības/ pievienošana
{
//     NSLog(@"--%@, %@", sender, [self.imageNames objectForKey:sender]);
    CGSize cardSize = CGSizeMake(75, 75); // definēts kartītes izmērs
    DroppableView * dropview = [[DroppableView alloc] initWithDropTarget: self.dropTarget1];
    [dropview addDropTarget:self.dropTarget2];
    [dropview addDropTarget:self.dropTarget3];
    [dropview addDropTarget:self.dropTarget4];
    
    NSInteger target = [[self.imageNames objectForKey:sender] integerValue];
    if (target == 1) {
        dropview.correctDropTarget = self.dropTarget1;
    } else if (target == 2) {
        dropview.correctDropTarget = self.dropTarget2;
    } else if (target == 3) {
        dropview.correctDropTarget = self.dropTarget3;
    } else {
        dropview.correctDropTarget = self.dropTarget4;
    }
    
    dropview.layer.cornerRadius = 3; //izmantots QuarzCore maliņu noapaļošanai
    dropview.layer.masksToBounds = YES; // prieķš malu noapaļošanas
    dropview.frame = CGRectMake(self.lastPosition.x, self.lastPosition.y, cardSize.width, cardSize.height);
    UIImageView *gamePiece = [[UIImageView alloc] initWithImage:[UIImage imageNamed:sender]];
    [dropview addSubview:gamePiece];
    dropview.delegate = self;
    // pievieno kartīti pozīcijā
    if (self.l == 1) // pirmaijam līmenim tikai 4 kartiņas nepieciešamas platakas atstarpes
    {
        self.lastPosition = CGPointMake(dropview.frame.origin.x + cardSize.width + 140, self.lastPosition.y);
    }
    else if (self.l == 4)     {
        self.lastPosition = CGPointMake(dropview.frame.origin.x + cardSize.width + 3, self.lastPosition.y);
    }
    else //parējiem atstarpes
    {
        self.lastPosition = CGPointMake(dropview.frame.origin.x + cardSize.width + 18, self.lastPosition.y);
    }
    [self.gamePieces addObject:dropview];
    [self.view addSubview: dropview];
}

- (BOOL)shouldAnimateDroppableViewBack:(DroppableView*)view wasDroppedOnTarget:(UIView*)target
{
    //  Funkcija kas pārbauda vai novietotā vieta ir derīga, ja ne atgriež iepriekšējā stāvoklī
    CGPoint p = view.center;
if (p.y < 90)//augša
        {
            return YES;
            }
  else if (p.x > 475 && p.x < 550) //vertikālā līnija
       {
           return YES;
            }
  else if (p.y > 620) //apakša
  {
      return YES;
  }
    else if (p.y > 320 && p.y < 390 )//horizontālā līnija
        {
            return YES;
            }
    
    view.currentDropTarget = target;
    return NO;
}

- (IBAction)checkIfCorrect // kāršu novietojuma pārbaude
{
    int mistakes = 0; //kļūdas
    for (DroppableView *view in self.gamePieces) //iet cauri katrai karti to parbaudot, ja kļūdas mistakes int pieaug
        {
        if (view.correctDropTarget != view.currentDropTarget) {
            mistakes++;
        }
    }
    NSLog(@"ir %d kļūdas", mistakes); //kļūdu izvade konsolē
    if (mistakes == 1) //pie vienas kļūdas locijums cits tapec atdalam atsevišķi
    {
        [_pointsToScreen setText:[NSString stringWithFormat:@"Tev ir %d kļūda", mistakes]];
    }
    else if (mistakes != 0) //cita skaita kļūdas
    {
        [_pointsToScreen setText:[NSString stringWithFormat:@"Tev ir %d kļūdas", mistakes]];
    }
    else //izvade ja pareizi viss sakārtots
    { [_pointsToScreen setText:[NSString stringWithFormat:@"Lieliski! Sakārtoji pareizi"]];
        _check.hidden = YES; //kad pareizi viss atbildēts pazūd arī parbaudes poga
        if (self.l < 4) {
            _nextTask.hidden = NO; // pie pareizām atbildēm tiek atļauts doties tālāk
        }
        else {
            _nextTask.hidden = YES; // ja esi pēdējā līmenī uz tālāku līmeni nevar doties, tikai atpakaļ
        }
    }
}

- (IBAction)back:(id)sender // pogas kas atgriež atpakaļ uz spēles sākumu
{
    ViewController *View = [[ViewController alloc] init];
    [self.navigationController pushViewController:View animated:NO];
}
- (IBAction)nextLevel:(id)sender {
    // pēc pareizi izpildīta uzdevuma parādas iespēja tikt uz nakošo līmeni
    {
        int l = _l;
        if (l<4) // ja esi pēdējā līmenī poga neparādas un iespēja tikt atpakaļ tikai uz sākumu
        {
            GameViewController *gameView = [[GameViewController alloc] initWithLevel:++l];
            [self.navigationController pushViewController:gameView animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
