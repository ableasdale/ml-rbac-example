xquery version "1.0-ml"; 
 
import module namespace common = "http://www.example.com/common" at "/common.xqy";  
 
declare variable $uri as xs:string := xdmp:get-request-field("uri");
declare variable $MAIN-BOOK-CATALOGUE as xs:string := "main-book-catalogue"; 


declare function local:publish() as element()? { 
let $e := try {
    (xdmp:document-set-collections($uri, $MAIN-BOOK-CATALOGUE ),
    xdmp:document-set-permissions($uri, ( 
            xdmp:permission("main-collection-read", "read"),
            xdmp:permission("main-collection-update", "update") ))) 

} catch ($e) {
    $e
}
return $e
};

let $result := local:publish()
return if (local-name($result) eq "error")
then (common:build-page(common:exception($result))) 
else (common:build-page(common:success(concat("Doc ",$uri," has been published"), 
    element p { common:create-navlink(concat("/view.xqy?id=", $uri), concat("View Document ",$uri), fn:false()) } )))
    