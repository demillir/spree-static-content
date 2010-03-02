module ContentControllerOverride
  #caches_action :show

  def self.included(target)
    target.class_eval do
      alias :spree_show :show
      def show; static_show; end
    end 
  end

  def static_show
    path = case params[:path]
    when Array
      '/' + params[:path].join("/")
    when String
      params[:path]
    when nil
      request.path
    end

    unless @page = Page.visible.find_by_slug(path)
      render :action => params[:path].join('/')
    end
  end 
end
