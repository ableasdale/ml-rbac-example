xquery version "1.0-ml"; 
 
import module namespace common = "http://www.example.com/common" at "/common.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions"; 

(xdmp:document-insert(common:guid(),   
element comment {
    element user {xdmp:get-current-user()},
    element doc-uri {xdmp:get-request-field("uri")},
    element comment {xdmp:get-request-field("comment")},
    element date-time {fn:current-dateTime()}
}, (xdmp:permission("comment-role","read"), xdmp:permission("comment-role","update")), "comments"),
xdmp:redirect-response(concat("/view.xqy?id=",xdmp:get-request-field("uri")))) 