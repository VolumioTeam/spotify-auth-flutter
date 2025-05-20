#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint spotify_auth.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'spotify_auth'
  s.version          = '0.0.1'
  s.summary          = 'Spotify Authentication Plugin for Flutter'
  s.description      = <<-DESC
Spotify Authentication Plugin for Flutter that uses platform specific shortcuts.
                       DESC
  s.homepage         = 'https://github.com/VolumioTeam/spotify-auth-flutter'
  s.license          = { :file => '../../LICENSE', :type => 'Apache 2.0' }
  s.author           = { 'devgianlu' => 'gianluca@volumio.org' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.prepare_command = './prepare.sh'
  s.vendored_frameworks = 'ios-sdk/SpotifyiOS.xcframework'
  s.preserve_paths = 'ios-sdk/SpotifyiOS.xcframework'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'spotify_auth_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
