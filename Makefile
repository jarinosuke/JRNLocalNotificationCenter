test:
	xcodebuild clean test \
	-sdk iphonesimulator \
	-project DemoApp.xcodeproj \
	-scheme DemoApp \
	-configuration Debug \
	-destination "name=iPhone Retina (4-inch),OS=7.0" \
	OBJROOT=build \
