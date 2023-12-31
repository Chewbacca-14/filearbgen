import 'dart:io';

void genEn(String inputFilePath, String languageCode) {
  // Get the current working directory (project directory)
  String currentPath = Directory.current.path;
  // Create a file name based on the language code
  String fileName = 'app_$languageCode.arb';
  // Construct the full file path for the file gen
  String filePath = '$currentPath\\lib/$fileName';

  try {
    // Read the contents of the input translation file
    var file = File(inputFilePath);
    var contents = file.readAsStringSync();
    // Split the contents into blocks based on line breaks
    var blocks = contents.split('\n');
    // Create a new output file and open a write stream
    var outputFile = File(filePath);
    var outputSink = outputFile.openWrite();
// Write the initial opening brace for the JSON object
    outputSink.write('{\n');
// Process each block in the translation file
    for (var block in blocks) {
      // Check if the block is not empty
      if (block.trim().isNotEmpty) {
        // Split the block into lines based on semicolons
        var lines = block.split(';');
        // Check if the line has the expected number of values (3)
        if (lines.length == 3) {
          // Extract key, Other language translation, and English translation
          var key = lines[0].trim().replaceAll('"', '');
          var otherLang = lines[1].trim().replaceAll('"', '');
          var english = lines[2].trim().replaceAll('"', '');

          // Write the English translation to the output file (type en)
          outputSink.write(' "$key": "$english",\n');
          outputSink.write(' "@$key": {\n');
          outputSink.write('   "description": "$otherLang"\n');
          outputSink.write(' },\n');
        } else {
          // If the block does not have the expected format, print an error
          outputSink.write('Incorrect translation file format: $block\n');
        }
      }
    }
    // Write the closing brace for the JSON object
    outputSink.write('}\n');
    // Close the output stream
    outputSink.close();
    // Create an empty file at the specified path
    File filefile = File(filePath);
    filefile.createSync();
    // Print a success message
    print('File generated successfully: $filePath');
  } catch (e) {
    // Handle any errors that occur during file reading/writing
    print('Error reading/writing file: $e');
  }
}
