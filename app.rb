# require 'socket'
require 'yaml'
require 'webrick' 
require 'erb'
require 'json'

port = 8000
# make it 80 if you want.  be sure to run as sudo.  

# server = TCPServer.new("0.0.0.0", 8080)

# while session = server.accept
#   session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
#   if request = session.gets
#     filename = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '').chomp
#     filename = "index.html" if filename == ""
    
#     session.print "You asked for a file called #{filename}"


#   end
#   session.close 
# end

ROUTES = YAML.load_file('config/rest_endpoints.yml')

class Map < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = show_map(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def show_map(request)
     html = File.read('public/index.html.erb')
    # Return OK (200), content-type: text/html, followed by the HTML itself
    return 200, "text/html", html
  end
end

class Create < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response

  def do_POST(request, response)
    status, content_type, body = save_item(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Save POST request into a text file
  def save_item(request)
	 if (filename = request.query['name'] )
      f = File.open("tmp/save-#{filename}.#{Time.now.strftime('%H%M%S')}.yml", 'w')

      # Iterate over every POST'ed value and persist it to file
      items = []
      request.query.collect { | key, value | 
      	  items << {key.to_sym => value}
	      f.write("#{key}: #{value}\n") 
	  }
      f.close
    end    
    # Return OK Created (201), content-type: text/html, followed by the HTML itself
    return 201, "text/html", {:status => "successfully saved items ", :items_save => items}.to_json
  end
end

class View < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = show_items(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def show_items(request)  	
    starting_items = ROUTES['endpoints']['view']['viewables']
    # ['endpoints']['view']['viewables']

    # => [{:name=>"downtown_yoga_shala", :description=>"awesome yoga place - each wednesday six am"}] 
    
    html   = "<html><body><form method='POST' action='/create'>"
    html  +=  "<h2> current items in our list </h2> <ul>"
    starting_items.each do |item|
      html += "<li> Name : #{item[:name]} </li>"
    end
     Dir.entries('tmp').each do |file| 
	    if file.match(/\.yml/)
	      y = YAML.load_file("tmp/#{file}")	
	   	  html += "<li> Name : #{y['name']} </li>"   
	    end
	end  
	html += "</ul>"

    html += "Name: <input type='textbox' name='name' /><br /><br />";
    html += "Description: <input type='textbox' name='description' /><br /><br />";
    html += "Address: <input type='textbox' name='address' /><br /><br />";

    # dbh = DBI.connect("DBI:Mysql:webarchive:localhost", "root", "pass")
    # sth = dbh.execute("SELECT headline, story, id FROM yahoo_news where date >= '2004-12-01' and date <= '2005-01-01'")

    #   # iterate over every returned news-story from the database
    #   while row = sth.fetch_hash do
    #       html += "<b>#{row['headline']}</b><br />\n"
    #       html += "#{row['story']}<br />\n"
    #       html += "<input type='textbox' name='#{row['id']}' /><br /><br />\n"
    #  end
    #  sth.finish

    html += "<input type='submit'></form></body></html>"

    # Return OK (200), content-type: text/html, followed by the HTML itself
    return 200, "text/html", html
  end

end

class Read < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = show_items(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def show_items(request)  	

    starting_items = ROUTES['endpoints']['view']['viewables']
    # ['endpoints']['view']['viewables']

    # => [{:name=>"downtown_yoga_shala", :description=>"awesome yoga place - each wednesday six am"}] 
    
    json = []
    starting_items.each do |item|
      json << item
    end

    Dir.entries('tmp').each do |file| 
	    if file.match(/\.yml/)
	      y = YAML.load_file("tmp/#{file}")	
	      json << y
	    end
	end  
    # Return OK (200), content-type: text/html, followed by the HTML itself
    return 200, "text/json", json.to_json
  end

end

## for images need to set DocumentRoot: "/Users/jmontross/github/jmontross/ruby_webserver" -- not working...
server = WEBrick::HTTPServer.new(:Port => port)

ROUTES['endpoints'].each do |route,configuration| 
  # register route to http_action
  puts "mounting /#{route}"
  server.mount "/#{route}", Kernel.const_get(route.capitalize)  
end

## just to get somethign at the base
server.mount '/', Map

trap "INT" do server.shutdown end
server.start
