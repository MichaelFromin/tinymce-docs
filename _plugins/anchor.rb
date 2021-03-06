module Jekyll
  module AnchorFilter
    def anchor(input)
      input.gsub(/[^a-zA-Z]/, "").downcase if !input.nil?
    end
  end
end

Liquid::Template.register_filter(Jekyll::AnchorFilter)
