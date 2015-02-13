module QuestionSql

  ALL_LIMIT = 500

  # def self.home_question_sql(sort_type)
  #   select_part =
  #       "select
  #           q2.title,
  #           q2.anonymous_flag,
  #           q2.created_at,
  #           q2.answer_count,
  #           q2.answer_agree,
  #           q2.follow_count,
  #           u.name as user_name,
  #           u.latest_company_name,
  #           u.latest_position,
  #           u.latest_school_name,
  #           u.latest_major,
  #           u.avatar,
  #           t.name as theme_name
  #         from
  #           QUESTIONS q2 inner join
  #           (select
  #              qt.question_id,
  #              min(qt.theme_id) as theme_id
  #            from
  #            QUESTION_THEMES qt
  #            inner join THEME_FOLLOWS tf on (qt.theme_id = tf.theme_id and tf.user_id = ?)
  #            group by qt.question_id
  #            order by null
  #           ) t1 on q2.id = t1.question_id
  #           inner join USERS u on q2.user_id = u.id
  #           inner join THEMES t on t1.theme_id = t.id "
  #
  #   where_part = "where q2.PUBLISH_DATE >= ? "
  #
  #   order_part = ""
  #   if sort_type == "hot"
  #     order_part = "order by q2.hot desc "
  #   elsif sort_type == "new"
  #     order_part = "order by q2.created_at desc "
  #   end
  #
  #   limit_part = "limit " + ALL_LIMIT.to_s
  #
  #   select_part + where_part + order_part + limit_part
  # end

  def self.home_question_ids(sort_type)
    select_part =
        "select distinct
          qt.question_id
         from
          QUESTION_THEMES qt
          inner join THEME_FOLLOWS tf on (qt.theme_id = tf.theme_id and tf.user_id = ?) "

    where_part = "where qt.created_at >= ? "

    order_part = ""
    if sort_type == "hot"
      order_part = "order by qt.hot desc "
    elsif sort_type == "new"
      order_part = "order by qt.created_at desc "
    end

    # start = CARDS_PER_PAGE * (page - 1)
    limit_part = "limit " + ALL_LIMIT.to_s

    select_part + where_part + order_part + limit_part
  end

  HOME_QUESTION_SQL =
      "select
        q2.title as question_title,
        q2.anonymous_flag as question_anonymous_flag,
        q2.created_at as question_created_at,
        q2.answer_count,
        q2.answer_agree,
        q2.follow_count,
        qu.name as question_user_name,
        ifnull(qu.latest_company_name, qu.latest_school_name) as question_user_prop1,
        ifnull(qu.latest_position, qu.latest_major) as question_user_prop2,
        qu.avatar as question_user_avatar,
        t.name as theme_name,
        a.content as answer_content,
        a.created_at as answer_created_at,
        a.agree_score as answer_agree_score,
        au.name as answer_user_name,
        ifnull(au.latest_company_name, au.latest_school_name) as answer_user_prop1,
        ifnull(au.latest_position, au.latest_major) as answer_user_prop2,
        au.avatar as answer_user_avatar
      from
        QUESTIONS q2 inner join
        (select
           qt.question_id,
           min(qt.theme_id) as theme_id
        from
          QUESTION_THEMES qt
        where qt.question_id in (?)
        group by qt.question_id
        order by null
        ) t1 on q2.id = t1.question_id
        inner join USERS qu on q2.user_id = qu.id
        inner join ANSWERS a on q2.hottest_answer_id = a.id
        inner join USERS au on a.user_id = au.id
        inner join THEMES t on t1.theme_id = t.id
        order by q2.hot desc"

  SORTED_COMMENTS =
      "select
          c.id,
          c.content,
          c.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from comments c inner join users u on (c.user_id = u.id)
        where c.commentable_id = ? and c.commentable_type = 'Question'
        order by c.created_at DESC"

  SORTED_ANSWERS =
      "select
          a.id,
          a.content,
          a.agree_score,
          a.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from ANSWERS a inner join users u on (a.user_id = u.id)
        where a.question_id = ?
        order by a.actual_score DESC
        limit 10"

  DETAIL =
      "select
          q.title,
          q.content,
          q.created_at,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from questions q inner join users u on (q.user_id = u.id)
        where q.id = ?"

  SUFFICIENT_DAYS =
      "select min(recent_days) as recent_days
        from question_stats qs
        where
          qs.user_id = ? and qs.following_act_count >= ?"

end