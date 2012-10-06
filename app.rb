# require 'socket'
require 'yaml'

require 'webrick' 
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

routes = YAML.load_file('config/rest_endpoints.yml')

server = WEBrick::HTTPServer.new(:Port => port)

routes['endpoints'].each do |route,http_action| 
  # register route to http_action
  server.mount route, Kernel.constantize

end

class Map < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)
    html   = "<html><body><form method='POST' action='/save'>"
    html += "Name: <input type='textbox' name='first_name' /><br /><br />";

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

class Create < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)
    html   = "<html><body><form method='POST' action='/save'>"
    html += "Name: <input type='textbox' name='first_name' /><br /><br />";

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

class View < WEBrick::HTTPServlet::AbstractServlet

  # Process the request, return response
  def do_GET(request, response)
    status, content_type, body = print_questions(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  # Construct the return HTML page
  def print_questions(request)
    html   = "<html><body><form method='POST' action='/save'>"
    html += "Name: <input type='textbox' name='first_name' /><br /><br />";

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