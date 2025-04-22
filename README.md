This pull request adds several files and functionalities to your app, summarized as follows:

1. **`androidx-artifact-mapping.csv`**:
   - This file contains a mapping of old Android support library dependencies to their equivalent AndroidX dependencies. This may help with migration from legacy Android libraries to the newer AndroidX ones, ensuring compatibility and modernization of the project's dependencies.

2. **Various `.zip` Files**:
   - These files, such as `neura_animated_checkin_avatarshift.zip` and `neura_personality_upgrade.zip`, are added but do not show any diffs. They might be assets or bundled resources required for your app's functionality (e.g., animations, data, or pre-built libraries).

3. **`pubspec.yaml`**:
   - This file defines the app's dependencies, environment, and configuration. Key points include:
     - **App Details**: The app is named `neuro_companion` and described as a lightweight mental wellness assistant.
     - **Dependencies Added**:
       - Core Flutter and Firebase libraries (e.g., `firebase_core`, `firebase_crashlytics`) for app functionality and crash reporting.
       - Libraries such as `shared_preferences`, `path_provider`, and `file_picker` for managing user data and file access.
       - Azure SDKs (`azure_storage_blobs`, `azure_identity`) for integration with Azure cloud storage.
       - Other utilities like `speech_to_text`, `shimmer`, and `connectivity_plus` for features like voice input, UI effects, and connectivity management.
     - **Dev Dependencies**: Includes `flutter_test` for testing purposes.

### Impact on Your App:
- **Modernization and Compatibility**: The AndroidX mapping file streamlines the migration to AndroidX libraries, ensuring better compatibility and support for newer Android versions.
- **Enhanced Features**: Dependencies like `speech_to_text` and Firebase integrations enable advanced features such as voice input and crash analytics.
- **Cloud Integration**: Azure SDKs open the door for cloud-based storage and identity management.
- **UI and Usability Enhancements**: Libraries like `shimmer` and `shared_preferences` improve the user experience and app functionality.

If you have any specific questions about any of the changes, feel free to ask!
