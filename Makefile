.PHONY: ios android run clean

# iOSビルドとオープン
ios:
	flutter build ipa
	open build/ios/ipa

# Androidビルドとオープン
android:
	flutter build appbundle --release
	open build/app/outputs/bundle/release/

# アプリを実行
run:
	flutter run

# クリーン
clean:
	flutter clean

ci:
	flutter analyze
	flutter test