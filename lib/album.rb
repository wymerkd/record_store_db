class Album
  attr_accessor :name
  attr_reader :id

  @@albums = {}
  @@albums_sold = {}
  @@total_rows = 0

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id) || @@total_rows += 1
  end

  def self.all
    @@albums.values()
  end
  def self.all_sold
    @@albums_sold.values()
  end

  def save
    @@albums[self.id] = Album.new({ :name => self.name, :id => self.id })
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    @@albums = {}
    @@total_rows = 0
  end

  def self.find(id)
    @@albums[id]
  end

  def self.search(search)
    result = self.all.map { |a| a if a.name.scan(/#{search}/i).join('') == a.name }
    return result.compact
  end

  def update(name)
    self.name = name
    @@albums[self.id] = Album.new({ :name => self.name, :id => self.id })
  end

  def self.sort()
    sorted_array = []
    self.all.each do |a|
      sorted_array.push(a.name)
    end
    results = sorted_array.sort.map { |a|  self.search(a) }
  end

  def delete
    @@albums.delete(self.id)
  end

  def sold
    @@albums_sold[self.id] = @@albums[self.id]
    @@albums.delete(self.id)
  end

  def songs
    Song.find_by_album(self.id)
  end




end
