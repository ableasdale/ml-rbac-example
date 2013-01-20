ml-rbac-example
===============

MarkLogic Role Based Access Control Application Example
 
To install:

1. You should have MarkLogic installed
2. I'm working on the premise that it's okay to use the Documents database (if you have content in here already, let me know and I'll create a dedicated db for the app to run against)
3. There are 2 install scripts:
- create-security-model.xqy
- create-data-model.xqy 
Start by opening query console (localhost:8000/qconsole), copy and paste the contents of create-security-model.xqy into a query buffer 
4. Ensure Security is selected as the "Content Source" and in order, execute:
- local:create-primary-roles()
- local:create-secondary-roles()
- (local:create-privileges(), local:create-users())
5. Ensure Documents is selected as the "Content Source" and copy, paste and execute the contents of create-data-model.xqy; this will create the application server and populate the Documents database with some sample XML which will demonstrate the application
6. Copy all the modules in the app folder to /tmp (or change the application server root accordingly) 
7.Go to: localhost:9999 and try logging in as some of the different users:
- reviewer:password
- publisher:password  
- author:password
- editor:password
 