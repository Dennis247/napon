import 'package:flutter_test/flutter_test.dart';
import 'package:napon/core/model/autosugesstion.dart';

List<AutoSuggestion> mockAutoSugesstions = [
  AutoSuggestion(placeId: "001", mainText: "yaba", secondaryText: "yaba area"),
  AutoSuggestion(
      placeId: "002", mainText: "mushin", secondaryText: "mushin area"),
  AutoSuggestion(
      placeId: "003", mainText: "oshodi", secondaryText: "Oshodi area"),
  AutoSuggestion(
      placeId: "004", mainText: "ogudu", secondaryText: "ogudu area"),
  AutoSuggestion(
      placeId: "005", mainText: "Adedoja", secondaryText: "mushin area")
];

void main() {
  List<String> suggestions = [];
  for (var element in mockAutoSugesstions) {
    suggestions.add(element.mainText);
  }
  group("get location name for from google auto-suggestion", () {
    test("result should contain yaba", () async {
      expect(suggestions.contains('yaba'), true);
    });
  });
}
