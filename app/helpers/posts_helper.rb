module PostsHelper
  def get_tags(posts)
    @largestcount = -1
    alltags = Hash.new { |hash, key| hash[key] = 0 }
    posts.each do |post|
      post.tags.each do |tag|
        alltags[tag.name] += 1
        if alltags[tag.name] > @largestcount
          @largestcount = alltags[tag.name]
        end
      end
    end
    alltags.delete_if {|k,v| v == 1}
    alltags
  end

  def get_tag_cloud(posts)
    tags = get_tags(Post.all)

    # max font size is 32, min is 10
    largest_font = Rails.application.config.tag_cloud_largest_font_size
    smallest_font = Rails.application.config.tag_cloud_smallest_font_size

    x_factor = (largest_font - smallest_font) / @largestcount.to_f
    y_shift = @largestcount.to_f*x_factor - largest_font

    results = tags.inject([]) do |a, b|
      a.push([b[1].to_f*x_factor - y_shift, b[0]])
      a
    end
  end

  def latest_videos(posts)
    # reverse sort the posts, return the top 5
    posts.sort { |a, b| b.created_at <=> a.created_at }[0..4]
  end

  def most_popular(posts)
    #sort by votes, return the top 5
    posts.sort { |a, b| b.votes.size <=> a.votes.size }[0..4]
  end

  def duration_to_s(post)
    Time.at(post.duration).utc.strftime("%H:%M:%S")
  end

  def condense_content(post)
    post.content.size == 0 ? '(no description)' : truncate(post.content, :length => 35)
  end

  def render_grid(object_sym, object_list, number_of_columns=3, partial_opts={})
    partial_opts = {:partial => object_sym.to_s} if partial_opts.empty?
    partial_opts[:locals] = {} unless partial_opts[:locals]

    list_size = object_list.size
    number_of_columns_as_f = number_of_columns.to_f
    number_of_rows = (list_size / number_of_columns_as_f).ceil
    width_as_percentage = (100 / number_of_columns_as_f).to_i

    is_end_of_list = false
    result = ''
    for row_i in 0...number_of_rows do
      result += '<div class="row-fluid">'
      for column_i in 0...number_of_columns do
        list_i = column_i + row_i * number_of_columns
        if list_i < list_size
          partial_opts[:locals][object_sym] = object_list[list_i]
          result += "<td width=\"#{width_as_percentage}%\" valign=\"top\">#{render(partial_opts)}</td>"
        else
          result += "<td width=\"#{width_as_percentage}%\"></td>" * (number_of_columns-column_i)
          is_end_of_list = true
          break
        end
      end
      result += '</div>'
      break if is_end_of_list
    end
    raw(result)
  end
end

