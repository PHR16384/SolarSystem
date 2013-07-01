/*
	Use jQuery Mobile "pageinit" event to solve a few bugs created by the standard jQuery .ready() event:
	
*/
//$(document).ready( function()
$(document).on("pageinit", function()
{
	/*
		FYI, I like to use $ to prefix variables that hold jQuery objects
		If I ever use code-generated vars, the syntax'll probably be "$_lowercase_name" or whatever
	*/
	var $JStatus = $("<p id='JSONstatus'>Importing JSON data...</p>");
	var $Content = $("[data-role='content']");
	var $SSdiv = $("#SSData");
	
	var $Stars = new Array();
	var $Planets = new Array();
	var $Asteroids = new Array();
	var $KBObjs = new Array();
	//var $New;
	
	var s,S, p,P, a,A, k,K ;	//integers
	var str = "";
	
	$Content.prepend($JStatus);
	
	/* ANOTHER NOTE:
		AJAX needs an HTTP protocol (i.e. online hosting or localhost) to function; 
		Cannot run from the file system (e.g. "file:///C:/...")
	*/
	$.getJSON("data/SolarSys.json")
		.done(Gotdata)
		.fail(GotJErr)
	;
	
	
	//run when JSON request succeeds:
	function Gotdata(data, textStatus, jqXHR)
	{
		$JStatus.html("JSON request succeeded!")
			.after("<h2>Click/tap on a celestial body to learn more about it!</h2>")
			.hide()	// comment/uncomment for debugging
		;
		
		$SSdiv.append("<hr /><div class='Category' id='Stars'></div>");
		$SSdiv.append("<hr /><div class='Category' id='Planets'></div>");
		S = data.Stars.length;
		P = data.Planets.length;
		
		//alert( $.isArray(data.Stars) );
		
		str = "Star";
		for(s = 0; s < S; s++)
		{
			$Stars[s] = $("<div class='CelBody' id='" + str + s + "'></div>");
			
			$Stars[s]
				.append(
					"<h2 class='Name'>" + data.Stars[s].Name + "</h2>", 
					"<img src='Shared/images/Stars/" + data.Stars[s].Name + ".jpg' />"
				)
				.on("click", {TYPE:str,OBJ:data.Stars[s]}, InfoPopup)
			;
		}
		
		str = "Planet";
		for(p = 0; p < P; p++)
		{
			$Planets[p] = $("<div class='CelBody' id='" + str + p + "'></div>");
			
			$Planets[p]
				.append(
					"<h2 class='Name'>" + data.Planets[p].Name + "</h2>", 
					"<img src='Shared/images/Planets/" + data.Planets[p].Name + ".jpg' />"
				)
				.on("click", {TYPE:str,OBJ:data.Planets[p]}, InfoPopup)
			;
		}
		
		$("#Stars")
			.append( $Stars )
			.before("<h3>Stars</h3>")
		;
		$("#Planets")
			.append( $Planets )
			.before("<h3>Planets</h3>")
		;
		
		
		//$Content.trigger("create");	//force-applies jQM CSS styles to script-generated content
		
		
		//commands to create and display a popup; will contain info about the clicked celestial body
		function InfoPopup(e)
		{
			var target = $(this);
			//alert(target.attr("id"));	//check the id of the clicked item(s)
			
			var $Popup = $("<div/>").popup({
				dismissible: true,
				history: false,
				overlayTheme: "a",
				positionTo: "window",
				theme: "a",
				transition: "pop"
			}).on("popupafterclose", function() {
				//remove the popup when closing
				$(this).remove();
			});
			
			//JSON fields shared among all celestial bodies:
			$Popup
				.attr("id", "Popup_"+e.data.OBJ.Name)
				.append( target.find("img").clone() )
			;
			
			$("<h2/>", {
				html: e.data.TYPE + ":&nbsp; &ldquo;" + e.data.OBJ.Name + "&rdquo;"
			}).prependTo( $Popup );
			
			//stars, planets, etc. have different fields in the JSON file:
			switch(e.data.type)
			{
				case "Stars":
					//alert("Data for stars.");
					
					break;
				case "Planets":
					//alert("Data for planets.");
					
					break;
				default:
					//alert("Data handler not set.");
					break;
			}
			
			// close ("X") button:
			$("<a/>", {
				text: "Close",
				"class": "ui-btn-right",
				"data-role": "button"
			}).buttonMarkup({
				icon: "delete",
				iconpos: "notext",
				inline: true,
				theme: "a"
			}).on("click", function() {
				$Popup.popup("close");
			}).appendTo($Popup);
			
			$Popup.popup("open").trigger("create");
		}
	}
	
	//run when JSON request craps out on us:
	function GotJErr(jqXHR, textStatus, errorThrown)
	{
		str = textStatus + ": " + errorThrown;
		$JStatus.html(str);
	}
	
});
