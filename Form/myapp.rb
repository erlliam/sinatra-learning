# myapp.rb
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite::memory:")

class Post
	include DataMapper::Resource

	property :id, Serial
	property :title, String
	property :body, Text
	property :created_at, DateTime

end

DataMapper.finalize
DataMapper.auto_migrate!

get "/" do
	File.read("index.html")
end

get "/post" do
	html = "
	<a href='/'>Create post</a>
	"	
	Post.all.each { |x|
		html << "
		<div>
			<p>#{x.body}</p>
			<a href='/delete/#{x.id}'>X</a>
		</div>
		"
	}
	html
end

post "/post" do
	@post = Post.create(
		:title => "My first DataMapper post",
		:body => "#{params["inputOne"]}",
		:created_at => Time.now
		)
	redirect "/post"
end

get "/delete/:id" do
	post_to_delete = Post.get(params["id"])
	post_to_delete.destroy
	redirect "/post"
end