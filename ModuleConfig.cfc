/**
 *********************************************************************************
 * Michael Rigsby | OIS Technologies | www.oistech.com | mrigsby@oistech.com
 ********************************************************************************
 *
 * @author Michael Rigsby
 */
component {

	this.name      = "DNS UTILITY";
	this.version   = "@build.version@+@build.number@";
	this.cfmapping = "dns-utility";

	function configure(){

		settings = {
			"dnsProviders" : {
				"Google" : {
					"baseURL" : "https://dns.google/resolve",
					"headers" : {
						"accept" : "application/dns-message"
					}
				},
				"Cloudflare" : {
					"baseURL" : "https://cloudflare-dns.com/dns-query",
					"headers" : {
						"accept" : "application/dns-json"
					}
				}
			},
			"dnsRecordTypes" : {
				"1"		: "A",
				"28"	: "AAAA",
				"5"		: "CNAME",
				"15"	: "MX",
				"2"		: "NS",
				"6"		: "SOA",
				"33"	: "SRV",
				"16"	: "TXT",
				"12"	: "PTR",
				"13"	: "HINFO",
				"17"	: "RP"
			}

		}
		
	}

}
