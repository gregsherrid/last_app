var MAX_LEN = 140;

function composeBoxSetup() {

	$("div.field textarea").bind( 'input propertychange', onNewText );

	onNewText();
}

function onNewText() {
	var rChars = MAX_LEN - $("div.field textarea").val().length;

	if ( rChars >= 0 ) {
		$("#wordCounter").html( rChars ).css( "color", "#007");
	} else {
		$("#wordCounter").html( rChars ).css( "color", "#700");
	}
}