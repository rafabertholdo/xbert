# xbert
docker to build SwiftPM targeting iOS

## Usage

Download XCode from apple and run

### x86_64

```
nerdctl.lima run --platform linux/amd64 -v "$(pwd):/workspace" -w /workspace xbert -c "swift build --swift-sdk arm64-apple-ios"
```

### arm

```
nerdctl.lima run -v "$(pwd):/workspace" -w /workspace xbert -c "mkdir /src && cp -r . /src && cd /src && swift build --swift-sdk arm64-apple-ios"
```
