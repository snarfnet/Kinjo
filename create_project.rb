require 'xcodeproj'

PROJECT_NAME = 'Kinjo'
BUNDLE_ID = 'com.tokyonasu.kinjo'
TEAM_ID = '83VGKGSQUH'

project_path = File.expand_path("#{PROJECT_NAME}.xcodeproj", __dir__)
project = Xcodeproj::Project.new(project_path)
target = project.new_target(:application, PROJECT_NAME, :ios, '16.0')

target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = BUNDLE_ID
  config.build_settings['DEVELOPMENT_TEAM'] = TEAM_ID
  config.build_settings['SWIFT_VERSION'] = '5.9'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  config.build_settings['INFOPLIST_FILE'] = "#{PROJECT_NAME}/Info.plist"
  config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = 'AppIcon'
  config.build_settings['ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME'] = 'AccentColor'
end

main_group = project.main_group
app_group = main_group.new_group(PROJECT_NAME, PROJECT_NAME)
models_group = app_group.new_group('Models', 'Models')
services_group = app_group.new_group('Services', 'Services')
views_group = app_group.new_group('Views', 'Views')
components_group = views_group.new_group('Components', 'Components')

def add_sources(group, target, names)
  names.each do |name|
    ref = group.new_file(name)
    target.add_file_references([ref])
  end
end

add_sources(app_group, target, [
  'KinjoApp.swift',
  'ContentView.swift',
  'KinjoTheme.swift'
])

add_sources(models_group, target, ['Models.swift'])

add_sources(services_group, target, [
  'APIService.swift',
  'LocationService.swift',
  'AdMobConfig.swift'
])

add_sources(views_group, target, ['HomeView.swift'])

add_sources(components_group, target, [
  'AirQualityCard.swift',
  'BannerAdView.swift',
  'BikeShareCard.swift',
  'EarthquakeCard.swift',
  'EventCard.swift',
  'FengshuiCard.swift',
  'KinjoHeroHeader.swift',
  'NewsCard.swift',
  'OnThisDayCard.swift',
  'SakuraCard.swift',
  'StoreCard.swift',
  'SunriseCard.swift',
  'TodayBanner.swift',
  'TrainCard.swift',
  'UVCard.swift',
  'WeatherCard.swift'
])

assets_ref = app_group.new_file('Assets.xcassets')
target.add_file_references([assets_ref])
privacy_ref = app_group.new_file('PrivacyInfo.xcprivacy')
target.add_resources([privacy_ref])
app_group.new_file('Info.plist')

project.save
puts "Created #{project_path}"
