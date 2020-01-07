require 'spec_helper'

describe '#Artist' do

  before(:each) do
    Artist.clear
    Song.clear
  end

  describe('.all') do
    it("returns an empty array when there are no albums") do
      expect(Artist.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves an album") do
      album = Artist.new({:name => "ODB", :id => nil})
      album.save()
      album2 = Artist.new({:name => "Deltron", :id => nil})
      album2.save()
      expect(Artist.all).to(eq([album, album2]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Artist.new({:name => "ODB", :id => nil})
      album.save()
      album2 = Artist.new({:name => "Deltron", :id => nil})
      album2.save()
      Artist.clear
      expect(Artist.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      album = Artist.new({:name => "Deltron", :id => nil})
      album2 = Artist.new({:name => "Deltron", :id => nil})
      expect(album).to(eq(album2))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Artist.new({:name => "ODB", :id => nil})
      album.save()
      album2 = Artist.new({:name => "Deltron", :id => nil})
      album2.save()
      expect(Artist.find(album.id)).to(eq(album))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Artist.new({:name => "ODB", :id => nil})
      album.save()
      album2 = Artist.new({:name => "Deltron", :id => nil})
      album2.save()
      album.delete()
      expect(Artist.all).to(eq([album2]))
    end
  end

  # describe('#songs') do
  #   it("returns an album's songs") do
  #     album = Artist.new({:name => "ODB", :id => nil})
  #     album.save()
  #     song = Song.new({:name => "BlackStar", :album_id => album.id, :id => nil})
  #     song.save()
  #     song2 = Song.new({:name => "Lootpack", :album_id => album.id, :id => nil})
  #     song2.save()
  #     expect(album.songs).to(eq([song, song2]))
  #   end
  # end

  describe('.search') do
    it("searches for an album by name") do
      album = Artist.new({:name => "ODB", :id => nil})
      album.save()
      album2 = Artist.new({:name => "Deltron", :id => nil})
      album2.save()
      album3 = Artist.new({:name => "Deltron2020", :id => nil})
      album3.save()
      expect(Artist.search("deltron")).to(eq([album2, album3]))
    end
  end

  describe('.sort') do
    it("sorts albums by name") do
      album = Artist.new({:name => "Deltron", :id => nil})
      album.save()
      album2 = Artist.new({:name => "Slum Village", :id => nil})
      album2.save()
      album3 = Artist.new({:name => "ODB", :id => nil})
      album3.save()
      expect(Artist.sort()).to(eq([album, album3, album2]))
    end
  end

  describe('#update') do
    it("adds an album to an artist") do
      artist = Artist.new({:name => "Madlib", :id => nil})
      artist.save()
      album = Album.new({:name => "A Love Supreme", :id => nil})
      album.save()
      artist.update({:album_name => "A Love Supreme"})
      expect(artist.albums).to(eq([album]))
    end
  end

  describe('#update') do
    it("creates an artist for an album") do
      artist = Artist.new({:name => "Madlib", :id => nil})
      artist.save()
      artist.update({:album_name => "A Love Supreme", :artist_name => "Madlib"})
      album = Album.new({:name => "A Love Supreme", :id => nil})
      expect(artist.albums).to(eq([album]))
    end
  end
end
