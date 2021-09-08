Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "LibMobileCoin"
  s.version      = "1.1.1"
  s.summary      = "A library for communicating with MobileCoin network"

  s.author       = "MobileCoin"
  s.homepage     = "https://www.mobilecoin.com/"

  s.license      = { :type => "GPLv3" }

  s.source       = { :git => "https://github.com/mobilecoinofficial/libmobilecoin-ios-artifacts.git", :tag => "v#{s.version}" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "10.0"


  # ――― Sources -――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files = [
    "Artifacts/include/*.h",
    "Sources/Generated/Proto/*.{grpc,pb}.swift",
  ]

  s.preserve_paths = [
    'Artifacts/**/libmobilecoin.a',
    'Artifacts/**/libmobilecoin_stripped.a'
  ]

  # ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.dependency "gRPC-Swift", "~> 1.0"
  s.dependency "SwiftProtobuf", "~> 1.5"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.swift_version = "5.2"

  s.pod_target_xcconfig = {
    # Rust bitcode is not verified to be compatible with Apple Xcode's LLVM bitcode,
    # so this is disabled to be on the safe side.
    "ENABLE_BITCODE" => "NO",
    # HACK: this forces the libmobilecoin.a static archive to be included when the
    # linker is linking LibMobileCoin as a shared framework
    "OTHER_LDFLAGS" => "-u _mc_string_free",
    # Mac Catalyst is not supported since this library includes a vendored binary
    # that only includes support for iOS archictures.
    "SUPPORTS_MACCATALYST" => "NO",
    # The vendored binary doesn't include support for 32-bit architectures or arm64
    # for iphonesimulator. This must be manually configured to avoid Xcode's default
    # setting of building 32-bit and Xcode 12's default setting of including the
    # arm64 simulator. Note: 32-bit is officially dropped in iOS 11
    "VALID_ARCHS[sdk=iphoneos*]" => "arm64",
    "VALID_ARCHS[sdk=iphonesimulator*]" => "arm64 x86_64",


    "HEADER_SEARCH_PATHS": "$(PODS_TARGET_SRCROOT)/Artifacts/include",
    "SWIFT_INCLUDE_PATHS": "$(HEADER_SEARCH_PATHS)",

    "LIBMOBILECOIN_LIB_IF_NEEDED": "$(PODS_TARGET_SRCROOT)/Artifacts/$(CARGO_BUILD_TARGET)/libmobilecoin.a",
    "OTHER_LDFLAGS": "-u _mc_string_free $(LIBMOBILECOIN_LIB_IF_NEEDED)",

    # Device & Simulator
    "CARGO_BUILD_TARGET[sdk=iphonesimulator*][arch=arm64]": "aarch64-apple-ios-sim",
    "CARGO_BUILD_TARGET[sdk=iphonesimulator*][arch=*]": "x86_64-apple-ios",
    "CARGO_BUILD_TARGET[sdk=iphoneos*]": "aarch64-apple-ios",

    # Mac Catalyst
    "CARGO_BUILD_TARGET_MAC_CATALYST_ARM_": "aarch64-apple-darwin",
    "CARGO_BUILD_TARGET_MAC_CATALYST_ARM_YES": "aarch64-apple-ios-macabi",
    "CARGO_BUILD_TARGET[sdk=macosx*][arch=arm64]": "$(CARGO_BUILD_TARGET_MAC_CATALYST_ARM_$(IS_MACCATALYST))",
    "CARGO_BUILD_TARGET_MAC_CATALYST_X86_": "x86_64-apple-darwin",
    "CARGO_BUILD_TARGET_MAC_CATALYST_X86_YES": "x86_64-apple-ios-macabi",
    "CARGO_BUILD_TARGET[sdk=macosx*][arch=*]": "$(CARGO_BUILD_TARGET_MAC_CATALYST_X86_$(IS_MACCATALYST))",

    "ARCHS[sdk=iphonesimulator*]": "arm64 x86_64",
    "ARCHS[sdk=iphoneos*]": "arm64",
  }

  # `user_target_xcconfig` should only be set when the setting needs to propogate to
  # all targets that depend on this library.
  s.user_target_xcconfig = {
    "ENABLE_BITCODE" => "NO",
    "SUPPORTS_MACCATALYST" => "YES",
    "VALID_ARCHS[sdk=iphoneos*]" => "arm64",
    "VALID_ARCHS[sdk=iphonesimulator*]" => "arm64"
  }
end
