# myapp.rb
require "sinatra"
require "data_mapper"
require "bcrypt"

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
	property :password_hash, String, :length => 60
	property :posts, Integer
end

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions

def user()
	User.get(session[:id])
end


get "/" do
	if user
		session[:flash] = "Logged in as #{user.username}."
	end
	erb :index
end

get "/post" do
	erb :post
end

post "/post" do
	if user
		Post.create(
			:author => user.username,
			:body => "#{params["inputOne"]}")
		user.update(:posts => user.posts + 1)
		session[:flash] = "Successfully posted."
	else
		session[:flash] = "Must be logged in to post."
		redirect "/"
	end

	redirect "/post"
end

get "/delete/:id" do
	if user && user.username == Post.get(params["id"]).author
		Post.get(params["id"]).destroy
		user.update(:posts =>  user.posts - 1)
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
	user = User.create(
		:username => params["username"],
		:password_hash => BCrypt::Password.create(params["password"]),
		:posts => 0)
	session[:flash] = "Signed up Successfully"
	redirect "/login"

end

get "/login" do
	if user
		redirect "/"
	end
	erb :login
end

post "/login" do
	username = params["username"]
	password = params["password"]
	User.all.each do |x|
		if username == x.username && BCrypt::Password.new(x.password_hash) == password
			session[:id] = x.id
		end
	end

	if user
		session[:flash] = "Successfully logged in!"

		redirect "/"

	else
		session[:flash] = "Failed to login."
		redirect "/login"

	end
end

get "/logout" do
	session.clear
	session[:flash] = "Logged out."
	redirect "/"
end

get "/account" do
	erb :account
end