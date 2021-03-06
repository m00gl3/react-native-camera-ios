# React Native Camera iOS

*Native iOS Camera ImagePicker w/ cameraOverlayView support.*

## Getting Started

Install React Native Camera iOS:

```bash
$ yarn add react-native-camera-ios
```

Then link it to your project:

```bash
$ react-native link
```

## Usage

The `RNCamera` component that is exported by this module is based on
[`<Modal/>`][modal] from the React Native team.

```js
import React from 'react';
import {
    View,
    Button,
    StyleSheet
} from 'react-native';
import RNCamera from 'react-native-camera-ios';

const styles = StyleSheet.create({
    overlayRight: {
        position: 'absolute',
        right: 0,
        top: 0,
        bottom: 0,
        width: 80,
        alignItems: 'center'
    }
});
class CameraModal extends React.Component {
    onCapture({ image }) {
        // Fields available:
        // `image.path`, `image.width`, `image.height`

        this.props.onCapture(image.path);
    }
    render() {
        return (
            <RNCamera
                ref={(r) => this.camera = r}
                {...this.props}
                onCapture={(event) => this.onCapture(event)}
            >
                <View
                    style={styles.overlayRight}
                >
                    <Button
                        onPress={() => this.camera.capture()}
                        color="white"
                        title="Capture"
                    />
                </View>
            </RNCamera>
        );
    }
}
```

### Static functions

#### RNCamera.checkFlashAvailable(callback, cameraDevice = 'rear')

This function asks the system whether the `cameraDevice` supports a photo flash.
If the flash is available, it can be set as the `cameraFlashMode` prop. The
`cameraDevice` can be either `rear` or `front`. The callback will be called
with the structure below:

```js
(err: Error, isFlashAvailable: Boolean) => {}
```

#### RNCamera.resizeImage(imagePath, outputPath, options): Promise

This function resizes an image from disk (generally captured by the camera),
and writes it back to disk in the same or a new location. The path's must be
URL-style paths (i.e. `file:///user/`), and returns a Promise that resolves
an empty value.

```js
(imagePath: String, outputPath: String, options: {
    width: Number,
    height: Number,
    quality: Number // 0.00 - 1.00
}) => Promise<ImageReadError, null>
```

### Functions

#### capture()

This function causes the camera to begin taking a photo (i.e. activating flash,
adjusting exposure), and will later call the `onCapture()` event with the new
image information on disk.

This function should not be called again until the `onCapture()` callback has
been triggered.

### Props

#### visible: Boolean

Whether the modal should be visible on the screen. Defaults to `false`.

#### animationType: String

The animation style for opening the camera modal. Can be `none`, `slide`, or
`fade`. Defaults to `slide`.

#### cameraDevice: String

Which side of the device should be used for the current camera. Can be `front`
or `rear`. Defaults to `rear`.

#### cameraFlashMode: String

Whether the camera should activate when photos are being taken. Can be `off`,
`auto` or `on`. Defaults to `off`. This property will do nothing if flash is
not available on the current `cameraDevice`.

#### onCapture(event): Function

Event function when the camera button or `capture()` function has been
triggered, and the file has been completely written to disk. This function will
be called with the event structure below:

```js
{
    image: {
        path: String,
        width: Number,
        height: Number
    }
}
```

#### onCancel(): Function

Event function when the Cancel button has been pressed on the default iOS camera
screen. When children views are defined, this function cannot be called because
the system replaces the standard view (including the Cancel button) with custom
views.

## Running the Example App

You can run an example project for `react-native-camera-ios` to see how this
project works by launching the `examples/ios/RNCameraExamples.xcodeproj` file.

In Xcode 10, you may see a build failure the first time you build. This is because
of React Native's [lack of support][xcode-build-system] for the new Xcode build
system. After the first build, Xcode will have ran the `postinstall` script of
`react-native`, which installs and configures the `third-party` modules, and
therefore allows a successful Xcode build with the new build system.

## Notes

- This module is currently in initial stages of development, and it **not
recommended** for large-scale use
- This module is currently only tested on iPad devices and the iPad Simulator

## License

[MIT][license]


[xcode-build-system]: https://github.com/facebook/react-native/issues/19573
[modal]: http://facebook.github.io/react-native/docs/modal.html
[license]: https://github.com/houserater/react-native-camera-ios/blob/master/LICENSE
