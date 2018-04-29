# myapp.rb
require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/database.db")

class Post
	include DataMapper::Resource
	property :id, Serial
	property :author, String
	property :body, Text
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
	if session[:user_id] 
		session[:flash] = "Logged in as #{session[:user_id]}."
	end
	erb :index
end

get "/post" do
	erb :post
end

post "/post" do
	if session[:user_id]
		Post.create(
			:author => session[:user_id],
			:body => "#{params["inputOne"]}")
		session[:flash] = "Successfully posted."
	else
		session[:flash] = "Must be logged in to post."
		redirect "/"
	end

	redirect "/post"
end

get "/delete/:id" do
	if session[:user_id] == Post.get(params["id"]).author
		Post.get(params["id"]).destroy
		redirect "/post"
	else
		session[:flash] = "You must be the owner of the post to delete it."
		redirect "/post"
	end
end

get "/signup" do
	erb :signup
end

post "/signup" do
	@user = User.create(
		:username => params["username"],
		:password => params["password"])
	redirect "/login"
	session[:flash] = "Signed up Successfully"

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

	if session[:user_id] 
		redirect "/"
		session[:flash] = "Successfully logged in!"

	else
		redirect "/login"
		session[:flash] = "Failed to login."

	end
end

get "/logout" do
	session.delete(:user_id)
	session[:flash] = "Logged out."
	redirect "/"
end