require 'returncode_define'
require 'date_utils.rb'

class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  SUPPORT_TYPE = %w('Question', 'Answer')

  # 列举评论
  def show
    type = params[:type]
    id = params[:id]

    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      @comment_related_obj = type.constantize.find_by_token_id(id)
      @comments = Comment.where(:commentable_id => @comment_related_obj.id, :commentable_type => type).order('updated_at')
      render 'comments/show'
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  # 创建评论
  def create
    type = params[:type]
    id = params[:id]
    content = ActionController::Base.helpers.strip_tags params[:content]
    replied_comment_id = params[:replied_comment_id]

    if replied_comment_id && Comment.find(replied_comment_id) == nil
        render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
        return
    end

    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      @comment_related_obj = type.constantize.find_by_token_id(id)
      if can? :comment, @comment_related_obj
        @comment = current_user.comments.new({:content => content})
        @comment.commentable_type = type
        @comment.commentable_id = @comment_related_obj.id
        @comment.replied_comment_id = replied_comment_id
        @comment.save!

        case type
          when 'Question'
            # 创建消息并发送
            MessagesAdapter.perform_async(MessagesAdapter::ACTION_TYPE[:USER_COMMENT_QUESTION], current_user.id, @comment_related_obj.id)

            # 创建用户行为（评论问题）
            current_user.activities.create!(target_id: @comment_related_obj.id, target_type: "Question", activity_type: 4,
                                            publish_date: DateUtils.to_yyyymmdd(Date.today))
          when 'Answer'
            # 创建消息并发送
            if current_user.user_msg_setting.commented_flag
              @comment_related_obj.user.messages.create!(msg_type: 2, extra_info1_id: current_user.id, extra_info1_type: "User",
                                            extra_info2_id: @comment_related_obj.id, extra_info2_type: "Answer")
              # TODO 发送到faye
            end
            # 创建用户行为（评论答案）
            current_user.activities.create!(target_id: @comment_related_obj.id, target_type: "Answer", activity_type: 3,
                                            publish_date: DateUtils.to_yyyymmdd(Date.today))
          else
        end
        @comments = [@comment]
        render 'comments/show'
        return
      else
        render :json => {:code => ReturnCode::FA_UNAUTHORIZED}
        return
      end
    else
      render :json => {:code => ReturnCode::FA_NOT_SUPPORTED_PARAMETERS}
    end
  end

  # 删除评论,param 评论的id
  def destroy
    id = params[:id]
    if id == nil
      render :json => {:code => ReturnCode::FA_INVALID_PARAMETERS}
    end
    @comment = Comment.find id
    if can? :delete, @comment
      @comment.destroy
      render :json => {:code => ReturnCode::S_OK}
    else
      render :json => {:code => ReturnCode::FA_UNAUTHORIZED}
    end
  end


  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.permit(:content)
    end
end
