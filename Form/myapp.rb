# myapp.rb
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite::memory:")

get "/" do
	File.read("index.html")
end

post "/" do
	@post = Post.create(
		:title => "My first DataMapper post",
		:body => "#{params["inputOne"]}",
		:created_at => Time.now
		)
	"#{Post.get(1).title}, #{Post.get(1).body}, #{Post.get(1).created_at}"
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