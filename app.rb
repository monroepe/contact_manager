require 'sinatra'
require 'sinatra/reloader'
require "sinatra/activerecord"
require 'pry'

LIMIT = 4

require_relative 'models/contact'

helpers do
  def on_last_page?(page_num)
    page_num < (Contact.all.length.to_f / LIMIT).ceil
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

  @contacts = Contact.limit(LIMIT).offset((@page_num - 1) * 4)
  erb :'contacts/index'
end

get '/contacts/:id' do
    @contact = Contact.find(params[:id])
  erb :'contacts/show'
end

get '/search' do
  search = "%#{params[:search].gsub(' ','')}%"
  @contacts = Contact.where("CONCAT(first_name, last_name) ilike :search ", { search: search })
  erb :'search/index'
end

get '/new_contact' do
  erb :'new_contact/index'
end

post '/new_contact' do
  first_name = params[:first_name]
  last_name = params[:last_name]
  phone_number = params[:phone_number]
  new_contact = Contact.create(first_name: first_name, last_name: last_name, phone_number: phone_number)
  new_contact.save
  redirect '/'
end




