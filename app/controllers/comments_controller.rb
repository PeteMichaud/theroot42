class CommentsController < ApplicationController
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        @comment = CommentDecorator.decorate(@comment)
        format.html { render 'comments/show', layout: false, status: 200 }
      else
        format.html { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  def update
    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { head :no_content }
      else
        format.html { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def tag_comment
    @comment
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { head :no_content }
    end
  end
end
