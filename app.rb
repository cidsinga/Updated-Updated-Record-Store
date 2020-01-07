require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('pry')
require ('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "record_store"})

get('/') do
  redirect to('/albums')
end

get('/albums') do

  if params["search"]
    @albums = Album.search(params[:search])
  elsif params["sort"]
    @albums = Album.sort()
  else
    @albums = Album.all
  end
  erb(:albums)
end

# Look below for problems
get('/artists') do
  if params["search"]
    @artists = Artist.search(params[:search])
  elsif params["sort"]
    @artists = Artist.sort()
  else
    @artists = Artist.all
  end
  erb(:artists)
end

post('/artists') do
  name = params[:artist_name]
  artist = Artist.new({:name => name, :id => nil})
  artist.save()
  redirect to('/artists')
end

patch('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.update(params[:name])
  redirect to('/artists')
end

delete('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.delete()
  redirect to('/artists')
end

get('artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  if @artist != nil
    erb(:artist)
  else
    erb(:album_error)
  end
end



get ('/albums/new') do
  erb(:new_album)
end

post ('/albums') do
  name = params[:album_name]
  album = Album.new({:name => name, :id => nil})
  album.save()
  redirect to('/albums')
end

get ('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  if @album != nil
    erb(:album)
  else
    erb(:album_error)
  end
  # erb(:album)
end

get ('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch ('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  redirect to('/albums')
end

delete ('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  redirect to('/albums')
end

get ('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  if @song != nil
    erb(:song)
  else
    @album = Album.find(params[:id].to_i())
    erb(:album_error)
  end
  # erb(:song)
end

post ('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new({:name => params[:song_name], :album_id => @album.id, :id => nil})
  song.save()
  erb(:album)
end

patch ('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

delete ('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end
