# myapp.rb
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite::memory:")

get "/" do
	File.read("index.html")
end

post "/" do
	html = ""
	@post = Post.create(
		:title => "My first DataMapper post",
		:body => "#{params["inputOne"]}",
		:created_at => Time.now
		)
	Post.all.each { |x|
		html << "<p>#{x.body}</p>"
	}
	html
end

class Post
	include DataMapper::Resource

	property :id, Serial
	property :title, String
	property :body, Text
	property :created_at, DateTime

end

DataMapper.finalize
DataMapper.auto_migrate!