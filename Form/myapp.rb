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
	erb :index, :locals => {:user => session[:user]}
end

get "/post" do
	erb :post, :locals => {:post => Post, :user => session[:user]}
end

post "/post" do
	@post = Post.create(
		:title => "My first DataMapper post",
		:body => "#{params["inputOne"]}",
		:created_at => Time.now)
	redirect "/post"
end

get "/delete/:id" do
	Post.get(params["id"]).destroy
	redirect "/post"
end

get "/signup" do
	erb :signup, :locals => {:user => session[:user]}
end

post "/signup" do
	@user = User.create(
		:username => params["username"],
		:password => params["password"])
	redirect "/login"
end

get "/login" do
	erb :login, :locals => {:user => session[:user]}
end

post "/login" do
	session[:user] = params["username"]
	redirect "/"
end
