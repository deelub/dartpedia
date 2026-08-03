import 'dart:io';
import 'package:http/http.dart' as http;

const version = '0.0.1';

void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.first == 'help') {
    printUsuage();
  } else if (arguments.first == 'version') {
    print('Dartpedia CLI version $version');
  } else if (arguments.first == 'search') {
    final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
    searchWikipedia(inputArgs);
  } else {
    printUsuage();
  }
}

Future<void> searchWikipedia(List<String>? arguments) async {
  final String articleTitle;

  if (arguments == null || arguments.isEmpty) {
    print('Please provide an article title');

    final inputFromStdin = stdin.readLineSync();

    if (inputFromStdin == null || inputFromStdin.isEmpty) {
      print('No article title provided. Exiting');
      return; //Handles no inplut to return nothing
    }
    articleTitle = inputFromStdin;
  } else {
    articleTitle = arguments.join('');
  }
  print('Looking up articles about "$articleTitle". Please wait.');

  var articleContent = await getWikipediaArticle(
    articleTitle,
  ); //Calling teh APi and waiting for the outputted results
  print(articleContent);
}

void printUsuage() {
  print(
    "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
  );
}

Future<String> getWikipediaArticle(String articleTitle) async {
  final url = Uri.https(
    'en.wikipedia.org',
    '/api/rest_v1/page/summary/$articleTitle',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  }
  return 'Error: Failed to fetch article "$articleTitle". Status codde: ${response.statusCode}';
}
