require 'spec_helper'

describe '#Album' do

  before(:each) do
    Album.clear
    Song.clear
  end

  describe('.all') do
    it("returns an empty array when there are no albums") do
      expect(Album.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an album") do
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      Album.clear
      expect(Album.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      album = Album.new({:name => "Blue", :id => nil})
      album2 = Album.new({:name => "Blue", :id => nil})
      expect(album).to(eq(album2))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      artist = Artist.new({:name => "Madlib", :id => nil})
      artist.save()
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      album.update({:artist_name => "Madlib"})
      expect(album.artists).to(eq([artist]))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

  describe('#songs') do
    it("returns an album's songs") do
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      song = Song.new({:name => "Naima", :album_id => album.id, :id => nil})
      song.save()
      song2 = Song.new({:name => "Cousin Mary", :album_id => album.id, :id => nil})
      song2.save()
      expect(album.songs).to(eq([song, song2]))
    end
  end

  describe('.search') do
    it("searches for an album by name") do
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      album2 = Album.new({:name => "Blue", :id => nil})
      album2.save()
      album3 = Album.new({:name => "Blues clues", :id => nil})
      album3.save()
      expect(Album.search("blue")).to(eq([album2, album3]))
    end
  end

  describe('.sort') do
    it("sorts albums by name") do
      album = Album.new({:name => "Blue", :id => nil})
      album.save()
      album2 = Album.new({:name => "A Love Supreme", :id => nil})
      album2.save()
      album3 = Album.new({:name => "Moving Pictures", :id => nil})
      album3.save()
      expect(Album.sort()).to(eq([album2, album, album3]))
    end
  end

  describe('#sold') do
    it("sorts albums by name") do
      album = Album.new({:name => "Blue", :id => nil})
      album.save()
      album2 = Album.new({:name => "A Love Supreme", :id => nil})
      album2.save()
      album3 = Album.new({:name => "Moving Pictures", :id => nil})
      album3.save()
      album.sold()
      expect(Album.all_sold).to(eq([album]))
    end
  end
end
