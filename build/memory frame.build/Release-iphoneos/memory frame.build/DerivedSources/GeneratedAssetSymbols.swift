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

    /// The "color" asset catalog image resource.
    static let color = DeveloperToolsSupport.ImageResource(name: "color", bundle: resourceBundle)

    /// The "date" asset catalog image resource.
    static let date = DeveloperToolsSupport.ImageResource(name: "date", bundle: resourceBundle)

    /// The "map_b" asset catalog image resource.
    static let mapB = DeveloperToolsSupport.ImageResource(name: "map_b", bundle: resourceBundle)

    /// The "map_s" asset catalog image resource.
    static let mapS = DeveloperToolsSupport.ImageResource(name: "map_s", bundle: resourceBundle)

    /// The "more" asset catalog image resource.
    static let more = DeveloperToolsSupport.ImageResource(name: "more", bundle: resourceBundle)

    /// The "user" asset catalog image resource.
    static let user = DeveloperToolsSupport.ImageResource(name: "user", bundle: resourceBundle)

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

    /// The "color" asset catalog image.
    static var color: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .color)
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

    /// The "user" asset catalog image.
    static var user: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .user)
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

    /// The "color" asset catalog image.
    static var color: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .color)
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

    /// The "user" asset catalog image.
    static var user: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .user)
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

