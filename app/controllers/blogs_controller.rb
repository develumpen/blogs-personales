class BlogsController < ApplicationController
  before_action :set_blog, only: %i[ show ]

  def index
    @blogs = Blog.accepted.order(accepted_at: :desc)
  end

  def show
  end

  def new
    @blog = Blog.new(BlogDataFromUrl.fetch(params[:url]))
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      redirect_to @blog, notice: "Blog añadido correctamente. El proceso de revisión es manual, por lo que puede tardar unos días en aparecer públicamente."
    else
      @blog.feed_urls = BlogDataFromUrl.fetch(@blog.url)[:feed_urls]
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_blog
      @blog = Blog.find(params.expect(:id))
    end

    def blog_params
      params.expect(blog: [ :url, :title, :description, :feed_url, :accepted_at ])
    end
end
