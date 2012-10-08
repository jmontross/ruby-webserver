# require 'socket'
require 'yaml'
require 'webrick' 
require 'erb'
require 'json'

# make it 80 if you want.  be sure to run as sudo.  
port = 8000
# note - when I ran on port 80 it conflicted with things on my computer

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

## for images need to set DocumentRoot: ... make sure to run this from base of the app at ~/ruby_weberver
server = WEBrick::HTTPServer.new(:Port => port,DocumentRoot: Dir.pwd)

## loop over routes and mount each route to its class.  
## this is not very extensible as you need a new class for each route in the config. 

ROUTES['endpoints'].each do |route,configuration| 
  # register route to http_action
  puts "mounting /#{route}"  
  server.mount "/#{route}", Kernel.const_get(route.capitalize)  
end

puts 
"shutdown with ctrl+c"
# shutdown server when i do ctrl+c
trap "INT" do server.shutdown end
server.start
