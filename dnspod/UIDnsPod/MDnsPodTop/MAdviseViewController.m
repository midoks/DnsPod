//
//  MAdviceViewController.m
//  dnspod
//
//  Created by midoks on 15/1/11.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "MAdviseViewController.h"
#import "SlideNavigationController.h"
#import <MessageUI/MessageUI.h>

@interface MAdviseViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation MAdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"开发建议";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    [mailPicker setSubject:@"DnsPod iOS Client Advise"];
    [mailPicker setToRecipients:[NSArray arrayWithObjects:@"midoks@163.com",@"renlairenwang@foxmail.com", nil]];
    [mailPicker setCcRecipients:[NSArray arrayWithObjects:@"midoks@163.com", nil]];
    [mailPicker setMessageBody:@"your advise" isHTML:NO];
    [self presentViewController:mailPicker animated:YES completion:nil];
    
    MAdviseViewControllerSingle = self;
}

static MAdviseViewController *MAdviseViewControllerSingle;
+(MAdviseViewController *)sharedInstance
{
    if (!MAdviseViewControllerSingle) {
        return [[self alloc] init];
    }
    return MAdviseViewControllerSingle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error

{
    switch (result){
        case MFMailComposeResultCancelled:NSLog(@"Mail send canceled…");break;
        case MFMailComposeResultSaved:NSLog(@"Mail saved…");break;
        case MFMailComposeResultSent:NSLog(@"Mail sent…");break;
        case MFMailComposeResultFailed:NSLog(@"Mail send errored: %@…", [error localizedDescription]);break;
        default:break;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        //[[SlideNavigationController sharedInstance] ];
    }];
}

@end
