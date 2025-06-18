import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "collect" asset catalog image resource.
    static let collect = DeveloperToolsSupport.ImageResource(name: "collect", bundle: resourceBundle)

    /// The "color" asset catalog image resource.
    static let color = DeveloperToolsSupport.ImageResource(name: "color", bundle: resourceBundle)

    /// The "comment" asset catalog image resource.
    static let comment = DeveloperToolsSupport.ImageResource(name: "comment", bundle: resourceBundle)

    /// The "date" asset catalog image resource.
    static let date = DeveloperToolsSupport.ImageResource(name: "date", bundle: resourceBundle)

    /// The "eight" asset catalog image resource.
    static let eight = DeveloperToolsSupport.ImageResource(name: "eight", bundle: resourceBundle)

    /// The "five" asset catalog image resource.
    static let five = DeveloperToolsSupport.ImageResource(name: "five", bundle: resourceBundle)

    /// The "four" asset catalog image resource.
    static let four = DeveloperToolsSupport.ImageResource(name: "four", bundle: resourceBundle)

    /// The "heart" asset catalog image resource.
    static let heart = DeveloperToolsSupport.ImageResource(name: "heart", bundle: resourceBundle)

    /// The "map_b" asset catalog image resource.
    static let mapB = DeveloperToolsSupport.ImageResource(name: "map_b", bundle: resourceBundle)

    /// The "map_s" asset catalog image resource.
    static let mapS = DeveloperToolsSupport.ImageResource(name: "map_s", bundle: resourceBundle)

    /// The "more" asset catalog image resource.
    static let more = DeveloperToolsSupport.ImageResource(name: "more", bundle: resourceBundle)

    /// The "one" asset catalog image resource.
    static let one = DeveloperToolsSupport.ImageResource(name: "one", bundle: resourceBundle)

    /// The "seven" asset catalog image resource.
    static let seven = DeveloperToolsSupport.ImageResource(name: "seven", bundle: resourceBundle)

    /// The "share" asset catalog image resource.
    static let share = DeveloperToolsSupport.ImageResource(name: "share", bundle: resourceBundle)

    /// The "six" asset catalog image resource.
    static let six = DeveloperToolsSupport.ImageResource(name: "six", bundle: resourceBundle)

    /// The "three" asset catalog image resource.
    static let three = DeveloperToolsSupport.ImageResource(name: "three", bundle: resourceBundle)

    /// The "three points" asset catalog image resource.
    static let threePoints = DeveloperToolsSupport.ImageResource(name: "three points", bundle: resourceBundle)

    /// The "two" asset catalog image resource.
    static let two = DeveloperToolsSupport.ImageResource(name: "two", bundle: resourceBundle)

    /// The "user" asset catalog image resource.
    static let user = DeveloperToolsSupport.ImageResource(name: "user", bundle: resourceBundle)

    /// The "user_s" asset catalog image resource.
    static let userS = DeveloperToolsSupport.ImageResource(name: "user_s", bundle: resourceBundle)

    /// The "user_ss" asset catalog image resource.
    static let userSs = DeveloperToolsSupport.ImageResource(name: "user_ss", bundle: resourceBundle)

    /// The "word" asset catalog image resource.
    static let word = DeveloperToolsSupport.ImageResource(name: "word", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "collect" asset catalog image.
    static var collect: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .collect)
#else
        .init()
#endif
    }

    /// The "color" asset catalog image.
    static var color: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .color)
#else
        .init()
#endif
    }

    /// The "comment" asset catalog image.
    static var comment: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .comment)
#else
        .init()
#endif
    }

    /// The "date" asset catalog image.
    static var date: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .date)
#else
        .init()
#endif
    }

    /// The "eight" asset catalog image.
    static var eight: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .eight)
#else
        .init()
#endif
    }

    /// The "five" asset catalog image.
    static var five: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .five)
#else
        .init()
#endif
    }

    /// The "four" asset catalog image.
    static var four: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .four)
#else
        .init()
#endif
    }

    /// The "heart" asset catalog image.
    static var heart: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heart)
#else
        .init()
#endif
    }

    /// The "map_b" asset catalog image.
    static var mapB: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mapB)
#else
        .init()
#endif
    }

    /// The "map_s" asset catalog image.
    static var mapS: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mapS)
#else
        .init()
#endif
    }

    /// The "more" asset catalog image.
    static var more: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .more)
#else
        .init()
#endif
    }

    /// The "one" asset catalog image.
    static var one: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .one)
#else
        .init()
#endif
    }

    /// The "seven" asset catalog image.
    static var seven: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .seven)
#else
        .init()
#endif
    }

    /// The "share" asset catalog image.
    static var share: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .share)
#else
        .init()
#endif
    }

    /// The "six" asset catalog image.
    static var six: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .six)
#else
        .init()
#endif
    }

    /// The "three" asset catalog image.
    static var three: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .three)
#else
        .init()
#endif
    }

    /// The "three points" asset catalog image.
    static var threePoints: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .threePoints)
#else
        .init()
#endif
    }

    /// The "two" asset catalog image.
    static var two: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .two)
#else
        .init()
#endif
    }

    /// The "user" asset catalog image.
    static var user: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .user)
#else
        .init()
#endif
    }

    /// The "user_s" asset catalog image.
    static var userS: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userS)
#else
        .init()
#endif
    }

    /// The "user_ss" asset catalog image.
    static var userSs: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userSs)
#else
        .init()
#endif
    }

    /// The "word" asset catalog image.
    static var word: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .word)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "collect" asset catalog image.
    static var collect: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .collect)
#else
        .init()
#endif
    }

    /// The "color" asset catalog image.
    static var color: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .color)
#else
        .init()
#endif
    }

    /// The "comment" asset catalog image.
    static var comment: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .comment)
#else
        .init()
#endif
    }

    /// The "date" asset catalog image.
    static var date: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .date)
#else
        .init()
#endif
    }

    /// The "eight" asset catalog image.
    static var eight: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .eight)
#else
        .init()
#endif
    }

    /// The "five" asset catalog image.
    static var five: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .five)
#else
        .init()
#endif
    }

    /// The "four" asset catalog image.
    static var four: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .four)
#else
        .init()
#endif
    }

    /// The "heart" asset catalog image.
    static var heart: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heart)
#else
        .init()
#endif
    }

    /// The "map_b" asset catalog image.
    static var mapB: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mapB)
#else
        .init()
#endif
    }

    /// The "map_s" asset catalog image.
    static var mapS: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .mapS)
#else
        .init()
#endif
    }

    /// The "more" asset catalog image.
    static var more: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .more)
#else
        .init()
#endif
    }

    /// The "one" asset catalog image.
    static var one: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .one)
#else
        .init()
#endif
    }

    /// The "seven" asset catalog image.
    static var seven: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .seven)
#else
        .init()
#endif
    }

    /// The "share" asset catalog image.
    static var share: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .share)
#else
        .init()
#endif
    }

    /// The "six" asset catalog image.
    static var six: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .six)
#else
        .init()
#endif
    }

    /// The "three" asset catalog image.
    static var three: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .three)
#else
        .init()
#endif
    }

    /// The "three points" asset catalog image.
    static var threePoints: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .threePoints)
#else
        .init()
#endif
    }

    /// The "two" asset catalog image.
    static var two: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .two)
#else
        .init()
#endif
    }

    /// The "user" asset catalog image.
    static var user: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .user)
#else
        .init()
#endif
    }

    /// The "user_s" asset catalog image.
    static var userS: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userS)
#else
        .init()
#endif
    }

    /// The "user_ss" asset catalog image.
    static var userSs: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userSs)
#else
        .init()
#endif
    }

    /// The "word" asset catalog image.
    static var word: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .word)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

