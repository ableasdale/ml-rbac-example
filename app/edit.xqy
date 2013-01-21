xquery version "1.0-ml";

import module namespace common = "http://www.example.com/common" at "/common.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

(::::::::::::::::::::::::::)
(: Main Module Code below :)
(::::::::::::::::::::::::::)
    
let $e := try {
    xdmp:node-replace(doc(xdmp:get-request-field("uri"))/node(), xdmp:unquote(xdmp:get-request-field("doc"), (), ("format-xml" ) )/node())     
} catch($e) {
    $e
} 
return if (local-name($e) eq "error")
then (common:build-page(common:exception($e)))
else (common:build-page(common:success(
    concat("Doc ", xdmp:get-request-field("uri"), " has been updated"), 
    element p {common:create-navlink(concat("/view.xqy?id=", xdmp:get-request-field("uri")), concat("View Document ", xdmp:get-request-field("uri")), false() )}
)))
