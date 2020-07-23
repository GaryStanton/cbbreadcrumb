# CB Breadcrumb

Automatically generate breadcrumb data and HTML in your ColdBox application, using the Routing table.

## Installation
```js
box install cbbreadcrumb
```

## Usage
An instance of CB Breadcrumb is automatically added to each request and is available in the private request context.
You may display breadcrumb HTML in your layout with a single line of code: `#prc.cbbreadcrumb.getBreadcrumbHTML()#`  
The default HTML format uses Bootstrap 4 syntax, though you may override the function if necessary.

### Page names
The names for each breadcrumb node are pulled straight out of your routing table, so be sure to add a name to each route:
```
route(pattern="articles", name="Articles").withAction({ "GET" = "list" });
route(pattern="articles.new", name="Create a new article").withAction({ "GET" = "new"});
route(pattern="articles:ID").withAction({ "GET" = "show" });
```
If no name is specified, the event name is used instead.

### Placeholders
In some cases you may be using placeholders in your routes, such as `articles:ID` in the example above.
You can pass a struct into the `replacePlaceholders()` function to provide a node name for these placeholders.
```
prc.cbbreadcrumb.replacePlaceholders({ ID = prc.article.getTitle() }).getBreadcrumbHTML();
```

### Advanced options
The `getBreadcrumbHTML()` function accepts a few arguments for advanced configuration.
| Argument | Type   | Description                      |
| -------- | ------ | -------------------------------- |
| nodeName | string | When set, override the current node's name in the breadcrumb. |
| placeholders | struct | If your routing table includes placeholders, you may pass a struct to replace these values in your breadcrumb. For instance, you may want to replace a record ID token with a name: `{id = 'Your record name'}` |
| includeHome | boolean | When true, include a 'home' node. |
| breadcrumbArray | array | You may optionally pass an entire breadcrumb array instead of using the routing table, e.g. `[{name='Home', link='/'}, {name='Latest news', link="/blog"}]` |

Alternatively, you may instead call the corresponding functions directly on the `cbbreadcrumb` object:  
`setThisNodeName()`  
`replacePlaceholders()`  
`addHomeNode()`  
`setBreadcrumbNodes()`  


## Author
Written by Gary Stanton.  
https://garystanton.co.uk
