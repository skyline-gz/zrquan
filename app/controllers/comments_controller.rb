require 'returncode_define'
require "date_utils.rb"

class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  SUPPORT_TYPE = %w('Question', 'Answer')

  # 列举评论
  def show
    type = params[:type]
    id = params[:id]

    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      @comment_related_obj = type.constantize.find(id)
      @comments = Comment.where(:commentable_id => id, :commentable_type => type).order('updated_at')
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

    if SUPPORT_TYPE.find { |e| /#{type}/ =~ e }
      @comment_related_obj = type.constantize.find(id)
      if can? :comment, @comment_related_obj
        @comment = current_user.comments.new({:content => content})
        @comment.commentable_type = type
        @comment.commentable_id = id
        @comment.replied_comment_id = replied_comment_id
        @comment.save!

        case type
          when 'Question'
            # 创建消息并发送
            if current_user.user_msg_setting.commented_flag
              @comment_related_obj.user.messages.create!(msg_type: 3, extra_info1_id: current_user.id, extra_info1_type: "User",
                                              extra_info2_id: @comment_related_obj.id, extra_info2_type: "Question")
              # TODO 发送到faye
            end
            # 创建用户行为（评论经验）
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

  # 删除评论
  def destroy

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.permit(:content)
    end		
end
