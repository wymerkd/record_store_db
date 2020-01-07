class Album
  attr_accessor :name
  attr_reader :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.get_albums(db_query)
    returned_albums = DB.exec(db_query)
    albums = []
    returned_albums.each() do |album|
      name = album.fetch('name')
      id = album.fetch('id').to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def self.all
    self.get_albums('SELECT * FROM albums;')
  end

  def self.all_sold
    self.get_albums('SELECT * FROM sold_albums;')
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM albums *;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch('name')
    id = album.fetch('id').to_i
    Album.new({:name => name, :id => id})
  end

  def self.search(search)
    self.get_albums("SELECT * FROM albums WHERE lower(name) LIKE '%#{search}%';")
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
    end
    artist_name = attributes.fetch(:artist_name)
    if artist_name != nil
      artist = DB.exec("SELECT * FROM artists WHERE lower(name) =  '#{artist_name.downcase}';").first
      if artist != nil
        DB.exec("INSERT INTO albums_artists (artist_id, album_id) VALUES (#{artist['id'].to_i}, #{@id});")
      end
    end
  end

  def self.sort()
    self.get_albums('SELECT * FROM albums ORDER BY lower(name);')
  end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE album_id = #{@id};")
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
  end

  def sold
    result = DB.exec("INSERT INTO sold_albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
  end

  def songs
    Song.find_by_album(self.id)
  end

  def self.random
    self.get_albums('SELECT * FROM albums ORDER BY RAND() LIMIT 1;')
  end

  def artists
    results = DB.exec("SELECT artist_id FROM albums_artists WHERE album_id = #{@id}")
    id_string = results.map{ |result| result.fetch("artist_id")}.join(', ')
    (id_string != '') ?
      Artist.get_artists("SELECT * FROM artists WHERE id IN (#{id_string});") :
      nil
  end
end
