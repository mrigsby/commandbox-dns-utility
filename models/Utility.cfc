component singleton {

	property name="moduleSettings"	inject="box:modulesettings:dns-utility";

     /**
     *  Constructor
     */
     function init() {
         return this;
     }
	/**
	 * Cloudflare DNS over HTTPS (JSON) API Documentation
	 * https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/make-api-requests/dns-json/
	 * 
	 * Google DNS over HTTPS (JSON) API Documentation
	 * https://developers.google.com/speed/public-dns/docs/doh
	 * https://developers.google.com/speed/public-dns/docs/doh/json
	 * 
	 * DNS ID Numbers
	 * https://www.iana.org/assignments/dns-parameters/dns-parameters.xhtml#dns-parameters-4
	 */

	/**
	 * Gets the A records for a given domain
	 *
	 * @entryDomain	Domain to query for A records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getA( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "A", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the AAAAA records for a given domain
	 *
	 * @entryDomain	Domain to query for A records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getAAAA( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "A", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the CNAME records for a given domain
	 *
	 * @entryDomain	Domain to query for A records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getCNAME( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "CNAME", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the MX records for a given domain
	 *
	 * @entryDomain	Domain to query for MX records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getMX( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "MX", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the NS records for a given domain
	 *
	 * @entryDomain	Domain to query for A records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getNS( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "NS", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the SOA records for a given domain
	 *
	 * @entryDomain	Domain to query for SOA records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getSOA( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "SOA", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the SRV records for a given domain
	 *
	 * @entryDomain	Domain to query for SRV records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getSRV( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "SRV", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the TXT records for a given domain
	 *
	 * @entryDomain	Domain to query for TXT records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getTXT( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "TXT", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the PTR records for a given domain
	 *
	 * @entryDomain	Domain to query for PTR records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getPTR( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "PTR", "name": arguments.entryDomain }, arguments.dnsProvider );
	}


	/**
	 * Gets the HINFO records for a given domain
	 *
	 * @entryDomain	Domain to query for HINFO records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getHINFO( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "HINFO", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the RP records for a given domain
	 *
	 * @entryDomain	Domain to query for RP records
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function getRP( entryDomain, string dnsProvider = "Cloudflare"  ){
		return queryRecord( { "type" : "RP", "name": arguments.entryDomain }, arguments.dnsProvider );
	}

	/**
	 * Gets the MX records for a given domain
	 *
	 * @queryParams	Struct of query parameters to send to the DNS provider, usually including: type & name
	 * @dnsProvider	String : DNS provider to use for the query. Default is Cloudflare. Options are: Google, Cloudflare
	 */
	function queryRecord( required struct queryParams, string dnsProvider = "Cloudflare" ){
		var HTTPResults = "";
		var HTTPHeaders = moduleSettings.dnsProviders[ arguments.dnsProvider ].headers;
		cfhttp( 
			method="GET", 
			charset="utf-8", 
			url="#moduleSettings.dnsProviders[ arguments.dnsProvider ].baseURL#?#createQueryString( arguments.queryParams )#", 
			result="HTTPResults"
		){
			for ( var currentKey in HTTPHeaders ) { 
				cfhttpparam( type="header", name=currentKey, value=HTTPHeaders[ currentKey ] );
			}
		}

		return processHTTPResults( HTTPResults );
	}

	function createQueryString( required struct queryParams ){
		var queryParmsArray = [];
		for ( var currentKey in arguments.queryParams ) { 
			queryParmsArray.append( currentKey & "=" & arguments.queryParams[ currentKey ] );
		}
		return queryParmsArray.toList("&");
	}

	function processHTTPResults( HTTPResults ){
		var results = { 
			"statusCode" : "", 
			"response" : {}, 
			"message" : "", 
			"responseheader" : {}, 
			"rawResponse" : "", 
			"question" : [], 
			"answer" : [], 
			"authority" : [], 
			"additional" : [] 
		};

		// Results
		results.responseHeader 	= HTTPResults.responseHeader;
		results.rawResponse 	= isJSON( HTTPResults.fileContent.toString() ) ? deserializeJSON( HTTPResults.fileContent.toString(), false ) : HTTPResults.fileContent.toString();
		results.response 		= isJSON( HTTPResults.fileContent.toString() ) ? deserializeJSON( HTTPResults.fileContent.toString(), false ) : {};
		results.statusCode 		= HTTPResults.statuscode ?: HTTPResults.status_code ?: "";

		// Errors
		if( len( HTTPResults.errorDetail ) ){
			results.message = HTTPResults.errorDetail;
		}

		if( results.response.keyExists("Error") ){
			results.message = results.response.Error;
		}

		if( !results.response.keyExists("Answer") ){
			results.message = "No records found";
		}

		if( !len( results.message ) ){
			if( results.response.keyExists( "question" ) ){
				results.question = changeDNSQueryTypes( results.response.question );
			}
			if( results.response.keyExists( "Answer" ) ){
				results.Answer = updateAnswerData( changeDNSQueryTypes( results.response.Answer ) );
			}
			if( results.response.keyExists( "authority" ) ){
				results.authority = changeDNSQueryTypes( results.response.authority );
			}
			if( results.response.keyExists( "additional" ) ){
				results.additional = changeDNSQueryTypes( results.response.additional );
			}
		}
		return results;
	}

	function changeDNSQueryTypes( inArray ){
		return inArray.map( function( item ){
			if( item.keyExists( "type" ) && isNumeric( item.type ) && moduleSettings.dnsRecordTypes.keyExists( "#item.type#" ) ){
				item.type = moduleSettings.dnsRecordTypes[ "#item.type#" ];
			}
			return item;
		} );
	}

	function updateAnswerData( inData ){
		return arguments.inData.map( function( Answer ){
			if( arguments.Answer.keyExists( "type" ) && !isNumeric( arguments.Answer.type ) ){
				switch( arguments.Answer.type ) {
					case "MX":
						if( isNumeric( listFirst( arguments.Answer.data, " " ) ) && listLen( arguments.Answer.data, " " ) == 2 ){
							arguments.Answer["Preference"] = listFirst( arguments.Answer.data, " " );
							arguments.Answer["Exchange"] = listLast( arguments.Answer.data, " " );
							if( right( arguments.Answer.Exchange, 1 ) == "." ){
								arguments.Answer.Exchange = left( arguments.Answer.Exchange, len( arguments.Answer.Exchange ) - 1 );
							}
						}
						// MX record
						break; 
					case "SOA":
						if( listLen( arguments.Answer.data, " " ) == 7 ){
							arguments.Answer["PrimaryNameServer"] = listGetAt( arguments.Answer.data, 1, " " );
							if( right( arguments.Answer.PrimaryNameServer, 1 ) == "." ){
								arguments.Answer.PrimaryNameServer = left( arguments.Answer.PrimaryNameServer, len( arguments.Answer.PrimaryNameServer ) - 1 );
							}
							arguments.Answer["ResponsiblePerson"] = listGetAt( arguments.Answer.data, 2, " " );
							if( right( arguments.Answer.ResponsiblePerson, 1 ) == "." ){
								arguments.Answer.ResponsiblePerson = left( arguments.Answer.ResponsiblePerson, len( arguments.Answer.ResponsiblePerson ) - 1 );
							}
							if( !find( "@", arguments.Answer.ResponsiblePerson, 1 ) && listLen( arguments.Answer.ResponsiblePerson, "." ) >= 2 ){
								arguments.Answer.ResponsiblePerson = replace( arguments.Answer.ResponsiblePerson, ".", "@", "one" );
							}
							arguments.Answer["Serial"] = listGetAt( arguments.Answer.data, 3, " " );
							arguments.Answer["Refresh"] = listGetAt( arguments.Answer.data, 4, " " );
							arguments.Answer["Retry"] = listGetAt( arguments.Answer.data, 5, " " );
							arguments.Answer["Expire"] = listGetAt( arguments.Answer.data, 6, " " );
							arguments.Answer["Minimum"] = listGetAt( arguments.Answer.data, 7, " " );
						}
						// SOA record
						break; 
					case "NS":
						arguments.Answer["NameServer"] = arguments.Answer.data;
						if( right( arguments.Answer.NameServer, 1 ) == "." ){
							arguments.Answer.NameServer = left( arguments.Answer.NameServer, len( arguments.Answer.NameServer ) - 1 );
						}
						// NS record
						break; 
					default: 
						// no match found, do nothing
						break; 
				}
			}
			return arguments.Answer;
		} );
	}


}