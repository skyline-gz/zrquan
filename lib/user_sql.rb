module UserSql
  POSTS_LIST =
      "select
          p.content,
          p.created_at,
          p.comment_count,
          p.agree_score,
          p.comment_agree,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          posts p
          inner join users u on (p.user_id = u.id)
        where u.id = ?
        order by p.created_at desc"

  ANSWERS_LIST =
      "select
          a.content,
          a.created_at,
          a.agree_score,
          q.title,
          q.answer_count,
          q.follow_count,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          answers a
          inner join questions q on (a.question_id = q.id)
          inner join users u on (a.user_id = u.id)
        where u.id = ?
        order by a.created_at desc"

  F_QUESTIONS_LIST =
      "select q.title, q.answer_count, q.follow_count
        from
          question_follows qf
          inner join questions q on qf.question_id = q.id
        where qf.user_id = ?
        order by qf.created_at desc"

  F_THEMES_LIST =
      "select t.name, t.description, t.substance_type
        from
          theme_follows tf
          inner join themes t on tf.theme_id = t.id
        where tf.user_id = ?
        order by tf.created_at desc"

  DRAFTS_LIST =
      "select q.title, ad.content, ad.created_at
        from
          answer_drafts ad
          inner join questions q on ad.question_id = q.id
        where ad.user_id = 4
        order by ad.created_at desc"

  BOOKMARKED_QUESTIONS =
      "select
          bm.id,
          q.title,
          q.created_at,
          q.answer_count,
          q.follow_count,
          q.answer_agree,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          bookmarks bm
          inner join questions q on (bm.bookmarkable_id = q.id and bm.bookmarkable_type = 'Question')
          inner join users u on (q.user_id = u.id)
        where bm.user_id = ?
        order by bm.created_at desc"

  BOOKMARKED_POSTS =
      "select
          bm.id,
          p.content,
          p.created_at,
          p.comment_count,
          p.agree_score,
          p.comment_agree,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          bookmarks bm
          inner join posts p on (bm.bookmarkable_id = p.id and bm.bookmarkable_type = 'Post')
          inner join users u on (p.user_id = u.id)
        where bm.user_id = ?
        order by bm.created_at desc"

  FOLLOWERS_LIST =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          relationships r
          inner join users u on r.follower_id = u.id
        where
          r.following_user_id = ?
        order by r.created_at desc"

  FOLLOWING_LIST =
      "select
          u.name as user_name,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major,
          u.avatar,
          u.description
        from
          relationships r
          inner join users u on r.following_user_id = u.id
        where
          r.follower_id = ?
        order by r.created_at desc"

  QUESTIONS_LIST =
      "select
          q.title,
          q.created_at,
          q.answer_count,
          q.follow_count,
          q.answer_agree,
          u.name,
          u.avatar,
          u.latest_company_name,
          u.latest_position,
          u.latest_school_name,
          u.latest_major
        from
          questions q
          inner join users u on (q.user_id = u.id)
        where u.id = ?
        order by q.created_at desc"

  POST_COMMENT_OP =
      "select sum(co.oppose_score) as num
        from POST_COMMENTS co
        where
          co.user_id = ? and
          co.anonymous_flag = 0"

  POST_OP =
      "select sum(po.oppose_score) as num
        from POSTS po
        where
          po.user_id = ? and
          po.anonymous_flag = 0"

  ANSWER_OP =
      "select sum(an.oppose_score) as num
        from ANSWERS an
        where
          an.user_id = ? and
          an.anonymous_flag = 0"

  POST_COMMENT_AG =
      "select sum(pc.agree_score) as num
        from POST_COMMENTS pc
        where
          pc.user_id = ? and
          pc.anonymous_flag = 0"

  POST_AG =
      "select sum(po.agree_score) as num
        from POSTS po
        where
          po.user_id = ? and
          po.anonymous_flag = 0"

  ANSWER_AG =
      "select sum(an.agree_score) as num
        from ANSWERS an
        where
          an.user_id = ? and
          an.anonymous_flag = 0"
end