## valid_classes

This option enables you specify the available styles for each element. This means you can force ordering and only specific styles will be valid within style attribute values. Specify the element name, then it's styles or `*` for all elements.

**Type:** `Object`

##### Example

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  valid_styles: {
    "*": "border,font-size",
    "div": "width,height"
  }
});
```
