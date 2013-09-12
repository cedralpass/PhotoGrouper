require_relative 'photo_grouper'

pg = PhotoGrouper.new(Dir.home + '/Pictures/', '2013_', {:secondary_match => "good"})
pg.consolidate
pg.copy(Dir.home + '/Pictures/Best_of_2013')
