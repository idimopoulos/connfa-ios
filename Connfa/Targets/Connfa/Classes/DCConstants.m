//
//  DCConstants.m
//  DrupalCon
//
//  Created by Roman Malinovskyi on 2/6/17.
//  Copyright © 2017 Lemberg Solution. All rights reserved.
//

#import "DCConstants.h"


@implementation DCConstants

NSString *const BASE_URL = @"https://connfa.guadec.org/api/v2/guadec2019/";;
NSString *const SERVER_URL = @"https://connfa.guadec.org/";
NSString *const BUNDLE_NAME = @"DC-Theme";
NSString *const GOOGLE_ANALYTICS_APP_ID = @"UA-93776333-4";
NSString *const TWITTER_API_KEY = @"Mxl1GoGSM98T3jTIWdlUuqXmh";
NSString *const TWITTER_API_SECRET = @"UM74rykaGhxPhhKED2KxJrd6zGBLNWgVsGdlzjdSwSNqLTiyqY";
NSString *const EVENT_NAME = @"GUADEC";

+ (NSArray *)appMenuItems {
    NSArray *menuItems = @[
            [DCMenuItem initWithTitle:@"Sessions" icon:@"menu_icon_program" selectedIcon:@"menu_icon_program_sel" controllerId:@"DCProgramViewController" andMenuType:@(DCMENU_PROGRAM_ITEM)],

            [DCMenuItem initWithTitle:@"BoFs" icon:@"menu_icon_bofs" selectedIcon:@"menu_icon_bofs_sel" controllerId:@"DCProgramViewController" andMenuType:@(DCMENU_BOFS_ITEM)],

            [DCMenuItem initWithTitle:@"Social Events" icon:@"menu_icon_social" selectedIcon:@"menu_icon_social_sel" controllerId:@"DCProgramViewController" andMenuType:@(DCMENU_SOCIAL_EVENTS_ITEM)],

            [DCMenuItem initWithTitle:@"Social Media" icon:@"menu_icon_social_media" selectedIcon:@"menu_icon_social_media_sel" controllerId:@"DCSocialMediaViewController" andMenuType:@(DCMENU_SOCIALMEDIA_ITEM)],

            [DCMenuItem initWithTitle:@"Speakers" icon:@"menu_icon_speakers" selectedIcon:@"menu_icon_speakers_sel" controllerId:@"SpeakersViewController" andMenuType:@(DCMENU_SPEAKERS_ITEM)],

            [DCMenuItem initWithTitle:@"My Schedule" icon:@"menu_icon_my_schedule" selectedIcon:@"menu_icon_my_schedule_sel" controllerId:@"DCProgramViewController" andMenuType:@(DCMENU_MYSCHEDULE_ITEM)],

            [DCMenuItem initWithTitle:@"Floor Plans" icon:@"menu_icon_floor_plan" selectedIcon:@"menu_icon_floor_plan_sel" controllerId:@"DCFloorPlanController" andMenuType:@(DCMENU_FLOORPLAN_ITEM)],

            [DCMenuItem initWithTitle:@"Location" icon:@"menu_icon_location" selectedIcon:@"menu_icon_location_sel" controllerId:@"LocationViewController" andMenuType:@(DCMENU_LOCATION_ITEM)],

            [DCMenuItem initWithTitle:@"Info" icon:@"menu_icon_about" selectedIcon:@"menu_icon_about_sel" controllerId:@"InfoViewController" andMenuType:@(DCMENU_INFO_ITEM)],

            [DCMenuItem initWithTitle:@"No available" icon:@"No available" selectedIcon:@"No available" controllerId:@"No available" andMenuType:@(DCMENU_SIZE)]
    ];

    return menuItems;
}

+ (NSArray *)appFonts {

    NSArray *fonts = @[
            [DCFontItem initWithTitleFont:kFontHelveticaNeueRegular andNameFont:kFontHelveticaNeueRegular andDescriptionFont:kFontHelveticaNeueRegular]
    ];

    return fonts;
}

@end
