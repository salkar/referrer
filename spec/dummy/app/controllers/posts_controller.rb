class PostsController < ApplicationController
  def index
    render json: Post.all.to_json
  end

  def create
    render json: Post.create!(post_params.merge(user: current_user)).to_json
  end

  def new
    render json: Post.new.to_json
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
