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
	property :id, Serial
	property :title, String
	property :created, String
	property :edited, String
	property :content, String
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
	@blog.edited = params[:edited]
	@blog.created = "#{time.month}, #{time.day}, #{time.year}"
	@blog.content = params[:content]
	# @blog.content = params content
	@blog.author = params[:author]
	@blog.save
	redirect to '/'
end

get "/displaypost/:id" do
	@displayeditedpost = Blog.get params[:id]
	erb :viewspage, layout: :layout
end

get "/viewpost/edit/:id" do
	@displayeditedpost = Blog.get params[:id]
	erb :edit
end


patch "/edit/:id" do
	@blog = blog.id params[:content]
	blog.update
	redirect to '/'
end


