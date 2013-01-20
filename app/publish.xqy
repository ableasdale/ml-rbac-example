xquery version "1.0-ml"; 
 
declare variable $uri as xs:string := xdmp:get-request-field("uri");
declare variable $MAIN-BOOK-CATALOGUE as xs:string := "main-book-catalogue"; 

(xdmp:document-set-collections($uri, $MAIN-BOOK-CATALOGUE ), 
xdmp:document-set-permissions($uri, ( 
            xdmp:permission("main-collection-read", "read"),
            xdmp:permission("main-collection-update", "update") ) 
 ), xdmp:redirect-response("/") 
) 