class StaticContentController < Spree::BaseController
  def show
    slug = '/' + (params[:path] || []).join("/")
    if @page = Page.visible.find_by_slug(slug)
      if @page.layout && !@page.layout.empty?
        render :template => 'content/show', :layout => @page.layout
      else
        render :template => 'content/show'
      end
    else
      render :nothing => true, :status => :not_found
    end
  end
end
