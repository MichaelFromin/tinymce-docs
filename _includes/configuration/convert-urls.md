## convert_urls

This option enables you to control whether TinyMCE is to be clever and restore URLs to their original values. URLs are automatically converted (messed up) by default because the browser's built-in logic works this way. There is no way to get the real URL unless you store it away. If you set this option to `false` it will try to keep these URLs intact. This option is set to `true` by default, which means URLs will be forced to be either absolute or relative depending on the state of [relative_urls](#relative_urls).

**Type:** `Boolean`

**Default Value:** `true`

**Possible Values:** `true`, `false`

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  convert_urls: false
});
```
