xquery version "1.0-ml"; 

module namespace common="http://www.example.com/common";

declare namespace xhtml = "http://www.w3.org/1999/xhtml";
 
(: note that application/xhtml+xml is *still* not supported by several modern browsers... :)
 
declare function common:build-page($html as element()){
xdmp:set-response-content-type("text/html; charset=utf-8"),
'<?xml version="1.0" encoding="UTF-8"?>',
'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">',
common:html-page-enclosure($html)
};

declare function common:html-head(){
    <link rel="stylesheet" type="text/css" href="http://www.blueprintcss.org/blueprint/screen.css" />
};
 

declare function common:html-page-enclosure($content as element()) as element(html){
element html {attribute lang {"en"}, attribute xml:lang {"en"},
    element head {common:html-head()},
    element body {$content}
}
};

declare function common:login-form() as element(form) {
element form { attribute method {"post"}, attribute action {"/login.xqy"},
    element fieldset {
        element legend {"Log-in:"},
        element p {"Username: ", element input {attribute type {"text"}, attribute name {"username"}}},
        element p {"Password: ", element input {attribute type {"password"}, attribute name {"password"}}},
        element p {element input {attribute type {"submit"}, attribute name {"login"}, attribute value {"Login!"}}} 
    }
}
};

declare private function common:random-hex($seq as xs:integer*) as xs:string+ {
  for $i in $seq return 
    fn:string-join(for $n in 1 to $i
      return xdmp:integer-to-hex(xdmp:random(15)), "")
};

declare function common:guid() as xs:string {
  fn:string-join(common:random-hex((8,4,4,4,12)),"-")
};

