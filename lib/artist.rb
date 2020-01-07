class Artist
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    end
    album_name = attributes.fetch(:album_name)
    if album_name != nil
      album = DB.exec("SELECT * FROM albums WHERE lower(name) =  '#{album_name.downcase}';").first
      if album != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end
  end

  def self.get_artists(db_query)
    returned_artists = DB.exec(db_query)
    artists = []
    returned_artists.each() do |artist|
      name = artist.fetch('name')
      id = artist.fetch('id').to_i
      artists.push(Album.new({:name => name, :id => id}))
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
    Album.new({:name => name, :id => id})
  end

  def self.search(search)
    self.get_artists("SELECT * FROM artists WHERE lower(name) LIKE '%#{search}%';")
  end

  def self.sort()
    self.get_artists('SELECT * FROM artists ORDER BY lower(name);')
  end

  def delete
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

  def albums
    albums = []
    results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id}")
    id_array = []
    results.each() do |result|
      album_id = result.fetch("album_id").to_i()
      id_array.push(album_id)
    end
    album_results = DB.exec("SELECT * FROM albums WHERE id in (#{id_array.join(', ')});")
    album_results.each() do |album|
      name = album.fetch("name")
      album_id = album.fetch("id").to_i()
      albums.push(Album.new({:name => name, :id => album_id}))
    end
    albums
  end

  def self.random
    self.get_artists('SELECT * FROM artists ORDER BY RAND() LIMIT 1;')
  end
end
