Let's start from the beginning and go way back to the early days of web development and server programming, followed by adding a little modern touch to the effort.

 

1. Create a web server from scratch.  It should be able to listen on port 80 and serve up basic items such as images, JS, and CSS files.

 

2. Next, implement support for a basic RESTful API service on your newly-built web server.  Ideally, one should be able to specify a YAML file with the desired REST endpoints (including specifc HTTP VERBs) that one can take on an endpoint.

 

3. Make your newly created REST web server do something interesting :)

 

4. Be sure to document your code cleanly, and list out why you have chosen to make certain "optimizations" using Ruby-specific techniques.

 

5. You may use whatever resources you want, but do not spend more than 2 hours on this exercise.


sources:
http://www.igvita.com/2007/02/13/building-dynamic-webrick-servers-in-ruby/
http://www.ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick/HTTPProxyServer.html#method-i-do_OPTIONS
http://stackoverflow.com/questions/5973704/serving-images-using-webrick
http://www.scribd.com/doc/20755982/The-Ruby-1-9-x-Web-Servers-Booklet

  note - uses rvm with 1.9.2 and a gemset called rweb - this is because I wanted no gems on the system for it to work :)

  To run - sudo ruby app.rb