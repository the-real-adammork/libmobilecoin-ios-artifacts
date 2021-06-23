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

  # s.vendored_library = "Artifacts/libmobilecoin.a"

  s.preserve_paths = [
    'LibMobileCoin/Artifacts/target/*/release/libmobilecoin_stripped.a'
  ]


  # ――― Dependencies ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.dependency "gRPC-Swift", "~> 1.0.0"
  s.dependency "SwiftProtobuf", "~> 1.5"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.swift_version = "5.2"

  s.pod_target_xcconfig = {
    # Rust bitcode is not verified to be compatible with Apple Xcode's LLVM bitcode,
    # so this is disabled to be on the safe side.
    "ENABLE_BITCODE" => "NO",
    # HACK: this forces the libmobilecoin.a static archive to be included when the
    # linker is linking LibMobileCoin as a shared framework
    "OTHER_LDFLAGS" => "-u _mc_string_free $(LIBSIGNAL_FFI_LIB_IF_NEEDED)",
    # Mac Catalyst is not supported since this library includes a vendored binary
    # that only includes support for iOS archictures.
    "SUPPORTS_MACCATALYST" => "NO",
    # The vendored binary doesn't include support for 32-bit architectures or arm64
    # for iphonesimulator. This must be manually configured to avoid Xcode's default
    # setting of building 32-bit and Xcode 12's default setting of including the
    # arm64 simulator. Note: 32-bit is officially dropped in iOS 11
    "VALID_ARCHS[sdk=iphoneos*]" => "arm64",
    "VALID_ARCHS[sdk=iphonesimulator*]" => "x86_64",

    # Make sure we link the static library, not a dynamic one.
    # Use an extra level of indirection because CocoaPods messes with OTHER_LDFLAGS too.
    'LIBSIGNAL_FFI_LIB_IF_NEEDED' => '$(PODS_TARGET_SRCROOT)/Artifacts/target/$(CARGO_BUILD_TARGET)/release/libmobilecoin_stripped.a',
    # 'OTHER_LDFLAGS' => '$(LIBSIGNAL_FFI_LIB_IF_NEEDED)',

    # 'CARGO_BUILD_TARGET[sdk=iphonesimulator*][arch=arm64]' => 'aarch64-apple-ios-sim',
    # 'CARGO_BUILD_TARGET[sdk=iphonesimulator*][arch=*]' => 'x86_64-apple-ios',
    'CARGO_BUILD_TARGET[sdk=iphonesimulator*]' => 'x86_64-apple-ios',
    'CARGO_BUILD_TARGET[sdk=iphoneos*]' => 'aarch64-apple-ios',
    # Presently, there's no special SDK or arch for maccatalyst,
    # so we need to hackily use the "IS_MACCATALYST" build flag
    # to set the appropriate cargo target
    # 'CARGO_BUILD_TARGET_MAC_CATALYST_ARM_# ' => # 'aarch64-apple-darwin# ',
    # 'CARGO_BUILD_TARGET_MAC_CATALYST_ARM_YES# ' => # 'aarch64-apple-ios-macabi# ',
    # 'CARGO_BUILD_TARGET[sdk=macosx*][arch=arm64]# ' => # '$(CARGO_BUILD_TARGET_MAC_CATALYST_ARM_$(IS_MACCATALYST))# ',
    # 'CARGO_BUILD_TARGET_MAC_CATALYST_X86_# ' => # 'x86_64-apple-darwin# ',
    # 'CARGO_BUILD_TARGET_MAC_CATALYST_X86_YES# ' => # 'x86_64-apple-ios-macabi# ',
    # 'CARGO_BUILD_TARGET[sdk=macosx*][arch=*]# ' => # '$(CARGO_BUILD_TARGET_MAC_CATALYST_X86_$(IS_MACCATALYST))# ',
  }

  # `user_target_xcconfig` should only be set when the setting needs to propogate to
  # all targets that depend on this library.
  s.user_target_xcconfig = {
    "ENABLE_BITCODE" => "NO",
    "SUPPORTS_MACCATALYST" => "NO",
    "VALID_ARCHS[sdk=iphoneos*]" => "arm64",
    "VALID_ARCHS[sdk=iphonesimulator*]" => "x86_64",
  }

end
