#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "color" asset catalog image resource.
static NSString * const ACImageNameColor AC_SWIFT_PRIVATE = @"color";

/// The "date" asset catalog image resource.
static NSString * const ACImageNameDate AC_SWIFT_PRIVATE = @"date";

/// The "map_b" asset catalog image resource.
static NSString * const ACImageNameMapB AC_SWIFT_PRIVATE = @"map_b";

/// The "map_s" asset catalog image resource.
static NSString * const ACImageNameMapS AC_SWIFT_PRIVATE = @"map_s";

/// The "more" asset catalog image resource.
static NSString * const ACImageNameMore AC_SWIFT_PRIVATE = @"more";

/// The "one" asset catalog image resource.
static NSString * const ACImageNameOne AC_SWIFT_PRIVATE = @"one";

/// The "two" asset catalog image resource.
static NSString * const ACImageNameTwo AC_SWIFT_PRIVATE = @"two";

/// The "user" asset catalog image resource.
static NSString * const ACImageNameUser AC_SWIFT_PRIVATE = @"user";

/// The "word" asset catalog image resource.
static NSString * const ACImageNameWord AC_SWIFT_PRIVATE = @"word";

#undef AC_SWIFT_PRIVATE
