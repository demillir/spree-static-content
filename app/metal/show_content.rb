# This metal file re-routes requests for static content pages to the
# equivalent "/pages/..." path.  Those paths then get handled by this
# extension's StaticContentController.
#
# For example, a request to "/contact" gets re-routed to "/pages/contact"

class ShowContent
  def self.call(env)
    # Only re-route requests to a known slug.
    path = env["PATH_INFO"]
    if @@slugs.include?(path)
      # The new path simply has a '/pages' prefix.
      newPath = "/pages" + path
      
      # Perform the re-route by modifying the given "env" hash.
      env["PATH_INFO"] = env["REQUEST_URI"] = newPath
    end
    
    # Regardless of whether we re-routed, returning a 404 will continue the
    # normal processing of this request by the Metal/Rails infrastructure.
    [404, {"Content-Type" => "text/html"}, "Not Found"]
  end
  
  private
  
  def self.load_slugs
    Page.all.map(&:slug)
  end

  # Cache the slugs of interest so we don't hit the database with every request.
  #
  # TODO: Put an observer on the Pages table such that when the table's contents
  # change, we reload the slugs.  Until then, changing a slug or adding a
  # new page requires rebooting the Rails service.
  @@slugs = load_slugs
end
