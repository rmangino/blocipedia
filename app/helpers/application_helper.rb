module ApplicationHelper
  @@redcarpet_renderer_instance = nil

  def form_group_tag(errors, &block)
    if errors.any?
      content_tag :div, capture(&block), class: 'form-group has-error'
    else
      content_tag :div, capture(&block), class: 'form-group'
    end
  end

  def redcarpet_renderer
    @@redcarpet_renderer_instance ||= Redcarpet::Render::HTML.new
  end

  def markdown_to_html(markdown)
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(redcarpet_renderer, extensions)
    (redcarpet.render markdown).html_safe
  end

end
