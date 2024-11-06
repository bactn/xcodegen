# Variables
BUNDLER_VERSION := 2.2.25

# Initialization
init:
	sh set_environment/environment.sh ${BUNDLER_VERSION}
	rbenv exec bundle _${BUNDLER_VERSION}_ install
	sh mint.sh bootstrap
	sh mint.sh run xcodegen
	#rbenv exec bundle exec pod install --repo-update

# Generate xcodeproj
xcode:
	sh mint.sh run xcodegen
#	rbenv exec bundle exec pod install --repo-update

#pod:
#	rbenv exec bundle exec pod install --repo-update

swiftgen:
	sh mint.sh run swiftgen

#license:
	#sh generate_license.sh
