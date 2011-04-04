module GitWiki
  class App < Sinatra::Base

    configure do
      set :app_file, __FILE__
      set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    end

    error PageNotFound do
      page = request.env["sinatra.error"].name
      redirect "/#{page}/edit"
    end

    before do
      content_type "text/html", :charset => "utf-8"
    end

    get "/" do
      redirect "/" + GitWiki.homepage
    end

    get "/pages" do
      @pages = Page.find_all
      erb :list
    end

    get "/:page/edit" do
      @page = Page.find_or_create(params[:page])
      erb :edit
    end

    get "/:page" do
      @page = Page.find(params[:page])
      erb :show
    end

    post "/:page" do
      @page = Page.find_or_create(params[:page])
      @page.update_content(params[:body])
      redirect "/#{@page}"
    end

    private
      def title(title=nil)
        @title = title.to_s unless title.nil?
        @title
      end

      def list_item(page)
        %Q{<a class="page_name" href="/#{page}">#{page.name}</a>}
      end
  end
end