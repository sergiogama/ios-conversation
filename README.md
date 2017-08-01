# iOS Conversation

## News
An Android version is coming up soon! Check it out [here!](https://github.ibm.com/mbigelli/watson-chat-android)

## Summary

This app uses native functionality and Watson services to create a voice-activated chatbot. The default configuration uses:

- iOS native speech recognition (en-US)
- Watson Conversation (must be configured before use)
- Siri's voice (en-US)

You may opt to replace each of these API's with Watson services, by configuring each of them in the Settings screen. Additionally, the app supports custom orchestrator and voice synthesis URLs, but expects the same interface offered by Watson services. Refer to the official documentation for more details:

- [Speech-to-Text Documentation](https://www.ibm.com/watson/developercloud/speech-to-text.html)
- [Conversation Documentation](https://www.ibm.com/watson/developercloud/conversation.html)
- [Text-to-Speech Documentation](https://www.ibm.com/watson/developercloud/text-to-speech.html)

## Running the project

Clone the repository and install Carthage dependencies.

    $ git clone git@github.ibm.com:mbigelli/ios-conversation.git
    $ carthage bootstrap
