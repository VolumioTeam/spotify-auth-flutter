# spotify-auth-flutter

A library to authenticate with Spotify using platform specific shortcuts.

## Getting Started

### Android

All the dependencies are already bundled in the library. You just need to add the following to your
`build.gradle` file inside `android.defaultConfig`:

```groovy
manifestPlaceholders += [redirectSchemeName: "corrd", redirectHostName: "corrd.io"]
```

### iOS

The Spotify SDK dependency on iOS must be added manually. You can do so from Xcode by adding a new
framework (e.g. with https://github.com/spotify/ios-sdk) and setting its target to `spotify_auth`.
Additionally, you need to add the following to your `Info.plist` file:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>spotify</string>
</array>
```

## Usage

The library exposes only two methods on the `SpotifyAuth` class.

### `canAuthenticateUsingSpotifyApp()`

This method returns whether the Spotify app is installed and can be used to authenticate.

### `authenticate()`

This method performs the actual authentication using the Spotify app. If this is called without the
app installed, it will throw an error. It accepts a Spotify client id, a list of scopes and a
redirect URI. The redirect URI must be configured to be handled by the app, but can be ignored by
Flutter as it is caught in the native side. It returns a `SpotifyAuthResult` object that contains
the either an OAuth2 code or a refresh token, depending on the platform it is called on.