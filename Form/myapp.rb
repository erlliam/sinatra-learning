# myapp.rb
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/database.db")

class Post
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :body, Text
	property :created_at, DateTime
end

class User
	include DataMapper::Resource
	property :id, Serial
	property :username, String
	property :password, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions

get "/" do
	erb :index
end

get "/post" do
	@Post = Post
	erb :post
end

post "/post" do
	@status_message = "Login to post!"
	@Post = Post
	if session[:user_id]
		@post = Post.create(
			:title => "My first DataMapper post",
			:body => "#{params["inputOne"]}",
			:created_at => Time.now)
		@status_message = "Successfully posted."
	end

	erb :post
end

get "/delete/:id" do
	Post.get(params["id"]).destroy
	redirect "/post"
end

get "/signup" do
	erb :signup
end

post "/signup" do
	@user = User.create(
		:username => params["username"],
		:password => params["password"])
	redirect "/login"
end

get "/login" do
	if session[:user_id]
		redirect "/"
	end
	erb :login
end

post "/login" do
	username = params["username"]
	password = params["password"]

	User.all.each do |x|
		if username == x.username && password == x.password
			session[:user_id] = username
		end
	end
	redirect "/"
end
