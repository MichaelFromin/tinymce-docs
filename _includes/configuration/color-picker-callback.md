## color_picker_callback

This option enables you to provide your own color picker.

**Type:** `JavaScript Function`

##### Example

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  color_picker_callback: function(callback, value) {
    callback('#FF00FF');
  }
});
```
