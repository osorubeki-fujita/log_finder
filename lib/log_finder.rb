class LogFinder

  def initialize( filename , read_length , number_of_lines )
    raise unless filename.instance_of?( ::String )
    raise unless read_length.integer?
    @filename = filename
    @read_length = read_length
    @number_of_lines = number_of_lines
    @search_by = nil

    set_array
  end

  def search_by( regexp )
    raise unless regexp.instance_of?( ::String ) or regexp.instance_of?( ::Regexp )
    @search_by = regexp
    n = row_number
    unless n.nil?
      from_n = Math.max( 0 , n - 10 )
      to_n = Math.min( n + 100 , @ary.length )
      unless from_n == n
        puts @ary[ from_n..( n - 1 ) ]
        puts ""
      end
      puts @ary[n]
      unless to_n == n
        puts ""
        puts @ary[ ( n + 1 )..to_n ]
      end
      puts ""
      puts "=" * 64
      puts "displayed from \##{ from_n } to \##{ to_n }"
    else
      puts "No row matched with #{ @search_by.inspect }"
    end
  end

  def self.search_by(
    regexp ,
    filename ,
    read_length: 256 * 1024 ,
    number_of_lines: nil
  )
    self.new( filename , read_length , number_of_lines ).search_by( regexp )
  end

  private

  #--------

  def set_array
    @ary = []
    f = File.open( @filename , "r:utf-8" )
    begin
      f.seek( - @read_length , ::IO::SEEK_END )
    rescue
    end

    set_each_row_to_array(f)
    f.close
  end

  def set_each_row_to_array(f)
    str = ""
    i = 0
    while to_read_next_line?( str , i )
      str = f.gets
      i += 1
      @ary << str
    end
  end

  def to_read_next_line?( str , i )
    is_not_at_end_of_the_file?( str ) and ( number_of_files_is_not_limitted? or ( number_of_files_is_limitted? and i < @number_of_lines ) )
  end

  def is_at_end_of_the_file?( str )
    str.nil?
  end
  
  def is_not_at_end_of_the_file?( str )
    !( is_at_end_of_the_file?( str ) )
  end

  def number_of_files_is_limitted?
    !( number_of_files_is_not_limitted? )
  end

  def number_of_files_is_not_limitted?
    @number_of_lines.nil?
  end

  #--------

  def row_number
    n = nil
    @ary.each_with_index do | row , i |
      if @search_by === row
        n = i
        break
      end
    end
    return n
  end

end
