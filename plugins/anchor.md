---
layout: default
title: Anchor Plugin
title_nav: Anchor
description: Insert anchors (sometimes referred to as a bookmarks).
controls: toolbar button, menu item
---

This plugin adds an anchor/bookmark button to the toolbar that inserts an anchor at the editor's cursor insertion point. It also adds the menu item `anchor` under the `Insert` menu.

The HTML inserted takes the form of an anchor id, for example, `<p><a id="start"></a>Hello, World!</p>`. In this example the user creates the id's value "start" via a dialog input.

**Type:** `String`


##### Anchor plugin example

```js
tinymce.init({
  selector: "textarea",  // change this value according to your html
  plugins: "anchor",
  toolbar: "anchor",
  menubar: "insert"
});
```
