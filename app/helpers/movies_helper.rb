module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ? "odd" : "even"
  end

  def sort_by_params(sort_by)
    
    {
      sort_by: sort_by,
      home: 1,
      ratings: Hash[@ratings_to_show.collect {|v| [v, 1]}]
    }
  end
end