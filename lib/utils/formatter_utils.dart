class FormatterController {
  //We can do it with regex
  formatNumberWithSpaces(String number) {
    var parts = number.split(".");
    String formatted = "";
    parts[0] = parts[0].split('').reversed.join();
    for (int i = 0; i < parts[0].length; i++) {
      formatted += parts[0][i];
      if (i % 3 == 2) formatted += " ";
    }
    parts[0] = formatted.split('').reversed.join();
    return parts.join(".").trim();
  }
}
