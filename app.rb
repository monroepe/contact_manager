require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require 'pry'

require_relative 'models/contact'

helpers do
  def on_last_page?(page_num)
    page_num < (Contact.all.length.to_f / 5).ceil
  end

  def on_first_page?(page_num)
    page_num == 1
  end
end

get '/' do
  if params[:page]
    @page_num = params[:page].to_i
  else
    @page_num = 1
  end

  @contacts = Contact.limit(3).offset((@page_num - 1) * 3)
  erb :'contacts/index'
end

get '/contacts/:id' do
    @contact = Contact.find(params[:id])
  erb :'contacts/show'
end

get '/search' do
  @contact = Contact.where("last_name = ?", params[:search])
  erb :'search/index'
end



