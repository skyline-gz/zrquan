require 'date_utils.rb'
require 'ranking_utils.rb'
require 'return_code'

class AnswersController < ApplicationController
  before_action :set_answer, only: [:update, :agree, :cancel_agree, :oppose, :cancel_oppose]
  before_action :set_question, only: [:create, :agree, :cancel_agree, :oppose, :cancel_oppose]
  before_action :authenticate_user

  # 创建
  def create
    if can? :answer, @question
      # 创建答案
      @answer = current_user.answers.new(answer_params)
      @answer.question_id = @question.id
      @answer.edited_at = Time.now
      if @answer.save
        # 删除已创建草稿
        answer_draft = AnswerDraft.find_by(:user_id => current_user.id, :question_id => @question.id)
        is_answer_draft_deleted = (answer_draft != nil ? answer_draft.destroy.destroyed? : true)
        # 更新问题
        new_weight = @question.weight + 3
        if @question.hottest_answer_id != nil
          is_question_updated = @question.update(
              weight: new_weight,
              hot: RankingUtils.question_hot(new_weight, @question.epoch_time),
              answer_count: @question.answer_count + 1
          )
        else
          is_question_updated = @question.update(
              weight: new_weight,
              hot: RankingUtils.question_hot(new_weight, @question.epoch_time),
              answer_count: @question.answer_count + 1,
              hottest_answer_id: @answer.id
          )
        end
        # 创建回答问题消息并发送
        MessagesAdapter.perform_async(MessagesAdapter::ACTION_TYPE[:USER_ANSWER_QUESTION], current_user.id, @question.id)

        # 创建用户行为（回答问题）
        is_activities_saved = save_activities(@answer.id, "Answer", @question.id, "Question", 2)

        if is_answer_draft_deleted and is_question_updated and is_activities_saved
          redirect_to :controller => 'questions',:action => 'show', :id => @question.token_id
          # TODO json 成功
        else
          render :json => {:code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR}
        end
      else
        render :json => {:code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR}
      end
    else
      render :json => {:code => ReturnCode::FA_UNAUTHORIZED}
    end
  end

  # 更新
  def update
    # 更新答案
    @answer.edited_at = Time.now
    if @answer.update(answer_params)
      # TODO json 成功
      redirect_to :controller => 'questions',:action => 'show'#, :id => @question.token_id
    else
      # TODO json 失败
    end
  end

	# 赞同
  def agree
    if can? :agree, @answer
      # 取消反对
      cancel_result = Opposition.where(
          "opposable_id = ? and opposable_type = ? and user_id = ?",
          @answer.id, "Answer", current_user.id
      ).destroy_all
      # 成功赞成
      agreement = current_user.agreements.new(
          agreeable_id: @answer.id, agreeable_type: "Answer")
      is_agreement_saved = agreement.save

      # 更新投票
      agree_score = @answer.agree_score + 1
      actual_score = @answer.actual_score + 1
      is_answer_updated = @answer.update(
          agree_score: agree_score,
          actual_score: actual_score
      )

      # 更新问题相关信息
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @question.weight + 1
      answer_agree = @question.answer_agree + 1
      hot = RankingUtils.question_hot(new_weight, @question.epoch_time)
      is_question_updated = agree_update_question(new_weight, hot, answer_agree, to_update_hottest_id)

      # 更新question_theme
      QuestionTheme.where("question_id = ?", @question.id).update_all(hot: hot)

      # # 创建赞同答案的消息并发送
      # MessagesAdapter.perform_async(MessagesAdapter::ACTION_TYPE[:USER_AGREE_ANSWER], current_user.id, @answer.id)

      if cancel_result > 0 and is_agreement_saved and is_answer_updated and is_question_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 取消赞同
  def cancel_agree
    if can? :cancel_agree, @answer
      # 取消
      cancel_result = Agreement.where(
          "agreeable_id = ? and agreeable_type = ? and user_id = ?",
          @answer.id, "Answer", current_user.id
      ).destroy_all

      # 更新投票和排名因子
      agree_score = @answer.agree_score - 1
      actual_score = @answer.actual_score - 1
      is_answer_updated = @answer.update!(
          agree_score: agree_score,
          actual_score: actual_score
      )

      # 更新问题相关信息
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @question.weight - 1
      answer_agree = @question.answer_agree - 1
      hot = RankingUtils.question_hot(new_weight, @question.epoch_time)
      is_question_updated = agree_update_question(new_weight, hot, answer_agree, to_update_hottest_id)

      # 更新question_theme
      QuestionTheme.where("question_id = ?", @question.id).update_all(hot: hot)

      if cancel_result > 0 and is_answer_updated and is_question_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 反对
  def oppose
    if can? :oppose, @answer
      # 取消赞成
      cancel_result = Agreement.where(
          "agreeable_id = ? and agreeable_type = ? and user_id = ?",
          @answer.id, "Answer", current_user.id
      ).destroy_all
      # 反对
      op = current_user.oppositions.new(
          opposable_id: @answer.id, opposable_type: "Answer")
      is_opposition_saved = op.save

      # 更新投票和排名因子
      oppose_score = @answer.oppose_score + 1
      actual_score = @answer.actual_score - 1
      is_answer_updated = @answer.update(
          oppose_score: oppose_score,
          actual_score: actual_score
      )

      # 更新投票和排名因子
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @question.weight - 1
      hot = RankingUtils.question_hot(new_weight, @question.epoch_time)
      is_question_updated = oppose_update_question(new_weight, hot, to_update_hottest_id)

      # 更新question_theme
      QuestionTheme.where("question_id = ?", @question.id).update_all(hot: hot)

      if cancel_result > 0 and is_opposition_saved and is_answer_updated and is_question_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  # 取消反对
  def cancel_oppose
    if can? :cancel_oppose, @answer
      # 取消
      cancel_result = Opposition.where(
          "opposable_id = ? and opposable_type = ? and user_id = ?",
          @answer.id, "Answer", current_user.id
      ).destroy_all

      # 更新排名因子
      oppose_score = @answer.oppose_score - 1
      actual_score = @answer.actual_score + 1
      is_answer_updated = @answer.update(
          oppose_score: oppose_score,
          actual_score: actual_score
      )

      # 更新排名因子
      to_update_hottest_id = get_to_update_hottest(actual_score)
      new_weight = @question.weight + 1
      hot = RankingUtils.question_hot(new_weight, @question.epoch_time)
      is_question_updated = oppose_update_question(new_weight, hot, to_update_hottest_id)

      # 更新question_theme
      QuestionTheme.where("question_id = ?", @question.id).update_all(hot: hot)

      if cancel_result > 0 and is_answer_updated and is_question_updated
        render :json => { :code => ReturnCode::S_OK }
      else
        render :json => { :code => ReturnCode::FA_WRITING_TO_DATABASE_ERROR }
      end
    else
      render :json => { :code => ReturnCode::FA_UNAUTHORIZED }
    end
  end

  private
    # 看看是否需要更新question里面的hottest_answer,如果需要返回id
    def get_to_update_hottest(actual_score)
      to_update_hottest_id = nil
      if @question.hottest_answer_id != @answer.id
        finished_sql = SqlUtils.escape_sql(AnswerSql::ID_AND_SCORE, @question.hottest_answer_id)
        hottest_answer = ActiveRecord::Base.connection.select_all(finished_sql)
        score = hottest_answer[0]["score"]
        if actual_score > score
          to_update_hottest_id = @answer.id
        end
      end
      to_update_hottest_id
    end

    def agree_update_question(weight, hot, answer_agree, to_update_hottest_id)
      if to_update_hottest_id != nil
        is_question_updated = @question.update(
            weight: weight,
            hot: hot,
            answer_agree: answer_agree,
            hottest_answer_id: to_update_hottest_id
        )
      else
        is_question_updated = @question.update(
            weight: weight,
            hot: hot,
            answer_agree: answer_agree
        )
      end
      is_question_updated
    end

    def oppose_update_question(weight, hot, to_update_hottest_id)
      if to_update_hottest_id != nil
        is_question_updated = @question.update(
            weight: weight,
            hot: hot,
            hottest_answer_id: to_update_hottest_id
        )
      else
        is_question_updated = @question.update(
            weight: weight,
            hot: hot
        )
      end
      is_question_updated
    end

    def save_activities(target_id, target_type, sub_target_id, sub_target_type, activity_type)
      act = current_user.activities.new
      act.target_id = target_id
      act.target_type = target_type
      act.activity_type = activity_type
      act.sub_target_id = sub_target_id
      act.sub_target_type = sub_target_type
      act.publish_date = DateUtils.to_yyyymmdd(Date.today)
      act.save
    end

    def set_answer
      @answer = Answer.find_by_token_id(params[:id])
    end

    def set_question
      @question = Question.find_by_token_id(params[:question_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:content)
    end		
end
