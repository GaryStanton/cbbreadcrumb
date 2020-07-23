/**
* The breadcrumb object
*/
component accessors="true" {

	// Properties
	property name="context" 	inject="coldbox:requestContext";
	property name="router" 		inject="coldbox:router";
	property name="route";
	property name="breadcrumbNodes";


	/**
	 * Constructor
	 */
	CBBreadcrumb function init(){
		return this;
	}

	/**
	* On DI Complete load default route
	*/
	public function onDIComplete(){
		setRoute(context.getCurrentRoute());
		setBreadcrumbNodes(getBreadcrumbArray());
	}


	/**
	* Return an array of matching routes representing the path of the current route
	*/
	array function getRouteArray(){
		var path = '';
		var returnArray = [];

		// Get all routes
		Local.routes = router.getRoutes();

		// Covert URL route to array
		Local.routeArray = ListToArray(Replace(getRoute(), '.', '/', 'ALL'), '/');

		// Loop through array and generate breadcrumb
		for (Local.thisNode in Local.routeArray) {
			path &= Local.thisNode & '/';
			// Match the route
			Local.thisRoute = Local.routes.filter(function(item){
				return (arguments.item.pattern == path);
			});

			if(Local.thisRoute.len()){
				returnArray.append(Local.thisRoute[1]);
			}
		}

		return returnArray;
	}


	/**
	 * Add a home node to the breadcrumb
	 */
	function addHomeNode(
			name = 'Home'
		,	link = context.buildLink('/')
	){
		if (breadcrumbnodes.len() == 0 || breadcrumbnodes[1].name != Arguments.name) {
			breadcrumbnodes.prepend({
				name 	= 'Home',
				link 	= ''
			});
		}

		return this;
	}


	/**
	 * Set the name for the current node
	 * @nodeName The name of the current node
	 */
	function setThisNodeName(required string nodeName){
		breadcrumbNodes[breadcrumbNodes.len()].name = nodeName;

		return this;
	}


	/**
	 * If your routing table includes placeholders, you may pass a struct to replace these values in your breadcrumb. For instance, you may want to replace a record ID token with a name, {id = 'Your record name'}
	 * @placeholders The struct containing placeholder names and values
	 */
	function replacePlaceholders(required struct placeholders){
		breadcrumbNodes.each(function(thisnode, index) {
			if (left(thisNode.name, 1) == ':') {
				breadcrumbNodes[index].name = structKeyExists(placeholders, ListLast(thisNode.name, ':')) ? placeholders[ListLast(thisNode.name, ':')] : thisNode.name;
			}
		});

		return this;
	}


	/**
	 * Return an array of breadcrumb links
	 */
	array function getBreadcrumbArray() {
		var breadcrumbArray = [];
		getRouteArray().each(function(thisNode, index) {
			breadcrumbArray.append({
				name 	= Len(thisNode.name) ? thisNode.name : getToken(thisNode.pattern, index, '/'), // Use pattern node if no name available
				link 	= Replace(ArrayToList(ListToArray(thisNode.pattern, '/'), '.'), '.:', ':', 'ALL') // Convert from / to . whilst also removing trailing slash
			});
		});

		return breadcrumbArray;
	}


	/**
	 * Return breadcrumb HTML
	 * Defaults to Bootstrap 4 syntax. To change the HTML, override this function, or build your own using the getBreadcrumbNodes function
	 * All parameters are optional and may be set on the object directly instead. They are provided here for convenience.
	 * @nodeName - When set, override the current node's name in the breadcrumb.
	 * @placeholders - If your routing table includes placeholders, you may pass a struct to replace these values in your breadcrumb. For instance, you may want to replace a record ID token with a name, {id = 'Your record name'}
	 * @includeHome - When true, include a 'home' node.
	 * @breadcrumbArray - You may optionally pass an entire breadcrumb array instead of using the routing table. [{name='Home', link='/'}, {name='Latest news', link="/blog"}]
	 */
	function getBreadcrumbHTML(
			string nodeName
		,	struct placeholders
		, 	boolean includeHome = true
		,	array breadcrumbArray
	){
		if (StructKeyExists(Arguments, 'nodeName')) {
			setThisNodeName(Arguments.nodeName);
		}

		if (StructKeyExists(Arguments, 'placeholders')) {
			replacePlaceholders(Arguments.placeholders);
		}

		if (Arguments.includeHome) {
			addHomeNode();
		}

		if (StructKeyExists(Arguments, 'breadcrumbArray')) {
			setBreadcrumbNodes(Arguments.breadcrumbArray);
		}

		var breadcrumbHTML = '';
		savecontent variable="breadcrumbHTML" {
			writeOutput('
				<nav aria-label="breadcrumb">
					<ol class="breadcrumb">
			');
			breadcrumbNodes.each(function(node, index) {
				writeOutput('<li class="breadcrumb-item#index == breadcrumbNodes.len() ? ' active" aria-current="page"' : '"'#>#index == breadcrumbNodes.len() ? node.name : '<a href="#context.buildLink(node.link)#">#node.name#</a>'#</li>');
			});
			writeOutput('
					</ol>
				</nav>
			');
		};

		return breadcrumbHTML;
	}


	/**
	 * getMemento
	 */
	function getMemento(){
		return Variables;
	}

}