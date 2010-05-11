# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class StaticContentExtension < Spree::Extension
  version "0.1"
  description "Static content extension for managing static content."
  url "http://github.com/PeterBerkenbosch/spree-static-content"

  def activate

    Spree::BaseController.class_eval do
      # ProductsHelper needed for seo_url method used when generating
      # taxonomies partial in content/show.html.erb.
      helper :products

      # Returns page.title for use in the <title> element.
      def title_with_page_title_check
        return @page.title if @page && !@page.title.blank?
        title_without_page_title_check
      end
      alias_method_chain :title, :page_title_check
    end

    if not defined?(Spree::ThemeSupport)
      Admin::ConfigurationsController.class_eval do
        before_filter :add_static_pages_links, :only => :index

        def add_static_pages_links
          @extension_links << {
            :link => admin_pages_path,
            :link_text => t('ext_static_content_static_pages'),
            :description => t('ext_static_content_static_pages_desc')
          }
        end
      end
    end
  end
end
