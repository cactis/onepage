class Parse
  def request(url)
    data = 'result'
    uri = URI.parse(url)
    ap uri
    data = Net::HTTP.get uri
    ap data
    doc = Hpricot.parse(data)
    ap doc
    doc.search("[@style]").each do |e|
      # e.remove_attribute('style')
    end

    data = (doc/"body").inner_html
    # data = doc.to_html
    return data
  end
end
