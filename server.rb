require 'sinatra'
require 'shotgun'
require 'data_mapper'
require 'mysql'
require 'dm-mysql-adapter'

DataMapper.setup(
	:default, 
	'mysql://root@localhost/blogs'
)

class Blog
	include DataMapper::Resource
	DataMapper::Property::String.length(3000)
	property :id, Serial
	property :title, String
	property :created, String
	property :edited, String
	property :content, Text
	property :author, String	
end

	DataMapper.finalize.auto_upgrade!


get '/' do 
	@blog = Blog.all
	@blog = @blog.reverse
	erb :index, layout: :layout
end

get '/create' do
	erb :create, layout: :layout
end

post '/createpost' do
	@blog = Blog.new
	time = Time.now
	@blog.title = params[:title]
	@blog.created = params[:created]
	@blog.edited = time
	@blog.created = time
	@blog.content = params[:content]
	@blog.author = params[:author]
	@blog.save
	redirect to '/'
end

get "/displaypost/:id" do
	@displayeditedpost = Blog.get params[:id]
	erb :viewspage, layout: :layout
end

get "/displaypost/edit/:id" do
	@displayeditedpost = Blog.get params[:id]
	erb :edit
end

patch "/edit/:id" do
	editedtime = Time.now
	@blog = Blog.get params[:id]
	@blog.update content:params[:edited]
	@blog.update edited:editedtime
	redirect to '/'
end

delete '/delete_post/:id' do
	@blog = Blog.get params[:id]
	@blog.destroy
	redirect to '/'
end
