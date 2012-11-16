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
        format.html { render 'comments/show', layout: false, status: 200 }
      else
        format.html { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def tag_comment
    @comment.tag_with params[:new_tag_list]
    @comment = @comment.decorate
    respond_to do |format|
      format.html { render 'comments/show', layout: false, status: 200 }
    end
  end

  def vote
    raise "You can only vote as yourself" unless params[:vote][:user_id].to_i == current_user.id

    @vote = Vote.new_or_destroy(params[:vote])

    respond_to do |format|
      if @vote.is_dummy? || @vote.save
        format.html { render 'votes/show', layout: false, status: 200 }
      else
        format.html { render json: @vote.errors, status: :unprocessable_entity }
    end
    end
  end

  def content
    respond_to do |format|
      format.html { render text: @comment.content, status: 200 }
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { head :no_content }
    end
  end
end
