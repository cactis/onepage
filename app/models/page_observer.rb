class PageObserver < ActiveRecord::Observer

  def after_destroy(record)
    if fork_source = record.fork
      fork_id = fork_source.id
    else
      fork_id = nil
    end

    record.forks.each do |fork|
      fork.update_attributes(:fork_id => fork_id)
    end

    if layout_page = record.layout
      layout_id = layout_page.id
    else
      layout_id = nil
    end
    record.layouts.each do |layout|
      layout.update_attributes(:layout_id => layout_id)
    end
  end

  def after_save(record)
    # not work! don't twigger controller
    # record.layouts.each |layout| layout.touch}
  end
end
