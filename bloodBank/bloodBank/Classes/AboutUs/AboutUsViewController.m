//
//  AboutUsViewController.m
//  bloodBank
//
//  Created by amar tk on 03/11/14.
//  Copyright (c) 2014 StartKoding. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MBProgressHUD.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"aboutUs" ofType:@"html"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_aboutUsWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -WebView Delegates -

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[webView scrollView] setBounces:NO];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];

}

@end
