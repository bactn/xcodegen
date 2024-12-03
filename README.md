# iFast

## How to setup enviroment?
- cd root path
```bash 
bash set_environment/environment.sh
```

## Develop environment
- Xcode13.3.1
- Swfit5.6

### Project initializing
```sh
$ make init
```

## Developement Tools
- XcodeGen
- SwiftGen
- SwiftLint
- fastlane

### Xcode project file
Create Xcode file
```sh
$ make xcode
```

### make init will excute these commands
- Homebrew
- rbenv
- Ruby (`rbenv install`)
- Bundler (2.2.25)  
- Mint  
  Mint will management these libs
    - XcodeGen
    - SwiftLint
    - SwiftGen
- `.git/hooks/post-checkout` will be created (set_environment/post-checkout will copy)

## Architecture
Clean Architecture


### Mini App
- install Vue.js or any js framework:
    - import .zip file into project and unzip by VTBMiniAppSDK.unzipMiniApp
    - vue create mini-app

