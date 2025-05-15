# DNS Utility

DNS query utilities

## Installation

Install via CommandBox like so:

`box install dns-utility`

## Overview

Uses HTTPS DNS api to query for dns records. 

## Supported HTTPS DNS API Providers

- Google
- Cloudflare

## Supported DNS Record Types

- `A`
- `AAAA`
- `CNAME`
- `MX`
- `NS`
- `SOA`
- `SRV`
- `TXT`
- `PTR`
- `HINFO`
- `RP`

## Command Line Arguments

`dns query <RecordType> <DomainName> [<DNSProvider>] [<showRaw>]`

- `RecordType` Required : String : Supported record type. I.E. A, TXT, MX, NS, etc.
- `DomainName` Required : String : Domain Name to be queried. I.E. forgebox.io
- `DNSProvider` Optional : String : DNS Provider, defaults to `Cloudflare`. Options: `Cloudflare` & `Google`
- `showRaw` Optional : boolean : If true shows the raw unparsed record result from API. Default is `false`

## Examples

#### Basic Example

Get MX record(s) for forgebox.io

`dns query mx forgebox.io`

#### Basic Example with raw API results

Get MX record(s) for forgebox.io with raw API record result

`dns query mx forgebox.io --showRaw`

#### Basic Example With Google DNS Provider

Get MX record(s) for forgebox.io from Google

`dns query mx forgebox.io Google`
