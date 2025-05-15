/**
 *  Query DNS Records
 * .
 * {code:bash}
 * dns query <recordtype> <domain>
 * {code}
 *
 **/
 component {

	property name="dnsUtility"		inject="utility@dns-utility";
	property name="moduleSettings"	inject="box:modulesettings:dns-utility";

	/**
	 *  Query DNS Records
	 *
	 * @recordType	String : Type of DNS record to query for
	 * @domainName	String : Domain to query for DNS records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 **/
	function run( required string recordType, required string domainName, string dnsProvider = "Cloudflare", boolean showRaw = false ){
		if( !moduleSettings.dnsRecordTypes.findValue( ucase( arguments.recordType ), "one" ).len() ){
			displayMultiLineBlock( [ "Error:", "#ucase( arguments.recordType )# is not a supported DNS record type"], "warning" );
			return;
		}
		if( !moduleSettings.dnsProviders.keyExists( arguments.dnsProvider ) ){
			displayMultiLineBlock( [ "Error:", "#arguments.dnsProvider# is not a supported DNS Provider"], "warning" );
			return;
		}

		displayMultiLineBlock( 
			[
				"Querying #ucase( arguments.recordType )# record(s) for #arguments.domainName#",
				"Using #arguments.dnsProvider# HTTPS DNS"
			],
			"info"
		);

		var dnsResults = dnsUtility.queryRecord( { "type" : arguments.recordType, "name": arguments.domainName }, arguments.dnsProvider );

		if( len( dnsResults.message ) ){
			displayMultiLineBlock( [ "Error:", dnsResults.message ], "default" );
			return;
		}

		variables.print
			.lineBoldText( "#ucase( arguments.recordType )# Record(s) for #arguments.domainName#:" )
			.lineBoldText( padString( "", 100, "-" ) );
		
		dnsResults.Answer.each( function( dnsRecord, index ) {
			displayRecord( dnsRecord, dnsResults.rawResponse.Answer[index], showRaw );
		});

	} // run()

	function displayRecord( dnsRecord, rawRecord, showRaw ){
		variables.print.line( "#padString( "Type", 25 )# : #dnsRecord.Type#" );
		if( dnsRecord.keyExists("TTL") )
			variables.print.line( "#padString( "TTL", 25 )# : #dnsRecord.TTL#" );
		switch( ucase( arguments.dnsRecord.Type ) ){
			case "MX":
				if( dnsRecord.keyExists( "Preference" ) ) 
					variables.print.line( "#padString( "Preference", 25 )# : #dnsRecord.Preference#" );
				if( dnsRecord.keyExists( "Exchange" ) ) 
					variables.print.line( "#padString( "Exchange", 25 )# : #dnsRecord.Exchange#" );
				break;
			case "NS":
				if( dnsRecord.keyExists( "NameServer" ) ) 
					variables.print.line( "#padString( "Name Server", 25 )# : #dnsRecord.NameServer#" );
				break;
			case "SOA":
				if( dnsRecord.keyExists( "PrimaryNameServer" ) ) 
					variables.print.line( "#padString( "Primary Name Server", 25 )# : #dnsRecord.PrimaryNameServer#" );
				if( dnsRecord.keyExists( "ResponsiblePerson" ) ) 
					variables.print.line( "#padString( "Responsible Person", 25 )# : #dnsRecord.ResponsiblePerson#" );
				if( dnsRecord.keyExists( "Serial" ) ) 
					variables.print.line( "#padString( "Serial", 25 )# : #dnsRecord.Serial#" );
				if( dnsRecord.keyExists( "Refresh" ) ) 
					variables.print.line( "#padString( "Refresh", 25 )# : #dnsRecord.Refresh#" );
				if( dnsRecord.keyExists( "Retry" ) ) 
					variables.print.line( "#padString( "Retry", 25 )# : #dnsRecord.Retry#" );
				if( dnsRecord.keyExists( "Expire" ) ) 
					variables.print.line( "#padString( "Expire", 25 )# : #dnsRecord.Expire#" );
				if( dnsRecord.keyExists( "Minimum" ) ) 
					variables.print.line( "#padString( "Minimum", 25 )# : #dnsRecord.Minimum#" );
				break;
			default: 
				variables.print.line( "#padString( "Record", 25 )# : #dnsRecord.data#" );
				break;
		}

		if( arguments.showRaw ){
			variables.print.line( "#padString( "Raw DNS Record", 25 )# : " )
				.line()
				.line( rawRecord )
				.line();
		}

		// variables.print.blackOnYellow( rawRecord ).line();
		variables.print.lineBoldText( padString( "", 100, "-" ) );

	} // displayRecord()

	function padString( inString, inLength, string pad = " " ){
		if( len( arguments.inString ) < arguments.inLength ){
			return inString & repeatString( arguments.pad, arguments.inLength - len( arguments.inString ) );
		}
		return arguments.inString;
	} // padString()

	function displayMultiLineBlock( inLines, string type="info" ){
		variables.print.line().lineUnderscored( padString( "", 100 ) )
		switch( lcase( arguments.type ) ) {
			case "info":
				variables.print.boldWhiteOnBlue3Line( padString( "", 100 ) );
				arguments.inLines.each( function( line, index ) {
					variables.print.boldWhiteOnBlue3Line( padString( line, 100 ) );
				} );
				variables.print.boldWhiteOnBlue3LineUnderscored( padString( "", 100 ) );
				break; 
			case "error":
				variables.print.boldWhiteOnRed2Line( padString( "", 100 ) );
				arguments.inLines.each( function( line, index ) {
					variables.print.boldWhiteOnRed2Line( padString( line, 100 ) );
				} );
				variables.print.boldWhiteOnRed2LineUnderscored( padString( "", 100 ) );
				break; 
			case "warning":
				variables.print.boldWhiteOnOrange3rodLine( padString( "", 100 ) );
				arguments.inLines.each( function( line, index ) {
					variables.print.boldWhiteOnOrange3rodLine( padString( line, 100 ) );
				} );
				variables.print.boldWiteOnOrange3rodLineUnderscored( padString( "", 100 ) );
				break; 
			default: 
				variables.print.Line( padString( "", 100 ) );
				arguments.inLines.each( function( line, index ) {
					variables.print.Line( padString( line, 100 ) );
				} );
				variables.print.LineUnderscored( padString( "", 100 ) );
				break; 
		}
		variables.print.line();
	}

}