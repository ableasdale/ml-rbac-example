xquery version "1.0-ml";

(:~ 
 : Sample Data / Application Server Setup Module for creating the application with sample data  
 :
 : @version 1.0
 :)
 
 import module namespace admin = "http://marklogic.com/xdmp/admin" 
		  at "/MarkLogic/admin.xqy";
 
 
declare variable $MAIN-BOOK-CATALOGUE as xs:string := "main-book-catalogue"; 
declare variable $RESTRICTED-BOOK-CATALOGUE as xs:string := "restricted-book-catalogue"; 
declare variable $UNPUBLISHED-BOOK-CATALOGUE as xs:string := "unpublished-book-catalogue";

(: Load sample data and apply collections / permissions:)

declare function local:get-sample-medline-data() as empty-sequence() {
    for $i at $pos in xdmp:document-get("http://www.nlm.nih.gov/databases/dtd/medsamp2013.xml")/MedlineCitationSet/MedlineCitation
    return if ($pos > 100 and $pos < 120)
    then (
    xdmp:document-insert($i/PMID/string(), $i, 
            ( 
            xdmp:permission("restricted-collection-read", "read"),
            xdmp:permission("restricted-collection-update", "update")
            ), $RESTRICTED-BOOK-CATALOGUE)
    ) else if ($pos > 120)
    then (
    xdmp:document-insert($i/PMID/string(), $i, 
            ( 
            xdmp:permission("unpublished-collection-read", "read"),
            xdmp:permission("unpublished-collection-update", "update")
            ), $UNPUBLISHED-BOOK-CATALOGUE) 
    ) else (
    xdmp:document-insert($i/PMID/string(), $i, 
            ( 
            xdmp:permission("main-collection-read", "read"),
            xdmp:permission("main-collection-update", "update")
            ), $MAIN-BOOK-CATALOGUE)
    )                
}; 


declare function local:create-http-application-server() { 
  let $config := admin:get-configuration()  
  let $config := admin:http-server-create($config, admin:group-get-id($config, "Default"), "http-9999", 
        "/tmp", 9999, 0, xdmp:database("Documents") )
  let $config := admin:appserver-set-authentication($config, 
         admin:appserver-get-id($config, admin:group-get-id($config, "Default"), "http-9999"),
         "application-level")
  return
  admin:save-configuration($config)   
};

(::::::::::::::::::::::::::)
(: Main Module Code below :)
(::::::::::::::::::::::::::)

(local:get-sample-medline-data(), 
local:create-http-application-server()) 