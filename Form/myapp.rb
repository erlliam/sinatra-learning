# myapp.rb
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite:database.db")

class Post
	include DataMapper::Resource

	property :id, Serial
	property :title, String
	property :body, Text
	property :created_at, DateTime

end

DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!


get "/" do
	erb :index
end

get "/post" do
	erb :post, :locals => {:post => Post}
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