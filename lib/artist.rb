class Artist
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != '')
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    end
    album_name = attributes.fetch(:album_name)
    if album_name != nil
      album = DB.exec("SELECT * FROM albums WHERE lower(name) =  '#{album_name.downcase}';").first
      if album == nil
        new_album = Album.new({:name => "#{album_name}", :id => nil})
        new_album.save()
        album = DB.exec("SELECT * FROM albums WHERE id = #{new_album.id};").first
      end
      DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
    end
  end

  def self.get_artists(db_query)
    returned_artists = DB.exec(db_query)
    artists = []
    returned_artists.each() do |artist|
      name = artist.fetch('name')
      id = artist.fetch('id').to_i
      artists.push(Artist.new({:name => name, :id => id}))
    end
    artists
  end

  def self.all
    self.get_artists('SELECT * FROM artists;')
  end

  def self.all_sold
    self.get_artists('SELECT * FROM sold_artists;')
  end

  def save
    result = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def ==(artist_to_compare)
    self.name() == artist_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM artists *;")
  end

  def self.find(id)
    artist = DB.exec("SELECT * FROM artists WHERE id = #{id};").first
    name = artist.fetch('name')
    id = artist.fetch('id').to_i
    Artist.new({:name => name, :id => id})
  end

  def self.search(search)
    self.get_artists("SELECT * FROM artists WHERE lower(name) LIKE '%#{search}%';")
  end

  def self.sort()
    self.get_artists('SELECT * FROM artists ORDER BY lower(name);')
  end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id};")
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def albums
    results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id}")
    id_string = results.map{ |result| result.fetch("album_id")}.join(', ')
    (id_string != '') ?
      Album.get_albums("SELECT * FROM albums WHERE id IN (#{id_string});") :
      nil
  end

  def self.random
    self.get_artists('SELECT * FROM artists ORDER BY RAND() LIMIT 1;')
  end
end
