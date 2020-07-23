component {
	// Module Properties
	this.title 				= "cbbreadcrumb";
	this.author 			= "Gary Stanton";
	this.description 		= "Uses the routing table to provide breadcrumb functionality to Coldbox applications";
	this.version			= "1.0.0";
	// Module Entry Point
	this.entryPoint			= "cbbreadcrumb";
	// Auto-map models
	this.autoMapModels		= true;

	/**
	 * Configure the module
	 */
	function configure(){
	}

    /**
     * Place a breadcrumb object into every request
     */
    function preProcess() {
		prc.cbbreadcrumb = wirebox.getInstance('@cbbreadcrumb');
    }
}