# ML Kit text recognition ships optional per-script recognizers (Chinese,
# Devanagari, Japanese, Korean) that are only referenced via reflection.
# The app only uses the default (Latin) recognizer, so these classes are
# absent from the final APK; R8 just needs to stop treating that as an error.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
