## allow_script_urls

Enabling this option will allow `javascript: urls` in links and images. This is disabled by default for security purposes so scripts can't be injected by pasting contents from one site to another. If you still wan't to enable this option just set it to `true`.

**Type:** `Boolean`

**Default Value:** `false`

**Possible Values:** `true`, `false`

##### Example

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  allow_script_urls: true
});
```
