## force_hex_style_colors

This option enables you to control TinyMCE to force the color format to use hexadecimal instead of rgb strings. For example, it converts `color: rgb(255, 255, 0)` to `#FFFF00`. This option is set to `true` by default since IE and Firefox would otherwise differ in this behavior.

**Type:** `Boolean`

**Default Value:** `true`

**Possible Values:** `true`, `false`

##### Example

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  force_hex_style_colors : false
});
```
