#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "APAddress.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "APPhoneWithLabel.h"
#import "APSocialProfile.h"
#import "APTypes.h"

FOUNDATION_EXPORT double APAddressBookVersionNumber;
FOUNDATION_EXPORT const unsigned char APAddressBookVersionString[];

