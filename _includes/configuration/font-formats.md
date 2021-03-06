## font_formats

This option lets you control the font families presented to the user in the fronts drop down list.

This option should contain a semicolon separated list of font titles and font families separated by `=`. The titles are the ones that get presented to the user in the fonts drop down list and the font family name is the string that gets inserted into the font face or `font-family` CSS style.

**Type:** `String`

**Default Value:** "Andale Mono=andale mono,times;"+
  "Arial=arial,helvetica,sans-serif;"+
  "Arial Black=arial black,avant garde;"+
  "Book Antiqua=book antiqua,palatino;"+
  "Comic Sans MS=comic sans ms,sans-serif;"+
  "Courier New=courier new,courier;"+
  "Georgia=georgia,palatino;"+
  "Helvetica=helvetica;"+
  "Impact=impact,chicago;"+
  "Symbol=symbol;"+
  "Tahoma=tahoma,arial,helvetica,sans-serif;"+
  "Terminal=terminal,monaco;"+
  "Times New Roman=times new roman,times;"+
  "Trebuchet MS=trebuchet ms,geneva;"+
  "Verdana=verdana,geneva;"+
  "Webdings=webdings;"+
  "Wingdings=wingdings,zapf dingbats"

##### Example

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  font_formats: "Arial=arial,helvetica,sans-serif;Courier New=courier new,courier,monospace;AkrutiKndPadmini=Akpdmi-n"
});
```
