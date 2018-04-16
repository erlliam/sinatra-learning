# myapp.rb
require "sinatra"

get "/" do
	File.read("index.html")
end

post "/" do
	"#{params["inputOne"]}"
end

